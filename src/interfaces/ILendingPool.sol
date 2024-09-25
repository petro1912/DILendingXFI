// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {
    InitializeParam,
    UserCreditPositionData,
    UserDebtPositionData,
    PoolInfo
} from "../LendingPoolState.sol";
import {IInvestmentModule} from './IInvestmentModule.sol';
import {IRewardModule} from './IRewardModule.sol';

/// @title ILendingPool
/// @author Petro1912 
interface ILendingPool {
    
    function initialize(InitializeParam memory param) external;

    function setTokenRewardModule(address token, IRewardModule module) external;

    function getPoolInfo() external view returns (PoolInfo memory);

    function getLastRewardAPRUpdatedAt(address investToken) external view returns (uint256 lastUpdatedAt);

    // function getRewardIndex(address investToken) external view returns(uint256 rewardIndex);
    // function getRewardModules(address token) external view returns (IRewardModule[] memory);

    function getRewardModule(address token) external view returns (IRewardModule);

    function getInvestmentModule() external view returns (IInvestmentModule);

    function getInvestReserveData(address token) external view returns (uint256 totalDeposits, uint256 totalInvested, uint256 lastRewardedAt);

    function updateInvestReserveData(bool isInvest, address token, uint256 investAmount, uint256 rewards, uint256 rewardAPR) external;
    
    function getLiquidityPositionData(address) external view returns (UserCreditPositionData memory);

    function getDebtPositionData(address) external view returns (UserDebtPositionData memory);
}
