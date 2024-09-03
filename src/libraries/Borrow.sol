// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import { Oracle } from "../oracle/Oracle.sol";
import { Events } from "./Events.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import { PriceLib } from "./PriceLib.sol";
import { TransferLib } from "./TransferLib.sol";
import { InterestRateModel } from "../InterestRateModel.sol";

library Borrow {

    using PriceLib for State;
    using TransferLib for State;    
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    uint256 constant WAD = 1e18;

    function depositCollateral(State storage state, uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");
 
        // update interest rate model
        state.updateInterestRates();

        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        
        // Update collateral data for the user
        reserveData.totalCollaterals += _amount;
        position.collateralAmount += _amount;

        // Transfer the collateral token from the user to the contract
        state.transferCollateral(msg.sender, address(this), _amount);
        
        emit Events.CollateralDeposited(msg.sender, _amount);
    }
    
    function withdrawCollateral(State state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate enough collateral to withdraw
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateWithdrawCollateral(state, position, _amount);

        // update collateral data for the user
        position.collateralAmount -= _amount;
        reserveData.totalCollaterals -= _amount;

        // Transfer the collateral token from the user to the contract
        state.transferCollateral(msg.sender, _amount);

        emit Events.CollateralWithdrawn(msg.sender, _amount);
    }

    function borrow(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();
        
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateBorrow(state, position, _amount);

        // update borrow data for user & pool
        state.reserveData.totalBorrows += _amount;
        position.borrowAmount += _amount;
        
        // update debt for the user's position
        uint256 debt = state.getDebtAmount(_amount);
        position.debtAmount += debt;
        state.positionData.totalDebt += debt;

        // Transfer the principal token from the contract to the user
        state.transferPrincipal(msg.sender, _amount);

        emit Event.Borrowed(msg.sender, _amount);
    }

    function repay(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate repay amount
        _validateRepay(state, _amount);
        uint256 debt = state.getDebtAmount(_amount);
        
        // update debt, and borrow amount
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        uint256 repaid = position.borrowAmount.mulDiv(debt, position.debtAmount); 
        
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= debt;
        
        position.repaidAmount += repaid;
        position.debtAmount -= debt;
        
        // state.reserveData
        state.transferPrincipal(msg.sender, address(this), _amount);

        emit Events.Repaid(msg.sender, _amount, repaid);
    }  

    function repayAll(State storage state) external {
        // update interest rate model
        state.updateInterestRates();
        
        // calculate fully repaid amount
        uint256 repaid = _calculateRepaidAmount(state);

        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        // update borrow and debt info
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= position.debtAmount;

        position.repaidAmount += repaid;
        position.debtAmount = 0;

        // state.reserveData
        state.transferPrincipal(msg.sender, address(this), repaid);

        emit Events.Repaid(msg.sender, position.borrowAmount, repaid);
    }

    function getFullRepayAmount(State storage state) external returns (uint256 repaid) {
        // update interest rate model
        state.calcUpdatedInterestRates();
        repaid = _calculateRepaidAmount(state);
    }

    function _calculateRepaidAmount(state storage state) internal returns (uint256 repaid) {
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        repaid = state.getRepaidAmount(position.debtAmount);
    }

    function _validateRepay(State storage state, DebtPosition position, uint256 _amount) internal {
        uint256 repayAmount = position.debtAmount.mulWad(state.rateData.debtIndex);
        require(_amount > 0 || _amount <= repayAmount, "Invalid repay amount");        
    }

    function _validateWithdrawCollateral(
        State storage state, 
        DebtPosition position,
        uint256 _amount
    ) internal {
        require(_amount > 0, "Invalid withdraw amount");
        
        uint256 liquidationThreshold = state.riskConfig.liquidationThreshold;
        uint256 collateralPriceInPrincipal = state.collateralPriceInPrincipal();
        
        uint256 borrowAmount = position.borrowAmount;
        uint256 collateralAmount = position.collateralAmount;
        uint256 collateralUsedInBorrow = borrowAmount
                                                .divWad(collateralPriceInPrincipal)
                                                .divWadUp(liquidationThreshold);
        uint256 maxWithdrawAllowed = collateralAmount - collateralUsedInBorrow;

        require(_amount <= maxWithdrawAllowed, "Not enough collateral to withdraw");
    }

    function _validateBorrow(
        State storage state, 
        DebtPosition position,
        uint256 _amount
    ) internal {
        require(_amount > state.riskConfig.minimumBorrowToken, "Invalid borrow amount");

        DebtPosition position = state.positionData.debtPositions[msg.sender];
        uint256 loanToValue = state.riskConfig.loanToValue;
        uint256 collateralPriceInPrincipal = state.collateralPriceInPrincipal();

        uint256 borrowedAmount = position.borrowAmount;
        uint256 collateralAmount = position.collateralAmount;
        uint256 maxBorrowAllowed = collateralAmount
                                        .mulWad(collateralPriceInPrincipal)
                                        .divWad(loanToValue);        

        require(_amount + borrowedAmount <= maxBorrowAllowed, "Not enough collateral to borrow");
        require(_amount + state.reserveData.totalBorrows <= state.riskConfig.borrowTokenCap, "Borrow cap reached");
    }
}