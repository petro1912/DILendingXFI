// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LendingPoolStorage, ReserveData} from "../LendingPoolStorage.sol";

library Reward {

    function claimFee() external {
        ReserveData storage borrowReserve = reserves[address(borrowToken)];
        CollateralData storage collateral = userCollaterals[address(collateralToken)][msg.sender];

        uint256 feeShare = (collateral.collateralAmount * borrowReserve.totalFees) / borrowReserve.totalDeposits;
        require(feeShare > 0, "No fees to claim");

        borrowReserve.totalFees -= feeShare;
        userFees[address(borrowToken)][msg.sender] += feeShare;

        borrowToken.transfer(msg.sender, feeShare);

        emit Event.FeeClaimed(msg.sender, feeShare);
    }
    
}