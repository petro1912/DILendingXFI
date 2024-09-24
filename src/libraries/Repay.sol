// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { State, DebtPosition, ReserveData } from "../LendingPoolState.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";

import { Events } from "./Events.sol";
import { PriceLib } from "./PriceLib.sol";
import { TransferLib } from "./TransferLib.sol";
import { AccountingLib } from "./AccountingLib.sol";
import { InterestRateModel } from "./InterestRateModel.sol";

library Repay {
    
    using PriceLib for State;
    using TransferLib for State;    
    using AccountingLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    function repay(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate repay amount
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateRepay(state, position, _amount);
        uint256 debt = state.getDebtAmount(_amount);
        
        // update debt, and borrow amount
        uint256 repaid = position.borrowAmount.mulDiv(debt, position.debtAmount); 
        
        state.reserveData.totalBorrows -= repaid; 
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= debt;
        
        position.borrowAmount -= repaid;
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
        state.reserveData.totalBorrows -= position.borrowAmount;
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= position.debtAmount;

        position.borrowAmount = 0;
        position.repaidAmount += repaid;
        position.debtAmount = 0;

        // state.reserveData
        state.transferPrincipal(msg.sender, address(this), repaid);

        emit Events.Repaid(msg.sender, position.borrowAmount, repaid);
    }

    function getFullRepayAmount(State storage state) external view returns (uint256 repaid) {
        // update interest rate model
        (uint256 debtIndex, ) = state.calcUpdatedInterestRates();
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        repaid = position.debtAmount.mulWadUp(debtIndex);
    }

    function _calculateRepaidAmount(State storage state) internal view returns (uint256 repaid) {
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        repaid = state.getRepaidAmount(position.debtAmount);
    }

    function _validateRepay(State storage state, DebtPosition storage position, uint256 _amount) internal view {
        uint256 repayAmount = position.debtAmount.mulWad(state.rateData.debtIndex);
        require(_amount > 0 || _amount <= repayAmount, "Invalid repay amount");        
    }
}