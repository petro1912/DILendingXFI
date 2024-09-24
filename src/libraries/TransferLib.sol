// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { State, ReserveData } from "../LendingPoolState.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

library TransferLib {
    using SafeERC20 for IERC20;

    function transferPrincipal(State storage state, address _from, address _to, uint256 _amount) external {
        _validateTransfer(_from, _to, _amount);
        _validateAllowance(state.tokenConfig.principalToken, _from, address(this), _amount);
        state.tokenConfig.principalToken.safeTransferFrom(_from, _to, _amount);
    }

    function transferPrincipal(State storage state, address _to, uint256 _amount) external {
        _validateTransfer(_to, _amount);
        state.tokenConfig.principalToken.safeTransfer(_to, _amount);
    }

    function transferCollateral(State storage state, address _collateralToken, address _from, address _to, uint256 _amount) external {
        _validateTransfer(_from, _to, _amount);
        _validateAllowance(IERC20(_collateralToken), _from, address(this), _amount);
        _validateCollateralToken(state, _collateralToken);
        IERC20(_collateralToken).safeTransferFrom(_from, _to, _amount);
    }

    function transferCollateral(State storage state, address _collateralToken, address _to, uint256 _amount) external {
        _validateTransfer(_to, _amount);
        _validateCollateralToken(state, _collateralToken);
        IERC20(_collateralToken).safeTransfer(_to, _amount);
    }

    function _validateTransfer(address _from,  address _to, uint256 _amount) internal pure {
        require (_from != address(0) && _to != address(0), "Invalid address");
        require (_amount > 0, "Invalid Amount");
    }

    function _validateTransfer(address _to, uint256 _amount) internal pure {
        require (_to != address(0), "Invalid address");
        require (_amount > 0, "Invalid Amount");
    }

    function _validateCollateralToken(State storage state, address _collateralToken) internal view {
        require(state.tokenConfig.collateralsInfo[_collateralToken].whitelisted, "Not Supported Token");
    }

    function _validateAllowance(IERC20 token, address owner, address spender, uint256 _amount) internal view {
        require(token.allowance(owner, spender) >= _amount, "Not enough Approved amount");
    }
}