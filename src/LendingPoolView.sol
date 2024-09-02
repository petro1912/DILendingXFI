// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {InterestRateModel} from "./InterestRateModel.sol";
import {LendingPoolStorage} from "./LendingPoolStorage.sol";

contract LendingPoolView is LendingPoolStorage {
    
    function getUserCollateral(address _user) external view returns (uint256) {
        return userCollaterals[address(collateralToken)][_user].collateralAmount;
    }

    function getUserBorrow(address _user) external view returns (uint256) {
        return userCollaterals[address(collateralToken)][_user].borrowAmount;
    }

    function getUserFees(address _user) external view returns (uint256) {
        return userFees[address(borrowToken)][_user];
    }
    
    function getAvailableLiquidity() public view returns (uint256) {
        ReserveData storage borrowReserve = reserves[address(borrowToken)];
        return borrowReserve.totalDeposits - borrowReserve.totalBorrows;
    }

}