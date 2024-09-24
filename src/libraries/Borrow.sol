// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { State, DebtPosition, ReserveData, InvestReserveData } from "../LendingPoolState.sol";
import { Events } from "./Events.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import { PriceLib } from "./PriceLib.sol";
import { AccountingLib } from "./AccountingLib.sol";
import { TransferLib } from "./TransferLib.sol";
import { ValveLib } from "./ValveLib.sol";
import { InterestRateModel } from "./InterestRateModel.sol";

library Borrow {

    using PriceLib for State;
    using TransferLib for State;    
    using AccountingLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    function depositCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");
        
        // update interest rate model
        state.updateInterestRates();
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        InvestReserveData storage investData = reserveData.totalCollaterals[_collateralToken];

        // Update collateral data for the user
        uint256 totalDeposits = investData.totalDeposits + _amount;
        investData.totalDeposits = totalDeposits;
        position.collaterals[_collateralToken].amount += _amount;

        // Transfer the collateral token from the user to the contract
        state.transferCollateral(_collateralToken, msg.sender, address(this), _amount);

        // uint256 rewardIndex = ValveLib.executeInvestOrWithdraw(_collateralToken);
        // _amount 
        
        emit Events.CollateralDeposited(msg.sender, _amount);
    }
    
    function withdrawCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate enough collateral to withdraw
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateWithdrawCollateral(state, position, _collateralToken, _amount);

        // update collateral data for the user
        position.collaterals[_collateralToken].amount -= _amount;
        reserveData.totalCollaterals[_collateralToken].totalDeposits -= _amount;

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

        emit Events.Borrowed(msg.sender, _amount);
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