// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library Events {
 
    event PoolAdded(address poolAddress, address principalAddress);
    event DepositPrincipal(address indexed user, uint256 amount, uint256 credit);
    event WithdrawPrincipal(address indexed user, uint256 amount, uint256 credit);
    event CollateralDeposited(address indexed user, uint256 amount);
    event CollateralWithdrawn(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 borrowed, uint256 repaid);
    event Liquidated(address indexed borrower, address indexed liquidator, uint256 debtRepaid, uint256 collateralSeized);
    event FeeClaimed(address indexed user, uint256 amount);
    event InterestRateModelUpdated(address indexed newModel);

    event LoanToValueUpdated(uint256 newLTV);
    event LiquidationThresholdUpdated(uint256 newThreshold);
    event LiquidationBonusUpdated(uint256 newBonus);
    event HealthFactorForCloseUpdated(uint256 healthFactorForClose);
    event ProtocolFeeRateUpdated(uint256 newFeeRate);
    event ProtocolFeeRecipientUpdated(address indexed newRecipient);
    event BorrowTokenCapUpdated(uint256 borrowTokenCap);
    event MinimumBorrowTokenUpdated(uint256 minimumBorrowToken);
}