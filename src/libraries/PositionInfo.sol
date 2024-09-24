// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {
    State, 
    PositionCollateral, 
    CreditPosition, 
    DebtPosition,  
    UserCollateralData, 
    UserCreditPositionData, 
    UserDebtPositionData
} from "../LendingPoolState.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {InterestRateModel} from "./InterestRateModel.sol";
import {PriceLib} from './PriceLib.sol';

library PositionInfo {

    using FixedPointMathLib for uint256;
    using InterestRateModel for State;
    using PriceLib for State;
    
    function getUserCollateralData(State storage state, address user) external view returns(UserCollateralData memory collateralData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        
        uint256 totalValue;
        PositionCollateral[] memory collaterals = new PositionCollateral[](tokensCount); 
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collaterals[tokenAddress].amount;
            uint256 collateralValue;
            if (collateralAmount != 0) {
                collateralValue = collateralAmount.mulDiv(state.collateralPriceInUSD(tokenAddress), 1e8);
                totalValue += collateralValue;
            }
            
            collaterals[i] = PositionCollateral({
                token: tokenAddress,
                amount: collateralAmount,
                value: collateralValue
            });

            unchecked {
                ++i;
            }   
        }
        collateralData = UserCollateralData({
            collaterals: collaterals,
            totalValue: totalValue
        });
    } 

    function getLiquidityPositionData(State storage state, address user) public view returns(UserCreditPositionData memory positionData) {
        CreditPosition storage position = state.positionData.creditPositions[user];
        
        uint256 price = state.principalPriceInUSD();
        uint256 liquidityAmount = position.depositAmount;
        // if (liquidityAmount != 0) {
            uint256 liquidityValue = position.depositAmount.mulDiv(price, 1e8);
            uint256 cashAmount = state.getCashAmount(position.creditAmount);
            uint256 cashValue = cashAmount.mulDivUp(price, 1e8);

            uint256 earnedAmount = cashAmount > liquidityAmount? position.earnedAmount + cashAmount - liquidityAmount : position.earnedAmount;
            uint256 earnedValue = cashValue > liquidityValue? position.earnedValue + cashValue - liquidityValue : position.earnedValue;

            positionData = UserCreditPositionData({
                poolAddress: address(this),
                tokenAddress: address(state.tokenConfig.principalToken),
                liquidityAmount: liquidityAmount,
                liquidityValue: liquidityValue,
                cashAmount: cashAmount,
                cashValue: cashValue,
                earnedAmount: earnedAmount,
                earnedValue: earnedValue
            });
        // }
    }

    function getDebtPositionData(State storage state, address user) public view returns(UserDebtPositionData memory positionData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        uint256 principalPrice = state.principalPriceInUSD();
        positionData.borrowAmount = position.borrowAmount;
        positionData.borrowValue = position.borrowAmount.mulDiv(principalPrice, 1e8);
        positionData.currentDebtAmount = state.getRepaidAmount(position.debtAmount);
        positionData.currentDebtValue = state.getRepaidAmount(position.debtAmount).mulDivUp(principalPrice, 1e8);

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        uint256 collateralValue;
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collaterals[tokenAddress].amount;
            if (collateralAmount != 0)
                collateralValue += collateralAmount.mulDiv(state.collateralPriceInUSD(tokenAddress), 1e8);
                
            unchecked {
                ++i;
            }
        }

        // if (collateralValue != 0) {
            positionData.poolAddress = address(this);
            positionData.tokenAddress = address(state.tokenConfig.principalToken);
            positionData.collateralValue = collateralValue;
            positionData.liquidationPoint = collateralValue.mulWad(state.riskConfig.liquidationThreshold);
            positionData.borrowCapacity = collateralValue.mulWad(state.riskConfig.loanToValue);
            if (positionData.borrowCapacity > positionData.currentDebtValue) {
                positionData.availableToBorrowAmount = principalPrice == 0? 0 : (positionData.borrowCapacity - positionData.currentDebtValue).mulDiv(1e8, principalPrice);
                positionData.availableToBorrowValue = positionData.borrowCapacity - positionData.currentDebtValue;
            }
            
        // }
    }
}