// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {
    InitializeParam, 
    TokenConfig, 
    CollateralInfo,
    InitializeTokenConfig,
    InitialCollateralInfo,
    RiskConfig, 
    RateConfig,
    FeeConfig, 
    ReserveData
} from "./LendingPoolState.sol";

import {IRewardModule} from "./interfaces/IRewardModule.sol";
import {LendingPoolAction} from "./LendingPoolAction.sol";
import {Events} from "./libraries/Events.sol";
import { InterestRateModel } from "./libraries/InterestRateModel.sol";
import {Liquidation} from "./libraries/Liquidation.sol";
import {InitializeConfig} from "./libraries/InitializeConfig.sol";
import {InitializeAction} from "./libraries/InitializeAction.sol";

bytes32 constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

contract LendingPool is 
    LendingPoolAction, 
    AccessControl, 
    Pausable
{
    constructor(address owner) {      
        _grantRole(DEFAULT_ADMIN_ROLE, owner);
        _grantRole(PAUSER_ROLE, owner);
    }

    function initialize(InitializeParam memory param) public onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeConfig.initialize(state, param);
    }    

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function addCollateralTokens(InitialCollateralInfo[] memory _collateralsInfo) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.addCollateralTokens(state, _collateralsInfo);
    }
    
    function setLoanToValue(uint256 _loanToValue) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setLoanToValue(state, _loanToValue);
    }

    function setLiquidationThreshold(uint256 _liquidationThreshold) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setLiquidationThreshold(state, _liquidationThreshold);
    }

    function setHealthFactorForClose(uint256 _healthFactorForClose) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setHealthFactorForClose(state, _healthFactorForClose);
    }    

    function setLiquidationBonus(uint256 _liquidationBonus) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setLiquidationBonus(state, _liquidationBonus);
    }

    function setProtocolFeeRate(uint256 _protocolFeeRate) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setProtocolFeeRate(state, _protocolFeeRate);
    }

    function setProtocolFeeRecipient(address _protocolFeeRecipient) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setProtocolFeeRecipient(state, _protocolFeeRecipient);
    }

    function setBorrowTokenCap(uint256 _borrowTokenCap) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setBorrowTokenCap(state, _borrowTokenCap);
    }

    function setMinimuBorrowToken(uint256 _minBorrowToken) external onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setMinimuBorrowToken(state, _minBorrowToken);
    }

    function setInterestRateConfig(RateConfig memory _rateConfig) public onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setInterestRateConfig(state, _rateConfig);
    }  

    // function setTokenRewardModule(address token, IRewardModule[] memory modules) public onlyRole(DEFAULT_ADMIN_ROLE) {
    //     InitializeAction.setTokenRewardModules(state, token, modules);
    // }

    function setTokenRewardModule(address token, IRewardModule module) public onlyRole(DEFAULT_ADMIN_ROLE) {
        InitializeAction.setTokenRewardModule(state, token, module);
    }  

}