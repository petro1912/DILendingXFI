// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {
    LendingPoolStorage, 
    CreditPosition, 
    State, 
    ReserveData
} from "../LendingPoolStorage.sol";
import { InterestRateModel } from "./InterestRateModel.sol";
import { Events } from "./Events.sol";
import { TransferLib } from "./TransferLib.sol";

library Supply {

    using TransferLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    function supply(State storage state, uint256 _cashAmount, uint256 _minCredit) external returns(uint256 credit) {
        require(_cashAmount > 0, "Invalid deposit amount");

        // Update interest rates based on new liquidity
        state.updateInterestRates();

        CreditPosition storage position = state.positionData.creditPositions[msg.sender];
        
        // update reserve data and credit position
        credit = state.getCreditAmount(_cashAmount);
        require(credit >= _minCredit, "Minimum credit doesn't reach");
        
        state.reserveData.totalCredit += _cashAmount;
        state.reserveData.totalDeposits += _cashAmount;
        state.positionData.totalCredit += credit;
        position.totalDeposit += _cashAmount;
        position.depositAmount += _cashAmount;
        position.creditAmount += credit;

        // Transfer the borrow token from the lender to the contract
        state.transferPrincipal(msg.sender, address(this), _cashAmount);

        emit Events.DepositPrincipal(msg.sender, _cashAmount, credit);
    }

    function withrawSupply(State storage state, uint256 _creditAmount) external returns (uint256 cash) {
        require(_creditAmount > 0, "Invalid deposit amount");

        // Update interest rates based on new liquidity
        state.updateInterestRates();
        
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];

        cash = state.getCashAmount(_creditAmount);
        uint256 withdrawalCash = position.depositAmount.mulDiv(_creditAmount, position.creditAmount);

        state.reserveData.totalDeposits -= withdrawalCash;
        state.positionData.totalCredit -= _creditAmount;
        state.reserveData.totalWithdrawals += cash;
        
        position.depositAmount -= withdrawalCash;
        position.creditAmount -= _creditAmount;
        position.withdrawAmount += cash;        

        state.transferPrincipal(msg.sender, cash);

        emit Events.WithdrawPrincipal(msg.sender, cash, _creditAmount);
    }

    function withrawAllSupply(State storage state) external returns (uint256 cash, uint256 totalEarned) {
        // Update interest rates based on new liquidity
        state.updateInterestRates();
        
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];

        uint256 creditAmount = position.creditAmount;
        cash = state.getCashAmount(creditAmount);
        
        state.reserveData.totalDeposits -= position.depositAmount;
        state.positionData.totalCredit -= creditAmount;
        state.reserveData.totalWithdrawals += cash;
        
        position.depositAmount = 0;
        position.creditAmount = 0;
        position.withdrawAmount += cash;
        
        totalEarned = position.withdrawAmount - position.totalDeposit;

        state.transferPrincipal(msg.sender, cash);

        emit Events.WithdrawPrincipal(msg.sender, cash, creditAmount);
    }
} 