// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IInvestmentModule {

    function getCurrentAPR(address lendingPool, address token) external returns(uint256); 
    
    function invest(address lendingPool, address token, uint256 amount) external returns(uint256);
    function withdraw(address lendingPool, address token, uint256 amount) external returns(uint256);

    function claim(address lendingPool, address token) external returns(uint256);  
}