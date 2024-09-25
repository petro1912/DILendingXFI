// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WETH is ERC20, Ownable {
    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address owner_) ERC20("Mock Wrapped Ether", "WETHMock") Ownable(owner_) {}

    function deposit() public payable virtual {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public virtual {
        _burn(msg.sender, amount);

        emit Withdrawal(msg.sender, amount);

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    receive() external payable virtual {
        deposit();
    }
}
