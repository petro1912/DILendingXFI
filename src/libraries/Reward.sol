// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LendingPoolStorage, ReserveData} from "../LendingPoolStorage.sol";

library Reward {

    function getTotalEarnedAmount(State storage state) external returns (uint256 cash) {
        (, uint256 creditIndex) = state.calcUpdatedInterestRates(state);
        
        uint256 totalDeposit = state.reserveData.totalDeposits;
        uint256 totalWithdraw = state.reserveData.totalWithdrawals;
        uint256 remainingCash = state.reserveData.totalCredit.mulWad(creditIndex);

        return remainingCash + totalWithdraw - totalDeposit;
    }    

    function getEarnedAmount(State storage state) external returns (uint256 cash) {
        return _calcEarnedAmount(state, msg.sender);
    }

    function getEarnedAmount(State storage state, address user) external returns (uint256) {
        return _calcEarnedAmount(state, user);
    }

    function _calcEarnedAmount(State storage state, address user) external returns (uint256) {
        (, uint256 creditIndex) = state.calcUpdatedInterestRates(state);
        CreditPosition storage position = state.positionData.creditPositions[user];

        uint256 totalDeposit = position.totalDeposit;
        uint256 totalWithdraw = position.withdrawAmount;
        uint256 remainingCash = position.creditAmount.mulWad(creditIndex);

        return remainingCash + totalWithdraw - totalDeposit;
    }
    
}