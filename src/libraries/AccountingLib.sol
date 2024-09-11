// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, DebtPosition, ReserveData } from "../LendingPoolStorage.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {PriceLib} from './PriceLib.sol';
import {InterestRateModel} from '../libraries/InterestRateModel.sol';

library AccountingLib {

    using FixedPointMathLib for uint256;
    using PriceLib for State;
    using InterestRateModel for State;

    uint256 constant WAD = 1e18;

    function getHealthInfo(
        State storage state, 
        address user
    ) 
        external 
        view
        returns(
            uint256 collateralAmount, 
            uint256 totalBorrowedAmount, 
            uint256 healthFactor
        ) 
    {        
        return _calcHealthInfo(state, user);
    }

    function getMaxLiquidationAmount(
        State storage state, 
        address user
    ) 
        external 
        view
        returns(
            uint256 healthFactor,
            uint256 totalBorrowedAmount,
            uint256 maxLiquidationAmount, 
            uint256 maxLiqudiationBonus
        ) 
    { 
        (, totalBorrowedAmount, healthFactor) = _calcHealthInfo(state, user);
        (
            maxLiquidationAmount,
            maxLiqudiationBonus
        )  = _calcMaxLiquidationAmount(state, totalBorrowedAmount, healthFactor);
    }

    function _calcHealthInfo(
        State storage state, 
        address user
    ) 
        internal 
        view
        returns(
            uint256 collateralAmount, 
            uint256 totalBorrowedAmount, 
            uint256 healthFactor
        ) 
    {
        DebtPosition storage position = state.positionData.debtPositions[user];
        if (position.debtAmount == 0)
            return (0, 0, WAD);

        uint256 liquidationThreshold = state.riskConfig.liquidationThreshold;
        uint256 repaidAmount = state.getRepaidAmount(position.debtAmount);
        collateralAmount = _collateralValueInUSD(state, position);
        totalBorrowedAmount = _principalValueInUSD(state, repaidAmount);        

        healthFactor = collateralAmount.mulDiv(liquidationThreshold, totalBorrowedAmount);
    }

    function _calcMaxLiquidationAmount(
        State storage state, 
        uint256 totalBorrowedAmount, 
        uint256 healthFactor
    ) 
        internal 
        view
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
    
    function getCollateralValueInPrincipal(State storage state, DebtPosition storage position) external view returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position);      
    }

    function getCollateralValueInPrincipal(State storage state, DebtPosition storage position, address collateralToken) external view returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position, collateralToken);
    }

    function getCollateralValueInUSD(State storage state, DebtPosition storage position) external view returns(uint256 usdValue) {
        return _collateralValueInUSD(state, position);
    }    

    function getCollateralValueInUSD(State storage state, address collateralToken, uint256 amount) external view returns (uint256 usdValue) {
        return state.collateralPriceInUSD(collateralToken).mulWad(amount);
    }

    function getPrincipalValueInUSD(State storage state, uint256 repaidAmount) external view returns(uint256 usdValue) {
        return _principalValueInUSD(state, repaidAmount);
    }  

    function _collateralValueInPrincipal(State storage state, DebtPosition storage position) internal view returns(uint256 principalAmount) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        for (uint256 i = 0; i < tokensCount; ) {
            principalAmount += _collateralValueInPrincipal(state, position, address(collateralTokens[i]));

            unchecked {
                ++i;
            }
        }        
    }

    function _collateralValueInPrincipal(State storage state, DebtPosition storage position, address collateralToken) internal view returns(uint256 principalAmount) {

        uint256 amount = position.collateralAmount[address(collateralToken)];    
        uint256 collateralPriceInPrincipal = state.collateralPriceInPrincipal(collateralToken);
        if (amount != 0) {
            principalAmount = amount.mulWad(collateralPriceInPrincipal);
        }
    }

    function _collateralValueInUSD(State storage state, DebtPosition storage position) internal view returns(uint256 principalAmount) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        for (uint256 i = 0; i < tokensCount; ) {
            principalAmount += _collateralValueInUSD(state, position, address(collateralTokens[i]));

            unchecked {
                ++i;
            }
        }        
    }

    function _collateralValueInUSD(State storage state, DebtPosition storage position, address collateralToken) internal view returns(uint256 usdValue) {

        uint256 amount = position.collateralAmount[collateralToken];    
        if (amount != 0) {
            uint256 collateralPrice = state.collateralPriceInUSD(collateralToken);
            usdValue = amount.mulWad(collateralPrice);
        }
    }

    function _principalValueInUSD(State storage state, uint256 repaidAmount) internal view returns(uint256 usdValue) {
        if (repaidAmount != 0) {
            uint256 principalPrice = state.principalPriceInUSD();
            usdValue = repaidAmount.mulWad(principalPrice);
        }
    }    
    
}