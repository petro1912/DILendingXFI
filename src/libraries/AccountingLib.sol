// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import { WAD } from "../constant.sol";

library Accounting {

    using FixedPointMathLib for uint256;

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
        
        DebtPosition storage position = state.positionData.debtPositions[user];
        if (position.debtAmount == 0)
            return type(uint256).max;

        uint256 liqudationThreshold = state.riskConfig.liquidationThreshold;
        collateralAmount = position.collateralAmount;
        totalBorrowedAmount = state.getRepaidAmount(position.debtAmount);        

        healthFactor = collateralAmount.mulDiv(collateralAmount, liquidationThreshold, borrowedAmount);
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
    
}