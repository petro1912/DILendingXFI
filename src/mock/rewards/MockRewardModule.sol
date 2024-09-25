
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IRewardModule} from "../../interfaces/IRewardModule.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MockRewardModule is IRewardModule {

    using SafeERC20 for IERC20;

    address investToken;
    address rewardToken;
    
    uint256 totalStaked; 
    uint256 lastUpdatedAt = block.timestamp;
    uint256 constant YEAR = 365 * 86400;
    uint256 apr;
    
    constructor(address _investToken, address _rewardToken, uint256 _apr) {
        investToken = _investToken;
        rewardToken = _rewardToken;
        apr = _apr;
    }

    function getInvestToken() public view override returns(address) {
        return investToken;
    }
    function getRewardToken() public view override returns(address) {
        return rewardToken;
    }
    function getCurrentAPR() public view override returns(uint256) {
        return apr;
    }

    function deposit(uint256 amount) public override returns(uint256 rewards) {
        rewards = totalStaked * (block.timestamp - lastUpdatedAt)  * apr / (YEAR * 1e18);
        IERC20(investToken).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(rewardToken).safeTransfer(msg.sender, rewards);

        totalStaked += amount;
        lastUpdatedAt = block.timestamp;
    }

    function withdraw(uint256 amount) public override returns(uint256 rewards) {
        rewards = totalStaked * (block.timestamp - lastUpdatedAt)  * apr / (YEAR * 1e18);
        IERC20(investToken).safeTransfer(msg.sender, amount);
        IERC20(rewardToken).safeTransfer(msg.sender, rewards);

        totalStaked -= amount;
        lastUpdatedAt = block.timestamp;
    }
    
    function claimReward() public override returns(uint256 rewards) {
        rewards = (block.timestamp - lastUpdatedAt) * totalStaked / YEAR;
        IERC20(rewardToken).safeTransfer(msg.sender, rewards);

        lastUpdatedAt = block.timestamp;
    }
}
