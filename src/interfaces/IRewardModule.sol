// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IRewardModule {
    function getInvestToken() external returns(address);
    function getRewardToken() external returns(address);
    function getCurrentAPR() external view returns(uint256);

    function deposit(uint256 amount) external returns(uint256 rewards);
    function withdraw(uint256 amount) external returns(uint256 rewards);
    function claimReward() external returns(uint256 rewards);
}
