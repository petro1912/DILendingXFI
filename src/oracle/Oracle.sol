// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IPriceFeed} from '../interfaces/IPriceFeed.sol';

/// @title ChainlinkOracle
/// @author Petro1912 

contract Oracle is IPriceFeed {
    error InvalidPrice();

    // chainlink USD feed are in 8 decimals
    // need to multiply by 10^10 to return price in 18 decimals
    uint256 private constant USD_ORACLE_DECIMALS = 10;

    AggregatorV3Interface public immutable priceOracle;

    constructor(address priceFeed)  {
        priceOracle = AggregatorV3Interface(priceFeed);
    }

    /// @notice Fetch token price using chainlink price feeds
    /// @dev Checks that returned price is positive and not stale
    /// @return price of the token in USD (scaled by 18 decimals)
    function getPrice() external view returns (uint256 price) {
        (
            uint80 roundId,
            int256 answer,
            ,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceOracle.latestRoundData();

        if (
            answer <= 0 ||
            updatedAt == 0 ||
            answeredInRound < roundId ||
            block.timestamp - updatedAt > TIMEOUT
        ) revert InvalidPrice();

        price = uint256(answer) * 10 ** USD_ORACLE_DECIMALS;
    }
}
