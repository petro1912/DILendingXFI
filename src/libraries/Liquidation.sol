// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {LendingPoolStorage, State, DebtPosition, ReserveData} from "../LendingPoolStorage.sol";
import { InterestRateModel } from "./InterestRateModel.sol";

import { TransferLib } from "./TransferLib.sol";
import { AccountingLib } from "./AccountingLib.sol"; 
import {PriceLib} from "./PriceLib.sol";

library Liquidation  {

    using FixedPointMathLib for uint256;
    using InterestRateModel for State;
    using TransferLib for State;
    using AccountingLib for State;    
    using PriceLib for State;

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
        IERC20[] memory tokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = tokens.length;
        uint256 totalPaid = _amount.mulWad(state.riskConfig.liquidationBonus);

        state.transferPrincipal(msg.sender, address(this), _amount);
        for (uint256 i = 0;  i < tokensCount; ) {
            address token = address(tokens[i]);
            uint256 principalAmount = state.getCollateralValueInPrincipal(position, token);
            if (totalPaid > principalAmount) {
                totalPaid -= principalAmount;
                state.transferCollateral(token, msg.sender, principalAmount);  
            } else {
                state.transferCollateral(token, msg.sender, totalPaid);  
                break;      
            }

            unchecked {
                ++i;
            }
        }
    }

    function _validateLiquidation(State storage state, address _borrower, uint256 _amount) internal view {
        (
            uint256 healthFactor,
            ,
            uint256 maxLiquidationAmount, 
            
        ) = state.getMaxLiquidationAmount(_borrower);

        require(healthFactor < 1e18, "This account is healthy");
        require(maxLiquidationAmount >= _amount, "Amount is too large");
    }

}