// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EXE is ERC20, Ownable {
    constructor(address owner_) ERC20("Mocked EXE Token", "MockEXE") Ownable(owner_) {}

    function mint(address receiver, uint256 amount) external onlyOwner {
        _mint(receiver, amount);
    }

}