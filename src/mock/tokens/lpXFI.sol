// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract lpXFI is ERC20, Ownable {
    constructor(address owner_) ERC20("Mock Staked LP XFI", "lpXFIMock") Ownable(owner_) {}

    function mint(address receiver, uint256 amount) external onlyOwner {
        _mint(receiver, amount);
    }

}