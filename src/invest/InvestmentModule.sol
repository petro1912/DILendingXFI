// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IInvestmentModule} from '../interfaces/IInvestmentModule.sol';
import {ILendingPool} from '../interfaces/ILendingPool.sol';
import {IRewardModule} from '../interfaces/IRewardModule.sol';

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract InvestmentModule is IInvestmentModule {

    using SafeERC20 for IERC20;

    uint256 constant WAD = 1e18;
    uint256 constant YEAR = 86400 * 365;
        
    uint256 private totalInvest;
    uint256 private totalReward;

    error NotLendingContract();
    error NotEnoughWithdraw();

    modifier onlyLendingModule(address lendingPool) {
        if (msg.sender != lendingPool)
            revert NotLendingContract();
        _;
    }
    
    function getCurrentAPR(address lendingPool, address investToken) public view override returns(uint256) {
        return getRewardModule(lendingPool, investToken).getCurrentAPR();
    }

    // function getRewardIndex() public view override returns(uint256) {
    //     return rewardIndex;
    // }
    

    function invest(address lendingPool, address investToken, uint256 investAmount) onlyLendingModule(lendingPool) public override returns(uint256) {
        uint256 lastAPR = getRewardModule(lendingPool, investToken).getCurrentAPR();

        // transfer token from lending pool and approve reward protocol
        IRewardModule rewardModule = getRewardModule(lendingPool, investToken);
        IERC20(investToken).safeTransferFrom(lendingPool, address(this), investAmount);
        IERC20(investToken).approve(address(rewardModule), investAmount);
        uint256 rewards = rewardModule.deposit(investAmount);
        ILendingPool(lendingPool).updateInvestReserveData(true, investToken, investAmount, rewards, lastAPR);

        return lastAPR;
    }

    function withdraw(address lendingPool, address investToken, uint256 withdrawAmount) onlyLendingModule(lendingPool) public override returns(uint256) {
        uint256 lastAPR = getRewardModule(lendingPool, investToken).getCurrentAPR();
        
        IRewardModule rewardModule = getRewardModule(lendingPool, investToken);
        uint256 rewards = rewardModule.withdraw(withdrawAmount);
        
        // transfer invest and reward tokens to lending pool
        address rewardToken = rewardModule.getRewardToken();
        IERC20(investToken).safeTransfer(lendingPool, withdrawAmount);
        IERC20(rewardToken).safeTransfer(lendingPool, rewards);

        ILendingPool(lendingPool).updateInvestReserveData(false, investToken, withdrawAmount, rewards, lastAPR);

        return lastAPR;
    }

    function claim(address lendingPool, address investToken) onlyLendingModule(lendingPool) public override returns(uint256 rewards) {
        rewards = getRewardModule(lendingPool, investToken).claimReward();
        totalReward += rewards; 
    }

    function getRewardModule(address lendingPool, address investToken) internal view returns (IRewardModule rewardModule) {
        rewardModule = ILendingPool(lendingPool).getRewardModule(investToken);
    }
    
    // function calculateUpdatedIndex(address lendingPool, address investToken) internal view returns(uint256 rewardIndex, uint256 lastAPR) {
    //     uint256 _updatedAt = ILendingPool(lendingPool).getLastRewardAPRUpdatedAt(investToken);
    //     if (block.timestamp == _updatedAt)
    //         return (0, 0);

    //     uint256 timeElapsed = block.timestamp - _updatedAt;
    //     rewardIndex = rewardIndex * (WAD + lastAPR * timeElapsed / YEAR);

    //     lastAPR = getRewardModule(lendingPool, investToken).getCurrentAPR();
    // }

}