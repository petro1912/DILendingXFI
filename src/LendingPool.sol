// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import {
    LendingPoolStorage, 
    InitializeParam, 
    TokenConfig, 
    CollateralInfo,
    InitializeTokenConfig,
    InitialCollateralInfo,
    RiskConfig, 
    RateConfig,
    FeeConfig, 
    ReserveData
} from "./LendingPoolStorage.sol";
import {LendingPoolAction} from "./LendingPoolAction.sol";
import {Events} from "./libraries/Events.sol";
import {Borrow} from "./libraries/Borrow.sol";
import {Supply} from "./libraries/Supply.sol";
import { InterestRateModel } from "./libraries/InterestRateModel.sol";
import {Liquidation} from "./libraries/Liquidation.sol";
import {console} from 'forge-std/console.sol';

contract LendingPool is 
    LendingPoolAction, 
    Ownable 
{
    using SafeERC20 for IERC20;
    
    constructor(
        InitializeParam memory param,
        address _owner
    ) Ownable(_owner) {      
        initilizeTokenConfig(param.tokenConfig);
        initializeRiskConfig(param.riskConfig);
        initializeFeeConfig(param.feeConfig);
        initializeRateData(param.rateConfig);
    }    

    function initilizeTokenConfig(
        InitializeTokenConfig memory tokenInfo
    ) internal {
        require(address(tokenInfo.principalToken) != address(0), "Wrong Address");
        state.tokenConfig.principalToken = tokenInfo.principalToken;
        state.tokenConfig.principalKey = tokenInfo.principalKey;
        state.tokenConfig.oracle = tokenInfo.oracle;
        _addCollateralTokens(tokenInfo.collaterals);
    }
    

    function initializeRiskConfig(
        RiskConfig memory riskConfig
    ) internal {
        _setLoanToValue(riskConfig.loanToValue);
        _setLiquidationThreshold(riskConfig.liquidationThreshold);
        _setMinimuBorrowToken(riskConfig.minimumBorrowToken);
        _setBorrowTokenCap(riskConfig.borrowTokenCap);
        _setHealthFactorForClose(riskConfig.healthFactorForClose);
        _setLiquidationBonus(riskConfig.liquidationBonus);
    }

    function initializeFeeConfig(
        FeeConfig memory feeConfig
    ) internal {
        _setProtocolFeeRate(feeConfig.protocolFeeRate);
        _setProtocolFeeRecipient(feeConfig.protocolFeeRecipient);
    }

    function initializeRateData(
        RateConfig memory rateConfig
    ) internal {
        state.rateData.debtIndex = 1e18;
        state.rateData.liquidityIndex = 1e18;
        state.rateData.borrowRate = rateConfig.baseRate;
        state.rateData.lastUpdated = block.timestamp;

        _setInterestRateConfig(rateConfig);
    }

    // ========================== Management Functions ==========================

    function addCollateralTokens(InitialCollateralInfo[] memory _collateralsInfo) external onlyOwner {
        _addCollateralTokens(_collateralsInfo);
    }
    
    function _addCollateralTokens(InitialCollateralInfo[] memory _collateralsInfo) internal {
        uint256 tokenCount = _collateralsInfo.length;
        for (uint256 i = 0; i < tokenCount; ) {
            _addCollateralToken(_collateralsInfo[i]);
            unchecked {
                ++i;
            }
        }
    }    

    function _addCollateralToken(InitialCollateralInfo memory _collateralInfo) internal {
        address collateralToken = address(_collateralInfo.tokenAddress);
        require(collateralToken != address(0), "Wrong Address");

        state.tokenConfig.collateralTokens.push(_collateralInfo.tokenAddress);
        state.tokenConfig.collateralsInfo[collateralToken].whitelisted = true;
        state.tokenConfig.collateralsInfo[collateralToken].collateralKey = _collateralInfo.collateralKey;
    }

    function setLoanToValue(uint256 _loanToValue) external onlyOwner {
        _setLoanToValue(_loanToValue);
    }

    function setLiquidationThreshold(uint256 _liquidationThreshold) external onlyOwner {
        _setLiquidationThreshold(_liquidationThreshold);
    }

    function setHealthFactorForClose(uint256 _healthFactorForClose) external onlyOwner {
        _setHealthFactorForClose(_healthFactorForClose);
    }    

    function setLiquidationBonus(uint256 _liquidationBonus) external onlyOwner {
        _setLiquidationBonus(_liquidationBonus);
    }

    function setProtocolFeeRate(uint256 _protocolFeeRate) external onlyOwner {
        _setProtocolFeeRate(_protocolFeeRate);
    }

    function setProtocolFeeRecipient(address _protocolFeeRecipient) external onlyOwner {
        _setProtocolFeeRecipient(_protocolFeeRecipient);
    }

    function setBorrowTokenCap(uint256 _borrowTokenCap) external onlyOwner {
        _setBorrowTokenCap(_borrowTokenCap);
    }

    function setMinimuBorrowToken(uint256 _minBorrowToken) external onlyOwner {
        _setMinimuBorrowToken(_minBorrowToken);
    }

    function setInterestRateConfig(        
        RateConfig memory _rateConfig
    ) public onlyOwner {
        _setInterestRateConfig(_rateConfig);
    }

    function _setLoanToValue(uint256 _loanToValue) internal {
        require(_loanToValue > 0 && _loanToValue <= 1e18, "Invalid liquidation threshold");
        state.riskConfig.loanToValue = _loanToValue;
        emit Events.LoanToValueUpdated(_loanToValue);
    }

    function _setLiquidationThreshold(uint256 _liquidationThreshold) internal {
        require(_liquidationThreshold > state.riskConfig.loanToValue && _liquidationThreshold <= 1e18, "Invalid liquidation threshold");
        state.riskConfig.liquidationThreshold = _liquidationThreshold;
        emit Events.LiquidationThresholdUpdated(_liquidationThreshold);
    }

    function _setHealthFactorForClose(uint256 _healthFactorForClose) internal {
        require(_healthFactorForClose > 0 && _healthFactorForClose <= 1e18, "Invalid liquidation penalty");
        state.riskConfig.healthFactorForClose = _healthFactorForClose;
        emit Events.HealthFactorForCloseUpdated(_healthFactorForClose);
    }    

    function _setLiquidationBonus(uint256 _liquidationBonus) internal {
        require(_liquidationBonus > 0 && _liquidationBonus <= 1e18, "Invalid liquidation bonus");
        state.riskConfig.liquidationBonus = _liquidationBonus;
        emit Events.LiquidationBonusUpdated(_liquidationBonus);
    }

    function _setProtocolFeeRate(uint256 _protocolFeeRate) internal {
        require(_protocolFeeRate > 0 && _protocolFeeRate <= 1e18, "Invalid protocol fee rate");
        state.feeConfig.protocolFeeRate = _protocolFeeRate;
        emit Events.ProtocolFeeRateUpdated(_protocolFeeRate);
    }

    function _setProtocolFeeRecipient(address _protocolFeeRecipient) internal {
        require(_protocolFeeRecipient != address(0), "Invalid address");
        state.feeConfig.protocolFeeRecipient = _protocolFeeRecipient;
        emit Events.ProtocolFeeRecipientUpdated(_protocolFeeRecipient);
    }

    function _setBorrowTokenCap(uint256 _borrowTokenCap) internal {
        require(_borrowTokenCap > 0, "Invalid Borrow Token Cap");
        state.riskConfig.borrowTokenCap = _borrowTokenCap;
        emit Events.BorrowTokenCapUpdated(_borrowTokenCap);
    }

    function _setMinimuBorrowToken(uint256 _minBorrowToken) internal {
        require(_minBorrowToken > 0, "Invalid Minimum Borrow Token Cap");
        state.riskConfig.minimumBorrowToken = _minBorrowToken;
        emit Events.MinimumBorrowTokenUpdated(_minBorrowToken);
    }

    function _setInterestRateConfig(        
        RateConfig memory _rateConfig
    ) internal {
        RateConfig storage rateConfig = state.rateConfig;

        rateConfig.baseRate = _rateConfig.baseRate;
        rateConfig.rateSlope1 = _rateConfig.rateSlope1;
        rateConfig.rateSlope2 = _rateConfig.rateSlope2;
        rateConfig.reserveFactor = _rateConfig.reserveFactor;
        rateConfig.optimalUtilizationRate = _rateConfig.optimalUtilizationRate;
    }

}