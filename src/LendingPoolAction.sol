// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {InterestRateModel} from "./libraries/InterestRateModel.sol";
import {LendingPoolStorage} from "./LendingPoolStorage.sol";
import {State} from "./LendingPoolState.sol";
import {Repay} from "./libraries/Repay.sol";
import {Borrow} from "./libraries/Borrow.sol";
import {Supply} from "./libraries/Supply.sol";
import {Liquidation} from "./libraries/Liquidation.sol";

contract LendingPoolAction is LendingPoolStorage {
    
    using Borrow for State;
    using Repay for State;
    using Supply for State;
    using Liquidation for State;

    // Supply Logic 
    function supply(uint256 _cashAmount, uint256 _minCredit) external returns(uint256 credit) {
        credit = state.supply(_cashAmount, _minCredit);
    }

    function withrawSupply(uint256 _creditAmount) external returns (uint256 cash) {
        cash = state.withrawSupply(_creditAmount);
    }

    function withrawAllSupply() external returns (uint256 cash, uint256 totalEarned) {
        (cash, totalEarned) = state.withrawAllSupply();
    }

    // Borrow Logic 
    function depositCollateral(address _collateralToken, uint256 _amount) external {
        state.depositCollateral(_collateralToken, _amount);
    }
    
    function withdrawCollateral(address _collateralToken, uint256 _amount) external {
        state.withdrawCollateral(_collateralToken, _amount);
    }

    function borrow(uint256 _amount) external {
        state.borrow(_amount);
    }

    function repay(uint256 _amount) external {
        state.repay(_amount);
    }  

    function repayAll() external {
        state.repayAll();
    }

    function getFullRepayAmount() external view returns (uint256 repaid) {
        repaid = state.getFullRepayAmount();
    }

    // Liquidate Logic
    function liquidate(address _borrower, uint256 _amount) external {
        state.liquidate(_borrower, _amount);
    }

}