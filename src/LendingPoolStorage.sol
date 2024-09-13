// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";
import {InterestRateModel} from "./libraries/InterestRateModel.sol";
import {AccountingLib} from './libraries/AccountingLib.sol';
import {PriceLib} from './libraries/PriceLib.sol';
import { DIAOracleV2 } from "./oracle/DIAOracleV2Multiupdate.sol";


struct PoolInfo {
    address poolAddress;
    address principalToken;
    // address[] collateralTokens;
    uint256 totalDeposits;
    uint256 totalBorrows;
    uint256 totalCollaterals;
    uint256 utilizationRate;
    uint256 borrowAPR;
    uint256 earnAPR;
}

struct CollateralData {
    address token;
    uint256 totalSupply;
    uint256 oraclePrice;
}

struct CollateralsData {
    CollateralData[] tokenData;
    uint256 loanToValue;
    uint256 liquidationThreshold;
    uint256 liquidationBonus;
}

struct PositionCollateral {
    address token;
    uint256 amount;
    uint256 value; 
}
struct UserCollateralData {
    PositionCollateral[] collaterals;
    uint256 totalValue;
}

struct UserDebtPositionData {
    uint256 collateralValue;
    uint256 currentDebtValue;
    uint256 liquidationPoint;
    uint256 borrowCapacity;
    uint256 availableToBorrow;
}

struct DebtPosition {
    mapping(address token => uint256 amount) collateralAmount;
    uint256 borrowAmount;
    uint256 repaidAmount;
    uint256 debtAmount; 
    uint256 totalBorrow;
}

struct CreditPosition {
    uint256 depositAmount;
    uint256 withdrawAmount;
    uint256 creditAmount;
    uint256 totalDeposit;
}

struct ReserveData {
    uint256 totalDeposits; // Total Deposits 
    uint256 totalWithdrawals; // Total Accumulated withdrawals
    mapping (address token => uint256 collateralAmount) totalCollaterals;
    uint256 totalBorrows; // Total Accumulated borrows
    uint256 totalRepaid; // Total Accumulated repaid
    uint256 totalCredit; 
}

struct RateData {
    uint256 utilizationRate;
    uint256 borrowRate;
    uint256 liquidityRate;
    uint256 debtIndex;
    uint256 liquidityIndex;
    uint256 lastUpdated;
}

struct TokenInfo {
    bool whitelisted;
    string collateralKey;
}

struct CollateralInfo {
    IERC20 tokenAddress;
    TokenInfo tokenInfo;
}

struct InitialCollateralInfo {
    IERC20 tokenAddress;
    string collateralKey;
}

struct TokenConfig {
    IERC20 principalToken; // USDT
    string principalKey;
    IERC20[] collateralTokens;
    mapping(address token => TokenInfo tokenInfo) collateralsInfo;
    DIAOracleV2 oracle;         
}

struct InitializeTokenConfig {
    IERC20 principalToken; // USDT
    string principalKey;
    DIAOracleV2 oracle;     
    InitialCollateralInfo[] collaterals;    
}

struct FeeConfig {
    uint256 protocolFeeRate; // Protocol fee rate on interest (e.g., 5%)
    address protocolFeeRecipient; // Protocol fee recipient 
}

struct RateConfig {
    uint256 baseRate; // Base rate (e.g., 2%)
    uint256 rateSlope1; // Slope 1 for utilization below optimal rate (e.g., 4%)
    uint256 rateSlope2; // Slope 2 for utilization above optimal rate (e.g., 20%)
    uint256 optimalUtilizationRate; // Optimal utilization rate (e.g., 80%)
    uint256 reserveFactor;
}

struct RiskConfig {
    uint256 loanToValue; // loan to value (e.g., 75%)
    uint256 liquidationThreshold; // Liquidation threshold (e.g., 80%)
    uint256 minimumBorrowToken;
    uint256 borrowTokenCap;    
    uint256 healthFactorForClose; // user’s health factor:  0.95<hf<1, the loan is eligible for a liquidation of 50%. user’s health factor:  hf<=0.95, the loan is eligible for a liquidation of 100%.
    uint256 liquidationBonus;    // Liquidation penalty (e.g., 5%)
}

struct PositionData {
    mapping(address => DebtPosition) debtPositions;
    mapping(address => CreditPosition) creditPositions;
    uint256 totalCredit;
    uint256 totalDebt;
}

struct InitializeParam {
    InitializeTokenConfig tokenConfig;
    FeeConfig feeConfig;
    RiskConfig riskConfig;
    RateConfig rateConfig;
}

struct State {
    TokenConfig tokenConfig;
    FeeConfig feeConfig;
    RiskConfig riskConfig;
    RateConfig rateConfig;
    ReserveData reserveData;
    RateData rateData;
    PositionData positionData;
}

abstract contract LendingPoolStorage {
    using FixedPointMathLib for uint256;
    using AccountingLib for State;
    using InterestRateModel for State;
    using PriceLib for State;
    
    State internal state;

    function getPrincipalToken() public view returns (address principalToken) {
        principalToken = address(state.tokenConfig.principalToken);
    }

    function getCollateralTokens() public view returns (address[] memory) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        address[] memory addresses = new address[](tokensCount);
        for (uint i = 0; i < tokensCount; ) {
            addresses[i] = address(collateralTokens[i]);
            unchecked {
                ++i;
            }
        }
        
        return addresses;
    }

    function getPoolStatistics() 
        public 
        view
        returns (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows
        ) 
    {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;

        totalDeposits = state.getPrincipalValueInUSD(state.reserveData.totalDeposits);
        totalBorrows = state.getPrincipalValueInUSD(state.reserveData.totalBorrows);
        for (uint i = 0; i < tokensCount; ) {
            address collateralToken = address(collateralTokens[i]);
            totalCollaterals += state.getCollateralValueInUSD(
                collateralToken, 
                state.reserveData.totalCollaterals[collateralToken]
            );
            unchecked {
                ++i;
            }
        }
    }

    function getPoolInfo() public view returns(PoolInfo memory info) {
        (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows
        ) = getPoolStatistics();

        info = PoolInfo({
            poolAddress: address(this),
            principalToken: getPrincipalToken(),
            // collateralTokens: getCollateralTokens(),
            totalDeposits: totalDeposits,
            totalBorrows: totalBorrows,
            totalCollaterals: totalCollaterals,
            utilizationRate: state.rateData.utilizationRate,
            borrowAPR: state.rateData.borrowRate,
            earnAPR: state.rateData.liquidityRate
        });
    }

    function getCollateralsData() public view returns(CollateralsData memory info) {

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        CollateralData[] memory _tokenData = new CollateralData[](tokensCount); 
        for (uint256 i = 0; i < tokensCount; ) {
            address _tokenAddress = address(collateralTokens[i]);
            uint256 _totalSupply = state.reserveData.totalCollaterals[_tokenAddress];
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

    function getUserCollateralData(address user) public view returns(UserCollateralData memory collateralData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        
        uint256 totalValue;
        PositionCollateral[] memory collaterals = new PositionCollateral[](tokensCount); 
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collateralAmount[tokenAddress];
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

    function getDebtPositionData(address user) public view returns(UserDebtPositionData memory positionData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        
        positionData.currentDebtValue = state.getRepaidAmount(position.debtAmount).mulDivUp(state.principalPriceInUSD(), 1e8);

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        uint256 collateralValue;
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collateralAmount[tokenAddress];
            if (collateralAmount != 0)
                collateralValue += collateralAmount.mulDiv(state.collateralPriceInUSD(tokenAddress), 1e8);
                
            unchecked {
                ++i;
            }
        }

        if (collateralValue != 0) {
            positionData.collateralValue = collateralValue;
            positionData.liquidationPoint = collateralValue.mulWadUp(state.riskConfig.liquidationThreshold);
            positionData.borrowCapacity = collateralValue.mulWadUp(state.riskConfig.loanToValue);
            positionData.availableToBorrow = positionData.borrowCapacity - positionData.currentDebtValue;
        }
    }
}