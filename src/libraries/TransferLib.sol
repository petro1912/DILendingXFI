// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

library TransferLib {
    using SafeERC20 for IERC20;

    function transferPrincipal(State storage state, address _from, address _to, uint256 _amount) external {
        _validateTransfer(_from, _to, _amount);
        state.tokenConfig.principalToken.safeTransferFrom(_from, _to, _amount);
    }

    function transferPrincipal(State storage state, address _to, uint256 _amount) external {
        _validateTransfer(_to, _amount);
        state.tokenConfig.principalToken.safeTransferFrom(address(this), _to, _amount);
    }

    function transferCollateral(State storage state, address _collateralToken, address _from, address _to, uint256 _amount) external {
        _validateTransfer(_from, _to, _amount);
        _validateCollateralToken(_collateralToken);
        IERC20(_collateralToken).safeTransferFrom(_from, _to, _amount);
    }

    function transferCollateral(State storage state, address _collateralToken, address _to, uint256 _amount) external {
        _validateTransfer(_to, _amount);
        _validateCollateralToken(_collateralToken);
        IERC20(_collateralToken).safeTransferFrom(address(this), _to, _amount);
    }

    function _validateTransfer(address _from,  address _to, uint256 _amount) internal {
        require (_from != 0 && _to != 0, "Invalid address");
        require (_amount > 0, "Invalid Amount");
    }

    function _validateTransfer(address _to, uint256 _amount) internal {
        require (_to != 0, "Invalid address");
        require (_amount > 0, "Invalid Amount");
    }

    function _validateCollateralToken(State storage state, address _collateralToken) internal {
        require(state.tokenConfig.collateralTokens[_collateralToken], "Not Supported Token");
    }
}