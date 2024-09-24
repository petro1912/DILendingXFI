// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { State, ReserveData } from "../LendingPoolState.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";


library PriceLib {

    using FixedPointMathLib for uint256;

    function collateralPriceInPrincipal(
        State storage state,
        address collateralToken
    ) external view returns(uint256) {
        
        string memory principalKey = state.tokenConfig.principalKey;
        string memory collateralKey = state.tokenConfig.collateralsInfo[collateralToken].collateralKey;

        (uint256 principalPrice, ) = state.tokenConfig.oracle.getValue(principalKey);
        (uint256 collateralPrice, ) = state.tokenConfig.oracle.getValue(collateralKey);
        

        return collateralPrice.divWad(principalPrice);
    }

    function principalPriceInUSD(
        State storage state
    ) external view returns(uint256 collateralPrice) {
        
        string memory principalKey = state.tokenConfig.principalKey;
        (collateralPrice, ) = state.tokenConfig.oracle.getValue(principalKey);
    }

    function collateralPriceInUSD(
        State storage state,
        address collateralToken
    ) external view returns(uint256 collateralPrice) {
        
        string memory collateralKey = state.tokenConfig.collateralsInfo[collateralToken].collateralKey;
        (collateralPrice, ) = state.tokenConfig.oracle.getValue(collateralKey);
    }

    function collateralValueInUSD(
        State storage state,
        address collateralToken,
        uint256 amount
    ) external view returns(uint256 valueInUSD) {
        
        string memory collateralKey = state.tokenConfig.collateralsInfo[collateralToken].collateralKey;
        (uint256 collateralPrice, ) = state.tokenConfig.oracle.getValue(collateralKey);
        valueInUSD = amount.mulDiv(collateralPrice, 1e8);
    }
} 