// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {DIAOracleV2} from "./oracle/DIAOracleV2Multiupdate.sol";
import {IRewardModule} from "./interfaces/IRewardModule.sol";
import {IInvestmentModule} from "./interfaces/IInvestmentModule.sol";

struct PoolInfo {
    address poolAddress;
    address principalToken;
    // address[] collateralTokens;
    uint256 totalDeposits;
    uint256 totalBorrows;
    uint256 totalEarnings;
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
    uint256 rewards;
    uint256 value; 
}
struct UserCollateralData {
    PositionCollateral[] collaterals;
    uint256 totalValue;
}

struct UserCreditPositionData {
    address poolAddress;
    address tokenAddress;
    uint256 liquidityAmount;
    uint256 liquidityValue;
    uint256 cashAmount;
    uint256 cashValue;
    uint256 earnedAmount;
    uint256 earnedValue;
}

struct UserDebtPositionData {
    address poolAddress;
    address tokenAddress;
    uint256 borrowAmount;
    uint256 borrowValue;
    uint256 collateralValue;
    uint256 currentDebtAmount;
    uint256 currentDebtValue;
    uint256 liquidationPoint;
    uint256 borrowCapacity;
    uint256 availableToBorrowAmount;
    uint256 availableToBorrowValue;
    uint256 rewards;
}

struct DebtPositionCollateral {
    uint256 amount;
    uint256 share;
    // uint256 rewardIndex;
    uint256 accruedRewards;
    uint256 lastAPR;
    uint256 lastRewardedAt;
}

struct DebtPosition {
    mapping(address token => DebtPositionCollateral collateral) collaterals;
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
    uint256 earnedAmount;
    uint256 earnedValue;
}

struct InvestReserveData {
    uint256 totalDeposits;
    uint256 totalInvested;
    uint256 totalRewards;
    // uint256 rewardIndex;
    uint256 rewardAPR;
    uint256 lastAPRUpdatedAt;
    uint256 shares;
}

struct ReserveData {
    uint256 totalDeposits; // Total Deposits 
    uint256 totalWithdrawals; // Total Accumulated withdrawals
    // mapping (address token => uint256 collateralAmount) totalCollaterals;
    // mapping (address token => uint256 invest) totalInvests;
    mapping (address token => InvestReserveData invest) totalCollaterals;
    uint256 totalBorrows; // Total Accumulated borrows
    uint256 totalRepaid; // Total Accumulated repaid
    uint256 totalInvested;
    uint256 totalRewards;
    // uint256 rewardIndex;
    uint256 rewardAPR;
    uint256 lastAPRUpdatedAt;
    uint256 totalRewardShares;
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
    IInvestmentModule investModule;
}

struct RewardConfig {
    // mapping(address token => IRewardModule[] modules) rewardModules;
    mapping(address token => IRewardModule module) rewardModules;
}

struct InitializeTokenConfig {
    IERC20 principalToken; // USDT
    string principalKey;
    DIAOracleV2 oracle; 
    IInvestmentModule investModule;    
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
    RewardConfig rewardConfig;
    RateData rateData;
    PositionData positionData;
}