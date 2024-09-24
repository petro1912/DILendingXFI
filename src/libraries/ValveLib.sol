// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ILendingPool} from '../interfaces/ILendingPool.sol';
import {IInvestmentModule} from '../interfaces/IInvestmentModule.sol';

library ValveLib {
    uint256 constant emergencyRate = 98_000;
    uint256 constant safeRate = 95_000; // buffer rate is 5%
    uint256 constant unitRate = 100_000;

    uint256 constant determinePrincipal = 3600; // one hour    
    uint256 constant minimumInvestToken = 1e18;

    function determineInvestOrWithdraw(address _token) 
        internal 
        view 
        returns (
            bool isInvest, 
            uint256 amount
        ) 
    {
        (
            uint256 totalDeposit,
            uint256 totalInvest,
            uint256 lastRewardedAt
        ) = ILendingPool(address(this)).getInvestReserveData(_token);
        uint256 totalUtilizedRate = unitRate * totalInvest / totalDeposit;    
        if (totalUtilizedRate >= emergencyRate) {
            isInvest = false;
            amount = (totalUtilizedRate - safeRate) * totalDeposit / unitRate;
        } else if (lastRewardedAt > block.timestamp + determinePrincipal) {
            isInvest = totalUtilizedRate < safeRate;
            amount = isInvest?
                        (safeRate - totalUtilizedRate) * totalDeposit / unitRate :
                        (totalUtilizedRate - totalUtilizedRate) * totalDeposit / unitRate; 

            if (amount < minimumInvestToken)
                amount = 0;
        }
    }

    // function determineRewardModule(address _token) external view returns (uint8) {
    //     uint8 maxIndex = 0;
    //     IRewardModule[] memory rewardModules = ILendingPool(address(this)).getRewardModules(_token);
    //     uint8 modulesCount = uint8(rewardModules.length);
        
    //     if (rewardModules.length == 1)
    //         return maxIndex;

    //     uint256 maxAPR = rewardModules[0].getCurrentAPR();
    //     for (uint8 i = 1; i < modulesCount; ) {
    //         uint256 apr = rewardModules[i].getCurrentAPR();
    //         if (apr > maxAPR) 
    //             maxIndex = i;

    //         unchecked {
    //             ++i;
    //         }
    //     }

    //     return maxIndex;
    // }

    function executeInvestOrWithdraw(address _token) external returns (uint256 rewardIndex) {
        (
            bool isInvest, 
            uint256 amount
        ) = determineInvestOrWithdraw(_token);

        if (amount != 0) {
            IInvestmentModule investModule = ILendingPool(address(this)).getInvestmentModule();
            if (isInvest) {
                rewardIndex = investModule.invest(address(this), _token, amount);
            } else {
                rewardIndex = investModule.withdraw(address(this), _token, amount);
            }
        } else {
            rewardIndex = ILendingPool(address(this)).getRewardIndex(_token);
        }

    }    

}