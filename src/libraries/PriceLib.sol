// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import { Oracle } from "../oracle/Oracle.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";

library PriceLib {

    using FixedPointMathLib for uint256;

    function collateralPriceInPrincipal(
        State storage state
    ) external returns(uint256) {
        
        Oracle principalOracle = state.tokenConfig.principalOracle;
        uint256 collateralPrice = state.tokenConfig.collateralOracle.getPrice();
        uint256 principalPrice = FixedPointMathLib.WAD;
        if (address(principalOracle) != address(0))
            principalPrice = principalOracle.getPrice();

        return collateralPrice.divWad(principalPrice);
    }
} 