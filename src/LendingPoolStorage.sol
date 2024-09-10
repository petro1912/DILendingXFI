// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {InterestRateModel} from "./libraries/InterestRateModel.sol";
import { DIAOracleV2 } from "./oracle/DIAOracleV2Multiupdate.sol";


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

    State internal state;
}