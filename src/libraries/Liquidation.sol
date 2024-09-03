// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LendingPoolStorage, State, ReserveData} from "../LendingPoolStorage.sol";
import { InterestRateModel } from "../InterestRateModel.sol";
import { TransferLib } from "./TransferLib.sol";
import { AccountingLib } from "./AccountingLib.sol"; 
import {PriceLib} from "./PriceLib.sol";

library Liquidation  {

    using InterestRateModel for State;
    using TransferLib for State;
    using AccountingLib for State;    
    using PriceLib for State;

    uint256 constant WAD = 1e18;
    
    function liquidate(State storage state, address _borrower, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        _validateLiquidation(state, _borrower, _amount);

        //update reserve and borrower's debt
        DebtPosition storage position = state.positionData.debtPositions[_borrower];
        uint256 debt = state.getDebtAmount(_amount);
        uint256 repaid = position.borrowAmount.mulDiv(debt, position.debtAmount); 
        state.reserveData.totalBorrows -= repaid;
        position.borrowAmount -= repaid; 
        state.positionData.totalDebt -= debt;
        position.debtAmount -= debt;

        // repaid principal behalf of borrower
        uint256 collateralAmount = _amount.mulWad(state.collateralPriceInPrincipal());
        collateralAmount += collateralAmount.mulWad(state.riskConfig.liquidationBonus);

        state.transferPrincipal(msg.sender, address(this), _amount);
        state.transferCollateral(msg.sender, collateralAmount);
        
        // @audit and then ??? remaining to => the position owner???

    }

    function _validateLiquidation(State storage state, address _borrower, uint256 _amount) internal {
        (
            uint256 healthFactor,
            uint256 totalBorrowedAmount,
            uint256 maxLiquidationAmount, 
            uint256 maxLiqudiationBonus
        ) = state.getMaxLiquidationAmount(_borrower);

        require(healthFactor < WAD, "This account is healthy");
        require(maxLiquidationAmount >= _amount, "Amount is too large");
    }

}