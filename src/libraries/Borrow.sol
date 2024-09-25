// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { State, DebtPosition, ReserveData, InvestReserveData, DebtPositionCollateral } from "../LendingPoolState.sol";
import {ILendingPool} from "../interfaces/ILendingPool.sol";
import {IRewardModule} from "../interfaces/IRewardModule.sol";
import { Events } from "./Events.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import { PriceLib } from "./PriceLib.sol";
import { AccountingLib } from "./AccountingLib.sol";
import { TransferLib } from "./TransferLib.sol";
import { ValveLib } from "./ValveLib.sol";
import { InterestRateModel } from "./InterestRateModel.sol";
import * as Constants from "../constants.sol";

library Borrow {

    using PriceLib for State;
    using TransferLib for State;    
    using AccountingLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    uint256 constant YEAR = 365 * 86400; 
    uint256 constant LENDER_RATE = 30_000;
    uint256 constant BORROWER_RATE = 60_000;
    uint256 constant ALL_RATE = 100_000;

    function depositCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");
        
        // update interest rate model
        state.updateInterestRates();
        InvestReserveData storage reserveData = state.reserveData.totalCollaterals[_collateralToken];
        DebtPositionCollateral storage positionCollateral = state.positionData.debtPositions[msg.sender].collaterals[_collateralToken];
        
        // Update collateral data for the user
        uint256 totalDeposits = reserveData.totalDeposits;
        uint256 collateralAmount = positionCollateral.amount;

        reserveData.totalDeposits = totalDeposits + _amount;
        positionCollateral.amount = collateralAmount + _amount;

        bool isSetRewardModule = _setAccruedRewards(_collateralToken, positionCollateral, collateralAmount);
        
        // Transfer the collateral token from the user to the contract
        state.transferCollateral(_collateralToken, msg.sender, address(this), _amount);

        if (isSetRewardModule)
            positionCollateral.lastAPR = ValveLib.executeInvestOrWithdraw(_collateralToken);
        
        emit Events.CollateralDeposited(msg.sender, _amount);
    }
    
    function withdrawCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate enough collateral to withdraw
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        InvestReserveData storage investData = reserveData.totalCollaterals[_collateralToken];
        DebtPositionCollateral storage positionCollateral = position.collaterals[_collateralToken];
        _validateWithdrawCollateral(state, position, _collateralToken, _amount);

        // update collateral data for the user        
        uint256 totalDeposits = investData.totalDeposits;
        uint256 collateralAmount = positionCollateral.amount;

        investData.totalDeposits = totalDeposits - _amount;
        positionCollateral.amount = collateralAmount - _amount;
        
        bool isSetRewardModule = _setAccruedRewards(_collateralToken, positionCollateral, collateralAmount);        
        if (isSetRewardModule)
            positionCollateral.lastAPR = ValveLib.executeInvestOrWithdraw(_collateralToken);

        // Transfer the collateral token from the user to the contract
        state.transferCollateral(_collateralToken, msg.sender, _amount);


        emit Events.CollateralWithdrawn(msg.sender, _amount);
    }

    function borrow(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();
        
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateBorrow(state, position, _amount);

        uint256 debt = state.getDebtAmount(_amount);
        // update borrow data for user & pool
        // update debt for the user's position
        state.reserveData.totalBorrows += _amount;
        position.totalBorrow += _amount;
        position.borrowAmount += _amount;
        position.debtAmount += debt;
        state.positionData.totalDebt += debt;

        // Transfer the principal token from the contract to the user
        state.transferPrincipal(msg.sender, _amount);

        // IRewardModule rewardModule = ILendingPool(address(this)).getRewardModule(address(state.tokenConfig.principalToken));
        // bool isSetRewardModule = address(rewardModule) != address(0);
        // if (isSetRewardModule)
        //     ValveLib.executeInvestOrWithdraw(address(state.tokenConfig.principalToken));

        emit Events.Borrowed(msg.sender, _amount);
    }

    function _setAccruedRewards(
        address _collateralToken, 
        DebtPositionCollateral storage positionCollateral,
        uint256 collateralAmount
    ) internal returns (bool isSetRewardModule) {
        IRewardModule rewardModule = ILendingPool(address(this)).getRewardModule(_collateralToken);
        isSetRewardModule = address(rewardModule) != address(0);
        if (isSetRewardModule) {
            if (positionCollateral.lastRewardedAt == 0) 
                positionCollateral.lastRewardedAt = block.timestamp;
            else {
                if (collateralAmount != 0) {
                    uint256 reward = collateralAmount.mulWad(positionCollateral.lastAPR).mulDiv(block.timestamp - positionCollateral.lastRewardedAt, YEAR);
                    positionCollateral.accruedRewards += reward.mulDiv(Constants.BORROWER_REWARD_RATE, Constants.TOTAL_RATE);
                    positionCollateral.lastRewardedAt = block.timestamp;
                }
            }
        }
    }

    function _validateWithdrawCollateral(
        State storage state, 
        DebtPosition storage position,
        address _collateralToken,
        uint256 _amount
    ) internal view {
        require(_amount > 0, "InvalidAmount");
        require(_amount <= position.collaterals[_collateralToken].amount, "AmountLarge");
        
        uint256 liquidationThreshold = state.riskConfig.liquidationThreshold;
        
        uint256 borrowAmount = state.getRepaidAmount(position.debtAmount);
        uint256 collateralInUSD = state.getCollateralValueInUSD(position);
        uint256 borrowInUSD = state.getPrincipalValueInUSD(borrowAmount);
        uint256 collateralUsed = borrowInUSD.divWadUp(liquidationThreshold);
        uint256 maxWithdrawAllowed = collateralInUSD - collateralUsed;

        uint256 withdrawInUsd = state.collateralValueInUSD(_collateralToken, _amount); 

        require(withdrawInUsd <= maxWithdrawAllowed, "NotEnoughcollateral");
    }

    function _validateBorrow(
        State storage state, 
        DebtPosition storage position,
        uint256 _amount
    ) internal view {
        require(_amount > state.riskConfig.minimumBorrowToken, "InvalidAmount");

        uint256 loanToValue = state.riskConfig.loanToValue;

        uint256 borrowedAmount = position.borrowAmount;
        uint256 collateralAmount = state.getCollateralValueInPrincipal(position);
        uint256 maxBorrowAllowed = collateralAmount.divWad(loanToValue);        

        require(_amount + borrowedAmount <= maxBorrowAllowed, "NotEnoughCollateral");
        require(_amount + state.reserveData.totalBorrows <= state.riskConfig.borrowTokenCap, "BorrowCapReached");
    }

}