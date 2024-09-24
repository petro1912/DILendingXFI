// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {State, ReserveData, InvestReserveData} from "../LendingPoolState.sol";

library InvestmentLib {

    function getInvestReserveData(State storage state, address token) external view returns (uint256 totalDeposits, uint256 totalInvested) {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            totalDeposits = state.reserveData.totalDeposits;
            totalInvested = state.reserveData.totalInvested;
        } else {
            totalDeposits = state.reserveData.totalCollaterals[token].totalDeposits;
            totalInvested = state.reserveData.totalCollaterals[token].totalInvested;
        }
    }

    function getRewardIndex(State storage state, address token) external view returns (uint256 rewardIndex) {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            rewardIndex = state.reserveData.rewardIndex;
        } else {
            rewardIndex = state.reserveData.totalCollaterals[token].rewardIndex;
        }
    }

    function getLastRewardAPRUpdatedAt(State storage state, address token) external view returns (uint256 lastUpdatedAt) {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            lastUpdatedAt = state.reserveData.lastAPRUpdatedAt;
        } else {
            lastUpdatedAt = state.reserveData.totalCollaterals[token].lastAPRUpdatedAt;
        }
    }
    
    function updateInvestReserveData(
        State storage state,
        bool isInvest, 
        address token, 
        uint256 investAmount, 
        uint256 rewards, 
        uint256 rewardIndex,
        uint256 rewardAPR
    ) external {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            ReserveData storage reserveData = state.reserveData;
            if (investAmount != 0) {
                if (isInvest) {
                    reserveData.totalInvested += investAmount;
                } else {
                    reserveData.totalInvested -= investAmount;
                }
            }

            reserveData.totalRewards += rewards;
            if (rewardIndex != 0) {
                reserveData.rewardIndex = rewardIndex;
                reserveData.rewardAPR = rewardAPR;
                reserveData.lastAPRUpdatedAt = block.timestamp;
            }
        } else {
            InvestReserveData storage investData = state.reserveData.totalCollaterals[token];
            if (investAmount != 0) {
                if (isInvest) {
                    investData.totalInvested += investAmount;
                } else {
                    investData.totalInvested -= investAmount;
                }
            }
            
            investData.totalRewards += rewards;
            if (rewardIndex != 0) {
                investData.rewardIndex = rewardIndex;
                investData.rewardAPR = rewardAPR;
                investData.lastAPRUpdatedAt = block.timestamp;
            }
        }
    }
}

