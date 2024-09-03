// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {State, RateConfig, RateData, ReserveData} from "./LendingPoolStorage.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";


library InterestRateModel {
    using FixedPointMathLib for uint256;
    
    uint256 constant YEAR = 1 years;     

    function updateInterestRates(State storage state) external {
        uint256 borrowRate;
        RateData storage rateData = state.rateData;
        ReserveData storage reserveData = state.reserveData;

        uint256 utilizationRate = _calculateUtilizationRate(reserveData.totalBorrows, reserveData.totalDeposits);
        uint256 borrowRate = _calculateBorrowRate(utilizationRate);
        
        rateData.utilizationRate = utilizationRate;
        rateData.borrowRate = borrowRate;
        rateData.liquidityRate = borrowRate.mulWad(utilizationRate).mulWad(WAD - reserveFactor);

        // update Liquidity and Debt Index
        uint256 elapsed = block.timestamp - rateData.lastUpdated;
        if (elapsed > 0) {
            rateData.debtIndex = rateData.debtIndex.mulWad((WAD + rateData.borrowRate) * elapsed) / YEAR;
            rateData.liquidityIndex = rateData.liquidityIndex.mulWad((WAD + rateData.liquidityRate) * elapsed) / YEAR;      
            rateData.lastUpdated = block.timestamp;            
        }
    }

     function calcUpdatedInterestRates(State storage state) external view returns (uint256 debtIndex, uint256 creditIndex) {
        uint256 borrowRate;
        RateData storage rateData = state.rateData;
        ReserveData storage reserveData = state.reserveData;

        uint256 utilizationRate = _calculateUtilizationRate(reserveData.totalBorrows, reserveData.totalDeposits);
        uint256 borrowRate = _calculateBorrowRate(utilizationRate);
        
        uint256 liquidityRate = borrowRate.mulWad(utilizationRate).mulWad(WAD - reserveFactor);

        // update Liquidity and Debt Index
        uint256 elapsed = block.timestamp - rateData.lastUpdated;
        if (elapsed > 0) {
            debtIndex = rateData.debtIndex.mulWad((WAD + borrowRate) * elapsed) / YEAR;
            liquidityIndex = rateData.liquidityIndex.mulWad((WAD + liquidityRate) * elapsed) / YEAR;                  
        }
    }
    
    
    function _calculateUtilizationRate(uint256 borrows, uint256 total) internal view returns(uint256) {
        if (reserveData.totalDeposits == 0)
            return 0;

        return FixedPointMathLib.divWad(reserveData.totalBorrows, reserveData.totalDeposits);
    }

    function _calculateBorrowRate(uint256 utilizationRate) internal view returns(uint256 borrowRate) {
        
        uint256 baseRate = state.rateConfig.baseRate;
        uint256 rateSlope1 = state.rateConfig.rateSlope1;
        uint256 rateSlope2 = state.rateConfig.rateSlope2;
        uint256 optimalUtilizationRate = state.rateConfig.optimalUtilizationRate;

        if (utilizationRate < optimalUtilizationRate) {
            borrowRate = baseRate + (utilizationRate * rateSlope1) / optimalUtilizationRate;
        } else {
            borrowRate = baseRate + rateSlope1 + ((utilizationRate - optimalUtilizationRate) * rateSlope2) / (WAD - optimalUtilizationRate);
        }
    }

    function getCreditAmount(State storage state, uint256 amount) external returns(uint256 credit) {
        credit = amount.divWad(state.rateData.liquidityIndex);
    }

    // amount of principal => debtToken Amount
    function getDebtAmount(State storage state, uint256 amount) external returns(uint256 debt) {
        debt = amount.divWadUp(state.rateData.debtIndex);
    }

    function getCashAmount(State storage state, uint256 credit) external returns(uint256 cash) {
        cash = credit.mulWad(state.rateData.liquidityIndex);
    }

    function getRepaidAmount(State storage state, uint256 debt) external returns(uint256 amount) {
        amount = debt.mulWadUp(state.rateData.debtIndex);
    }

}