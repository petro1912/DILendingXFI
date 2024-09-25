// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPool } from './LendingPool.sol';
import {
    InitializeParam,
    UserCreditPositionData,
    UserDebtPositionData,
    PoolInfo
} from "./LendingPoolState.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import {ILendingPool} from './interfaces/ILendingPool.sol';

contract LendingPoolFactory is Ownable {

    address[] public poolAddresses;

    event PoolAdded(address poolAddress);
    
    constructor() Ownable(msg.sender) {}

    function createLendingPool() public onlyOwner returns(address poolAddress) {
        poolAddress = address(new LendingPool(msg.sender));
        poolAddresses.push(poolAddress);
        
        emit PoolAdded(poolAddress);
    }

    function getAllPoolsInfo() public view returns (PoolInfo[] memory) {
        uint256 poolsCount = poolAddresses.length;
        PoolInfo[] memory pools = new PoolInfo[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            pools[i] = ILendingPool(poolAddresses[i]).getPoolInfo();

            unchecked {
                ++i;
            }
        }

        return pools;
    }

    function getUserCreditPositions(address user) public view returns (UserCreditPositionData[] memory creditPositions) {
        uint256 poolsCount = poolAddresses.length;
        creditPositions = new UserCreditPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            creditPositions[i] = ILendingPool(poolAddresses[i]).getLiquidityPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }

    function getUserDebtPositions(address user) public view returns (UserDebtPositionData[] memory debtPositions) {
        uint256 poolsCount = poolAddresses.length;
        debtPositions = new UserDebtPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            debtPositions[i] = ILendingPool(poolAddresses[i]).getDebtPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }
}