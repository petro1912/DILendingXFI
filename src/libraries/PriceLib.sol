// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { LendingPoolStorage, State, ReserveData } from "../LendingPoolStorage.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FixedPointMathLib} from "@solady/utils/FixedPointMathLib.sol";


library PriceLib {

    using FixedPointMathLib for uint256;

    function collateralPriceInPrincipal(
        State storage state,
        IERC20 collateralToken
    ) external returns(uint256) {
        
        IERC20 principalToken = state.tokenConfig.principalToken;
        
        string memory principalKey = principalToken.symbol();
        string memory collateralKey = collateralToken.symbol();

        (uint256 principalPrice, ) = oracle.getValue(principalKey);
        (uint256 collateralPrice, ) = oracle.getValue(collateralKey);
        

        return collateralPrice.divWad(principalPrice);
    }

    function collateralPriceInUSD(
        State storage state,
        IERC20 collateralToken
    ) external returns(uint256) {
        
        IERC20 principalToken = state.tokenConfig.principalToken;
        
        string memory collateralKey = collateralToken.symbol();

        (uint256 collateralPrice, ) = oracle.getValue(collateralKey);
        

        return collateralPrice;
    }
} 