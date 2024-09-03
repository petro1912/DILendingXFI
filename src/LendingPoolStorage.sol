// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Oracle} from "./oracle/Oracle.sol";
import {InterestRateModel} from "./InterestRateModel.sol";


struct DebtPosition {
    uint256 collateralAmount;
    uint256 borrowAmount;
    uint256 repaidAmount;
    uint256 debtAmount; 
}

struct CreditPosition {
    uint256 depositAmount;
    uint256 withdrawAmount;
    uint256 creditAmount;
}

struct ReserveData {
    uint256 totalDeposits;
    uint256 totalWithdrawals;
    uint256 totalCollaterals;
    uint256 totalBorrows;
    uint256 totalRepaid;
}

struct RateData {
    uint256 utilizationRate;
    uint256 borrowRate;
    uint256 liquidityRate;
    uint256 debtIndex;
    uint256 liquidityIndex;
    uint64 lastUpdated;
}

struct TokenConfig {
    IERC20 collateralToken; // XUSD
    IERC20 principalToken; // USDT
    Oracle collateralOracle; // XUSD
    Oracle pincipalOracle; // USDT        
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
    TokenConfig tokenConfig;
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