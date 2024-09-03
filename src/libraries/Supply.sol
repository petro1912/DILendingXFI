// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {
    LendingPoolStorage, 
    CreditPosition, 
    State, 
    ReserveData
} from "../LendingPoolStorage.sol";
import { InterestRateModel } from "../InterestRateModel.sol";
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
        uint256 credit = state.getCreditAmount(_cashAmount);
        if (_minCredit != 0)
            require(credit >= _minCredit, "Minimum credit doesn't reach");
        
        state.reserveData.totalDeposits += _cashAmount;
        state.positionData.totalCredit += credit;
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
        uint256 withdawalCash = position.depositAmount.mulWad(_creditAmount, position.creditAmount);

        state.positionData.totalCredit -= _creditAmount;
        state.reserveData.totalWithdrawals += cash;
        position.creditAmount -= _creditAmount;
        position.withdrawAmount += cash;        

        state.transferPrincipal(state, msg.sender, cash);

        emit Events.withrawPrincipal(msg.sender, cash, _creditAmount);
    }

    function withrawAllSupply(State storage state) external returns (uint256 cash, uint256 totalEarned) {
        // Update interest rates based on new liquidity
        state.updateInterestRates();
        
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];

        uint256 creditAmount = position.creditAmount;
        cash = state.getCashAmount(creditAmount);
        
        state.reserveData.totalWithdrawals += cash;
        state.positionData.totalCredit -= creditAmount;
        position.withdrawAmount += cash;
        position.creditAmount = 0;

        totalEarned = position.withdrawAmount - position.depositAmount;

        state.transferPrincipal(state, msg.sender, cash);

        emit Events.withrawPrincipal(msg.sender, cash, _creditAmount);
    }
} 