// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { ChainlinkOracle } from "./oracle/ChainlinkOracle.sol";
import { InterestRateModel } from "./InterestRateModel.sol";
import {LendingPoolStorage, InitializeParam, ReserveData, CollateralData} from "./LendingPoolStorage.sol";
import {LendingPoolView} from "./LendingPoolView.sol";
import {Events} from "./libraries/Events.sol";

contract LendingPool is 
    InterestRateModel, 
    Borrow, 
    Supply, 
    Liquidation, 
    LendingPoolView, 
    Ownable 
{

    using SafeERC20 for IERC20;
    
    constructor(
        InitializeParam param
    ) Ownable(msg.sender) {             
        initilizeTokenConfig(param.tokenConfig);
        initializeRiskConfig(param.riskConfig);
        initializeFeeConfig(param.feeConfig);
        initializeRateData(param.rateConfig);
    }    

    function initilizeTokenConfig(
        TokenConfig memory tokenConfig
    ) internal {
        require(
            tokenConfig.collateralToken != address(0) &&
            tokenConfig.principalToken != address(0) &&
            tokenConfig.collateralOracle != address(0),
            "Wrong Address"
        );             

        state.tokenConfig.collateralToken = IERC20(tokenConfig.collateralToken);
        state.tokenConfig.principalToken = IERC20(tokenConfig.principalToken);
        state.tokenConfig.collateralOracle = ChainlinkOracle(tokenConfig.collateralOracle);
        if (tokenConfig.principalOracle != address(0))
            state.tokenConfig.principalOracle = ChainlinkOracle(tokenConfig.principalOracle);
    }

    function initializeRiskConfig(
        RiskConfig memory riskConfig
    ) internal {
        setLoanToValue(riskConfig.loanToVaue);
        setLiquidationThreshold(riskConfig.liquidationThreshold);
        setMinimuBorrowToken(riskConfig.minBorrowToken);
        setBorrowTokenCap(riskConfig.borrowTokenCap);
        setHealthFactorForClose(riskConfig.healthFactorForClose);
        setLiquidationBonus(riskConfig.liquidationBonus);
    }

    function initializeFeeConfig(
        FeeConfig memory feeConfig
    ) internal {
        setProtocolFeeRate(feeConfig.protocolFeeRate);
        setProtocolFeeRecipient(feeConfig.protocolFeeRecipient);
    }

    function initializeRateData(
        RateConfig memory rateConfig
    ) {
        state.rateData.debtIndex = 1;
        state.rateData.liquidityIndex = 1;
        state.rateData.lastUpdated = block.timestamp;

        setInterestRateConfig(rateConfig);
    }

    // ========================== Management Functions ==========================

    function setLoanToValue(uint256 _loanToValue) external onlyOwner {
        require(_loanToValue > 0 && _loanToValue <= 1e18, "Invalid liquidation threshold");
        state.riskConfig.liquidationThreshold = _liquidationThreshold;
        emit Events.LoanToValueUpdated(_liquidationThreshold);
    }

    function setLiquidationThreshold(uint256 _liquidationThreshold) external onlyOwner {
        require(_liquidationThreshold > state.riskConfig.loanToValue && _liquidationThreshold <= 1e18, "Invalid liquidation threshold");
        state.riskConfig.liquidationThreshold = _liquidationThreshold;
        emit Events.LiquidationThresholdUpdated(_liquidationThreshold);
    }

    function setHealthFactorForClose(uint256 _healthFactorForClose) external onlyOwner {
        require(_liquidationBonus > 0 && _healthFactorForClose <= 1e18, "Invalid liquidation penalty");
        state.riskConfig.healthFactorForClose = _healthFactorForClose;
        emit Events.HealthFactorForCloseUpdated(_healthFactorForClose);
    }    

    function setLiquidationBonus(uint256 _liquidationBonus) external onlyOwner {
        require(_liquidationBonus > 0 && _liquidationBonus <= 1e18, "Invalid liquidation penalty");
        state.riskConfig.liquidationBonus = _liquidationBonus;
        emit Events.LiquidationBonusUpdated(_liquidationBonus);
    }

    function setProtocolFeeRate(uint256 _protocolFeeRate) external onlyOwner {
        require(_protocolFeeRate > 0 && _protocolFeeRate <= 1e18, "Invalid protocol fee rate");
        state.feeConfig.protocolFeeRate = _protocolFeeRate;
        emit Events.ProtocolFeeRateUpdated(_protocolFeeRate);
    }

    function setProtocolFeeRecipient(address _protocolFeeRecipient) external onlyOwner {
        require(_protocolFeeRecipient != address(0), "Invalid address");
        set.feeConfig.protocolFeeRecipient = _protocolFeeRecipient;
        emit Events.ProtocolFeeRecipientUpdated(_protocolFeeRecipient);
    }

    function setBorrowTokenCap(uint256 _borrowTokenCap) external onlyOwner {
        require(_borrowTokenCap > 0, "Invalid Borrow Token Cap");
        state.riskConfig.borrowTokenCap = _borrowTokenCap;
        emit Events.BorrowTokenCapUpdated(_borrowTokenCap);
    }

    function setMinimuBorrowToken(uint256 _minBorrowToken) external onlyOwner {
        require(_minBorrowToken > 0, "Invalid Minimum Borrow Token Cap");
        state.riskConfig.minimumBorrowToken = _minBorrowToken;
        emit Events.MinimumBorrowTokenUpdated(_minBorrowToken);
    }

    function setInterestRateConfig(        
        RateConfig memory _rateConfig
    ) public onlyOwner {
        RateConfig storage rateConfig = state.rateConfig;

        rateConfig.baseRate = _rateConfig.baseRate;
        rateConfig.rateSlope1 = _rateConfig.rateSlope1;
        rateConfig.rateSlope2 = _rateConfig.rateSlope2;
        rateConfig.optimalUtilizationRate = _rateConfig.optimalUtilizationRate;
    }


}