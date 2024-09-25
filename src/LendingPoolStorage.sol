// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PositionInfo} from "./libraries/PositionInfo.sol";
import {PoolStatistics} from "./libraries/PoolStatistics.sol";
import {InvestmentLib} from "./libraries/InvestmentLib.sol";
import {IRewardModule} from "./interfaces/IRewardModule.sol";
import {IInvestmentModule} from "./interfaces/IInvestmentModule.sol";
import {State, PoolInfo, CollateralsData, UserCollateralData, UserCreditPositionData, UserDebtPositionData} from "./LendingPoolState.sol";

abstract contract LendingPoolStorage {
    using PositionInfo for State;
    using PoolStatistics for State;
    using InvestmentLib for State;
    
    State internal state;

    function getPrincipalToken() public view returns (address principalToken) {
        principalToken = address(state.tokenConfig.principalToken);
    }

    function getCollateralTokens() public view returns (address[] memory) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        address[] memory addresses = new address[](tokensCount);
        for (uint i = 0; i < tokensCount; ) {
            addresses[i] = address(collateralTokens[i]);
            unchecked {
                ++i;
            }
        }
        
        return addresses;
    }

    // function getRewardModules(address token) public view returns (IRewardModule[] memory modules) {
    //     modules = state.rewardConfig.rewardModules[token];
    // }

    function getRewardModule(address token) public view returns (IRewardModule module) {
        module = state.rewardConfig.rewardModules[token];
    }

    function getInvestmentModule() public view returns (IInvestmentModule module) {
        module = state.tokenConfig.investModule;
    }

    function getPoolStatistics() 
        public 
        view
        returns (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) 
    {
        return state.getPoolStatistics();
    }

    function getPoolInfo() public view returns(PoolInfo memory info) {
        return state.getPoolInfo();
    }

    function getCollateralsData() public view returns(CollateralsData memory info) {
        return state.getCollateralsData();
    }

    function getUserCollateralData(address user) public view returns(UserCollateralData memory collateralData) {
        return state.getUserCollateralData(user);
    } 

    function getLiquidityPositionData(address user) public view returns(UserCreditPositionData memory positionData) {
        return state.getLiquidityPositionData(user);
    }

    function getDebtPositionData(address user) public view returns(UserDebtPositionData memory positionData) {
        return state.getDebtPositionData(user);
    }

    // function getRewardIndex(address token) external view returns (uint256 rewardIndex) {
    //     rewardIndex = state.getRewardIndex(token);
    // }

    function getInvestReserveData(address token) public view returns (uint256 totalDeposits, uint256 totalInvested, uint256 lastRewardedAt) {
        return state.getInvestReserveData(token);
    }    

    function getLastRewardAPRUpdatedAt(address token) external view returns (uint256 lastUpdatedAt) {
        return state.getLastRewardAPRUpdatedAt(token);
    }
    
    function updateInvestReserveData(
        bool isInvest, 
        address token, 
        uint256 investAmount, 
        uint256 rewards, 
        uint256 rewardAPR
    ) public {
        state.updateInvestReserveData(isInvest, token, investAmount, rewards, rewardAPR);
    }

}