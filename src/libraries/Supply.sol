// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {
    LendingPoolStorage, 
    CreditPosition, 
    State, 
    ReserveData
} from "../LendingPoolStorage.sol";
import { InterestRateModel } from "../InterestRateModel.sol";
// import {} from "@openzeppelin/";

library Supply {

    using SafeERC20 for IERC20;
    using InterestRateModel for State;

    function supply(State storage state, uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");

        IERC20 principalToken = state.tokenConfig.principalToken;
        ReserveData storage reserveData = state.reserveData;
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];
        
        // Transfer the borrow token from the lender to the contract
        principalToken.safeTransferFrom(msg.sender, address(this), _amount);
        
        reserveData.totalDeposits += _amount;
        position.depositAmount += _amount;
        
        uint256 credit = state.getCreditAmount(_amount);
        position.creditAmount += credit;
        state.positionData.totalCredit += credit;

        // Update interest rates based on new liquidity
        state.updateInterestRates();

        emit Event.Deposit(msg.sender, _amount);
    }

    function withrawSupply(uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");
        ReserveData storage borrowReserve = reserves[address(borrowToken)];
        borrowReserve.totalDeposits += _amount;
    }
} 