// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {PriceLib} from './PriceLib.sol';

library AccountingLib {

    using FixedPointMathLib for uint256;
    using PriceLib for State;

    uint256 constant WAD = 1e18;

    function getHealthInfo(
        State storage state, 
        address user
    ) 
        external 
        returns(
            uint256 collateralAmount, 
            uint256 totalBorrowedAmount, 
            uint256 healthFactor
        ) 
    {
        
        DebtPosition memory position = state.positionData.debtPositions[user];
        if (position.debtAmount == 0)
            return type(uint256).max;

        uint256 liqudationThreshold = state.riskConfig.liquidationThreshold;
        collateralAmount = _collateralValueInPrincipal(state, position);
        borrowedAmount = state.getRepaidAmount(position.debtAmount);        

        healthFactor = collateralAmount.mulDiv(liquidationThreshold, borrowedAmount);
    }

    function getMaxLiquidationAmount(
        State storage state, 
        address user
    ) 
        external 
        returns(
            uint256 healthFactor,
            uint256 totalBorrowedAmount,
            uint256 maxLiquidationAmount, 
            uint256 maxLiqudiationBonus
        ) 
    { 
        (, totalBorrowedAmount, healthFactor) = getHealthInfo(state, user);
        (
            maxLiquidationAmount,
            maxLiqudiationBonus
        )  = _calcMaxLiquidationAmount(state, totalBorrowedAmount, healthFactor);
    }

    function _calcMaxLiquidationAmount(
        State storage state, 
        uint256 totalBorrowedAmount, 
        uint256 healthFactor
    ) 
        internal 
        returns(
            uint256 liquidationAmount, 
            uint256 liqudiationBonus
        ) 
    {
        if (healthFactor >= WAD) {
            liquidationAmount = 0;
            liqudiationBonus = 0;            
        } else {
            uint256 closeFactor = state.riskConfig.healthFactorForClose;
            if (healthFactor <= closeFactor)
                liquidationAmount = totalBorrowedAmount;                
            else
                liquidationAmount = totalBorrowedAmount;
            
            liqudiationBonus = totalBorrowedAmount * state.riskConfig.liquidationBonus;
        }
        
    }
    
    function getCollateralValueInPrincipal(State storage state, DebtPosition memory position) external returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position);      
    }

    function getCollateralValueInPrincipal(State storage state, DebtPosition memory position, IERC20 collateralToken) external returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position, collateralToken);
    }

    function _collateralValueInPrincipal(State storage state, DebtPosition memory position) internal returns(uint256 principalAmount) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        for (uint256 i = 0; i < tokensCount; ) {
            principalAmount += _collateralValueInPrincipal(state, position, collateralTokens[i]);

            unchecked {
                ++i;
            }
        }        
    }

    function _collateralValueInPrincipal(State storage state, DebtPosition memory position, IERC20 collateralToken) internal returns(uint256 principalAmount) {

        uint256 amount = position.collateralAmount[collateralToken];    
        uint256 collateralPriceInPrincipal = state.collateralPriceInPrincipal(collateralToken);
        if (amount != 0) {
            principalAmount = amount.mulWad(collateralPriceInPrincipal);
        }
    }
    
}