// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPool } from './LendingPool.sol';
import {
    InitializeParam,
    UserCreditPositionData,
    UserDebtPositionData,
    PoolInfo
} from "./LendingPoolStorage.sol";
import { DIAOracleV2 } from "./oracle/DIAOracleV2Multiupdate.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Events } from './libraries/Events.sol';
import {console} from 'forge-std/console.sol';

contract LendingPoolFactory is Ownable {

    LendingPool[] private _pools;
    address[] private _poolAddresses;

    constructor() Ownable(msg.sender) {}

    function createLendingPool(InitializeParam memory initializeParam) public onlyOwner returns(address poolAddress) {
        LendingPool pool = new LendingPool(initializeParam, owner());
        poolAddress = address(pool);
        _pools.push(pool);
        _poolAddresses.push(poolAddress);
        
        emit Events.PoolAdded(address(pool), address(initializeParam.tokenConfig.principalToken));
        
        return address(pool);
    }

    function getAllPools() public view returns (LendingPool[] memory pools) {
        pools = _pools;
    }

    function getAllPoolAddresses() public view returns (address[] memory poolAddresses) {
        poolAddresses = _poolAddresses;
    }

    function getAllPoolsInfo() public view returns (PoolInfo[] memory) {
        
        uint256 poolsCount = _pools.length;
        PoolInfo[] memory pools = new PoolInfo[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            pools[i] = _pools[i].getPoolInfo();

            unchecked {
                ++i;
            }
        }

        return pools;
    }

    function getUserCreditPositions(address user) public view returns (UserCreditPositionData[] memory creditPositions) {
        uint256 poolsCount = _pools.length;
        creditPositions = new UserCreditPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            creditPositions[i] = _pools[i].getLiquidityPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }

    function getUserDebtPositions(address user) public view returns (UserDebtPositionData[] memory debtPositions) {
        uint256 poolsCount = _pools.length;
        debtPositions = new UserDebtPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            debtPositions[i] = _pools[i].getDebtPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }
}