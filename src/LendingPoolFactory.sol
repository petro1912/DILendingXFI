// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPool } from './LendingPool.sol';
import {
    InitializeParam
} from "./LendingPoolStorage.sol";
import { DIAOracleV2 } from "./oracle/DIAOracleV2Multiupdate.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Events } from './libraries/Events.sol';

contract LendingPoolFactory is Ownable {

    LendingPool[] private _pools;
    address[] private _poolAddresses;

    constructor() Ownable(msg.sender) {}

    function createLendingPool(InitializeParam memory initializeParam) public onlyOwner returns(address) {
        LendingPool pool = new LendingPool(initializeParam, owner());
        _poolAddresses.push(address(pool));
        _pools.push(pool);

        emit Events.PoolAdded(address(pool), address(initializeParam.tokenConfig.principalToken));
        return address(pool);
    }

    function getAllPools() public view returns (LendingPool[] memory pools) {
        pools = _pools;
    }

    function getAllPoolAddresses() public view returns (address[] memory poolAddresses) {
        poolAddresses = _poolAddresses;
    }
}