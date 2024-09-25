// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {InterestRateModel} from "./InterestRateModel.sol";
import {AccountingLib} from './AccountingLib.sol';
import {PriceLib} from './PriceLib.sol';
import {State, PoolInfo, CollateralsData, CollateralData} from "../LendingPoolState.sol";

library PoolStatistics {
    
    using AccountingLib for State;
    using InterestRateModel for State;
    using PriceLib for State;

    function getPoolStatistics(State storage state) 
        public 
        view
        returns (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) 
    {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;

        totalDeposits = state.reserveData.totalDeposits;
        totalBorrows = state.reserveData.totalBorrows;
        uint256 totalCredit = state.getCashAmount(state.reserveData.totalCredit);

        if (totalCredit > totalDeposits) {
            totalEarnings = totalCredit - totalDeposits;
        }

        for (uint i = 0; i < tokensCount; ) {
            address collateralToken = address(collateralTokens[i]);
            totalCollaterals += state.getCollateralValueInUSD(
                collateralToken, 
                state.reserveData.totalCollaterals[collateralToken].totalDeposits
            );
            unchecked {
                ++i;
            }
        }
    }

    function getPoolInfo(State storage state) public view returns(PoolInfo memory info) {
        (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) = getPoolStatistics(state);

        (
            uint256 utilizationRate, 
            uint256 liquidityRate, 
            uint256 borrowRate 
        ) = state.calcUpdatedRates();

        info = PoolInfo({
            poolAddress: address(this),
            principalToken: address(state.tokenConfig.principalToken),
            // collateralTokens: getCollateralTokens(),
            totalDeposits: totalDeposits,
            totalBorrows: totalBorrows,
            totalCollaterals: totalCollaterals,
            totalEarnings: totalEarnings, 
            utilizationRate: utilizationRate,
            borrowAPR: borrowRate,
            earnAPR: liquidityRate
        });
    }

    function getCollateralsData(State storage state) public view returns(CollateralsData memory info) {

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        CollateralData[] memory _tokenData = new CollateralData[](tokensCount); 
        for (uint256 i = 0; i < tokensCount; ) {
            address _tokenAddress = address(collateralTokens[i]);
            uint256 _totalSupply = state.reserveData.totalCollaterals[_tokenAddress].totalDeposits;
            uint256 _oraclePrice = state.collateralPriceInUSD(_tokenAddress);
            _tokenData[i] = CollateralData({
                token: _tokenAddress,
                totalSupply: _totalSupply,
                oraclePrice: _oraclePrice
            });
            
            unchecked {
                ++i;
            }
        }

        info = CollateralsData({
            tokenData: _tokenData,
            loanToValue: state.riskConfig.loanToValue,
            liquidationThreshold: state.riskConfig.liquidationThreshold,
            liquidationBonus: state.riskConfig.liquidationBonus
        });
    }
}