// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {
    InitializeParam, 
    TokenConfig, 
    CollateralInfo,
    InitializeTokenConfig,
    InitialCollateralInfo,
    RiskConfig, 
    RateConfig,
    FeeConfig, 
    ReserveData,
    State
} from "../LendingPoolState.sol";
import {Events} from "./Events.sol";
import {InitializeAction} from "./InitializeAction.sol";

library InitializeConfig {

    function initialize(State storage state, InitializeParam memory param) external {
        initilizeTokenConfig(state, param.tokenConfig);
        initializeRiskConfig(state, param.riskConfig);
        initializeFeeConfig(state, param.feeConfig);
        initializeRateData(state, param.rateConfig);
    }

    function initilizeTokenConfig(
        State storage state, 
        InitializeTokenConfig memory tokenInfo
    ) internal {
        require(address(tokenInfo.principalToken) != address(0), "Wrong Address");
        state.tokenConfig.principalToken = tokenInfo.principalToken;
        state.tokenConfig.principalKey = tokenInfo.principalKey;
        state.tokenConfig.oracle = tokenInfo.oracle;
        state.tokenConfig.investModule = tokenInfo.investModule;
        InitializeAction.addCollateralTokens(state, tokenInfo.collaterals);
    }
    
    function initializeRiskConfig(
        State storage state, 
        RiskConfig memory riskConfig
    ) internal {
        InitializeAction.setLoanToValue(state, riskConfig.loanToValue);
        InitializeAction.setLiquidationThreshold(state, riskConfig.liquidationThreshold);
        InitializeAction.setMinimuBorrowToken(state, riskConfig.minimumBorrowToken);
        InitializeAction.setBorrowTokenCap(state, riskConfig.borrowTokenCap);
        InitializeAction.setHealthFactorForClose(state, riskConfig.healthFactorForClose);
        InitializeAction.setLiquidationBonus(state, riskConfig.liquidationBonus);
    }

    function initializeFeeConfig(
        State storage state, 
        FeeConfig memory feeConfig
    ) internal {
        InitializeAction.setProtocolFeeRate(state, feeConfig.protocolFeeRate);
        InitializeAction.setProtocolFeeRecipient(state, feeConfig.protocolFeeRecipient);
    }

    function initializeRateData(
        State storage state, 
        RateConfig memory rateConfig
    ) internal {
        state.rateData.debtIndex = 1e18;
        state.rateData.liquidityIndex = 1e18;
        state.rateData.borrowRate = rateConfig.baseRate;
        state.rateData.lastUpdated = block.timestamp;

        InitializeAction.setInterestRateConfig(state, rateConfig);
    }

}