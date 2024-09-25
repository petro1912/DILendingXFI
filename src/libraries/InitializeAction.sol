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
import {IRewardModule} from "../interfaces/IRewardModule.sol";
import {Events} from "./Events.sol";

library InitializeAction {

    function addCollateralTokens(
        State storage state, 
        InitialCollateralInfo[] memory _collateralsInfo
    ) external {
        uint256 tokenCount = _collateralsInfo.length;
        for (uint256 i = 0; i < tokenCount; ) {
            _addCollateralToken(state, _collateralsInfo[i]);
            unchecked {
                ++i;
            }
        }
    }    

    function _addCollateralToken(
        State storage state, 
        InitialCollateralInfo memory _collateralInfo
    ) internal {
        address collateralToken = address(_collateralInfo.tokenAddress);
        require(collateralToken != address(0), "WrongAddress");

        state.tokenConfig.collateralTokens.push(_collateralInfo.tokenAddress);
        state.tokenConfig.collateralsInfo[collateralToken].whitelisted = true;
        state.tokenConfig.collateralsInfo[collateralToken].collateralKey = _collateralInfo.collateralKey;
    }

    function setLoanToValue(
        State storage state, 
        uint256 _loanToValue
    ) external {
        require(_loanToValue > 0 && _loanToValue <= 1e18, "InvalidValue");
        state.riskConfig.loanToValue = _loanToValue;
        emit Events.LoanToValueUpdated(_loanToValue);
    }

    function setLiquidationThreshold(
        State storage state, 
        uint256 _liquidationThreshold
    ) external {
        require(_liquidationThreshold > state.riskConfig.loanToValue && _liquidationThreshold <= 1e18, "InvalidValue");
        state.riskConfig.liquidationThreshold = _liquidationThreshold;
        emit Events.LiquidationThresholdUpdated(_liquidationThreshold);
    }

    function setHealthFactorForClose(
        State storage state, 
        uint256 _healthFactorForClose
    ) external {
        require(_healthFactorForClose > 0 && _healthFactorForClose <= 1e18, "InvalidValue");
        state.riskConfig.healthFactorForClose = _healthFactorForClose;
        emit Events.HealthFactorForCloseUpdated(_healthFactorForClose);
    }    

    function setLiquidationBonus(
        State storage state, 
        uint256 _liquidationBonus
    ) external {
        require(_liquidationBonus > 0 && _liquidationBonus <= 1e18, "InvalidValue");
        state.riskConfig.liquidationBonus = _liquidationBonus;
        emit Events.LiquidationBonusUpdated(_liquidationBonus);
    }

    function setProtocolFeeRate(
        State storage state, 
        uint256 _protocolFeeRate
    ) external {
        require(_protocolFeeRate > 0 && _protocolFeeRate <= 1e18, "InvalidValue");
        state.feeConfig.protocolFeeRate = _protocolFeeRate;
        emit Events.ProtocolFeeRateUpdated(_protocolFeeRate);
    }

    function setProtocolFeeRecipient(
        State storage state, 
        address _protocolFeeRecipient
    ) external {
        require(_protocolFeeRecipient != address(0), "WrongAddress");
        state.feeConfig.protocolFeeRecipient = _protocolFeeRecipient;
        emit Events.ProtocolFeeRecipientUpdated(_protocolFeeRecipient);
    }

    function setBorrowTokenCap(
        State storage state, 
        uint256 _borrowTokenCap
    ) external {
        require(_borrowTokenCap > 0, "InvalidValue");
        state.riskConfig.borrowTokenCap = _borrowTokenCap;
        emit Events.BorrowTokenCapUpdated(_borrowTokenCap);
    }

    function setMinimuBorrowToken(
        State storage state,
        uint256 _minBorrowToken
    ) external {
        require(_minBorrowToken > 0, "InvalidValue");
        state.riskConfig.minimumBorrowToken = _minBorrowToken;
        emit Events.MinimumBorrowTokenUpdated(_minBorrowToken);
    }

    function setInterestRateConfig(        
        State storage state, 
        RateConfig memory _rateConfig
    ) external {
        RateConfig storage rateConfig = state.rateConfig;

        rateConfig.baseRate = _rateConfig.baseRate;
        rateConfig.rateSlope1 = _rateConfig.rateSlope1;
        rateConfig.rateSlope2 = _rateConfig.rateSlope2;
        rateConfig.reserveFactor = _rateConfig.reserveFactor;
        rateConfig.optimalUtilizationRate = _rateConfig.optimalUtilizationRate;
    }

    // function setTokenRewardModules(
    //     State storage state,
    //     address token,
    //     IRewardModule[] memory modules
    // ) external {
    //     require(token == address(state.tokenConfig.principalToken) || state.tokenConfig.collateralsInfo[token].whitelisted, "InvalidToken");
    //     require(modules.length > 0, "WrongRewardConfig");
    //     state.rewardConfig.rewardModules[token] = modules;        
    // }

    function setTokenRewardModule(
        State storage state,
        address token,
        IRewardModule module
    ) external {
        require(token == address(state.tokenConfig.principalToken) || state.tokenConfig.collateralsInfo[token].whitelisted, "InvalidToken");
        require(address(module) != address(0), "WrongRewardConfig");
        state.rewardConfig.rewardModules[token] = module;        
    }

}