// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ILendingPool} from '../interfaces/ILendingPool.sol';
import {IInvestmentModule} from '../interfaces/IInvestmentModule.sol';

library ValveLib {
    uint256 constant emergencyRate = 95_000;
    uint256 constant safeRate = 90_000; // buffer rate is 5%
    uint256 constant unitRate = 100_000;

    uint256 constant determinePrincipal = 10; // one hour    
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

        if (totalDeposit == 0)
            return (false, totalInvest);

        uint256 totalUtilizedRate = unitRate * totalInvest / totalDeposit;
        if (totalUtilizedRate >= emergencyRate) {
            isInvest = false;
            amount = (totalUtilizedRate - safeRate) * totalDeposit / unitRate;
        } else if (block.timestamp > lastRewardedAt + determinePrincipal) {
            isInvest = totalUtilizedRate < safeRate;
            amount = isInvest?
                        (safeRate - totalUtilizedRate) * totalDeposit / unitRate :
                        (totalUtilizedRate - safeRate) * totalDeposit / unitRate; 

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

    function executeInvestOrWithdraw(address _token) external returns (uint256 rewardAPR) {
        (
            bool isInvest, 
            uint256 amount
        ) = determineInvestOrWithdraw(_token);

        if (amount != 0) {
            IInvestmentModule investModule = ILendingPool(address(this)).getInvestmentModule();
            if (isInvest) {
                IERC20(_token).approve(address(investModule), amount);
                rewardAPR = investModule.invest(address(this), _token, amount);
            } 
            else {
                // require(amount >= 450000e18, "this is error");
                rewardAPR = investModule.withdraw(address(this), _token, amount);
            }
        } else {
            rewardAPR = ILendingPool(address(this)).getRewardModule(_token).getCurrentAPR();
        }

    }    

}