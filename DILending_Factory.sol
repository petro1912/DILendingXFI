// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18 ^0.8.20 ^0.8.4;

// lib/openzeppelin-contracts/contracts/access/IAccessControl.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/IAccessControl.sol)

/**
 * @dev External interface of AccessControl declared to support ERC-165 detection.
 */
interface IAccessControl {
    /**
     * @dev The `account` is missing a role.
     */
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    /**
     * @dev The caller of a function is not the expected one.
     *
     * NOTE: Don't confuse with {AccessControlUnauthorizedAccount}.
     */
    error AccessControlBadConfirmation();

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     */
    event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call. This account bears the admin role (for the granted role).
     * Expected in cases where the role was granted using the internal {AccessControl-_grantRole}.
     */
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     */
    function renounceRole(bytes32 role, address callerConfirmation) external;
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// lib/openzeppelin-contracts/contracts/utils/Errors.sol

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();

    /**
     * @dev A necessary precompile is missing.
     */
    error MissingPrecompile(address);
}

// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/solady/src/utils/FixedPointMathLib.sol

/// @notice Arithmetic library with operations for fixed-point numbers.
/// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/FixedPointMathLib.sol)
/// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/FixedPointMathLib.sol)
library FixedPointMathLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The operation failed, as the output exceeds the maximum value of uint256.
    error ExpOverflow();

    /// @dev The operation failed, as the output exceeds the maximum value of uint256.
    error FactorialOverflow();

    /// @dev The operation failed, due to an overflow.
    error RPowOverflow();

    /// @dev The mantissa is too big to fit.
    error MantissaOverflow();

    /// @dev The operation failed, due to an multiplication overflow.
    error MulWadFailed();

    /// @dev The operation failed, due to an multiplication overflow.
    error SMulWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error DivWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error SDivWadFailed();

    /// @dev The operation failed, either due to a multiplication overflow, or a division by a zero.
    error MulDivFailed();

    /// @dev The division failed, as the denominator is zero.
    error DivFailed();

    /// @dev The full precision multiply-divide operation failed, either due
    /// to the result being larger than 256 bits, or a division by a zero.
    error FullMulDivFailed();

    /// @dev The output is undefined, as the input is less-than-or-equal to zero.
    error LnWadUndefined();

    /// @dev The input outside the acceptable domain.
    error OutOfDomain();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev The scalar of ETH and most ERC20s.
    uint256 internal constant WAD = 1e18;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              SIMPLIFIED FIXED POINT OPERATIONS             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function mulWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down.
    function sMulWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require((x == 0 || z / x == y) && !(x == -1 && y == type(int256).min))`.
            if iszero(gt(or(iszero(x), eq(sdiv(z, x), y)), lt(not(x), eq(y, shl(255, 1))))) {
                mstore(0x00, 0xedcd4dd4) // `SMulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := sdiv(z, WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down, but without overflow checks.
    function rawMulWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded down, but without overflow checks.
    function rawSMulWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(mul(x, y), WAD)
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded up.
    function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y == 0 || x <= type(uint256).max / y)`.
            if mul(y, gt(x, div(not(0), y))) {
                mstore(0x00, 0xbac65e5b) // `MulWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }

    /// @dev Equivalent to `(x * y) / WAD` rounded up, but without overflow checks.
    function rawMulWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(iszero(iszero(mod(mul(x, y), WAD))), div(mul(x, y), WAD))
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down.
    function divWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y != 0 && (WAD == 0 || x <= type(uint256).max / WAD))`.
            if iszero(mul(y, iszero(mul(WAD, gt(x, div(not(0), WAD)))))) {
                mstore(0x00, 0x7c5f487d) // `DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down.
    function sDivWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, WAD)
            // Equivalent to `require(y != 0 && ((x * WAD) / WAD == x))`.
            if iszero(and(iszero(iszero(y)), eq(sdiv(z, WAD), x))) {
                mstore(0x00, 0x5c43740d) // `SDivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := sdiv(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down, but without overflow and divide by zero checks.
    function rawDivWad(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded down, but without overflow and divide by zero checks.
    function rawSDivWad(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(mul(x, WAD), y)
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded up.
    function divWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // Equivalent to `require(y != 0 && (WAD == 0 || x <= type(uint256).max / WAD))`.
            if iszero(mul(y, iszero(mul(WAD, gt(x, div(not(0), WAD)))))) {
                mstore(0x00, 0x7c5f487d) // `DivWadFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(mul(x, WAD), y))), div(mul(x, WAD), y))
        }
    }

    /// @dev Equivalent to `(x * WAD) / y` rounded up, but without overflow and divide by zero checks.
    function rawDivWadUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := add(iszero(iszero(mod(mul(x, WAD), y))), div(mul(x, WAD), y))
        }
    }

    /// @dev Equivalent to `x` to the power of `y`.
    /// because `x ** y = (e ** ln(x)) ** y = e ** (ln(x) * y)`.
    /// Note: This function is an approximation.
    function powWad(int256 x, int256 y) internal pure returns (int256) {
        // Using `ln(x)` means `x` must be greater than 0.
        return expWad((lnWad(x) * y) / int256(WAD));
    }

    /// @dev Returns `exp(x)`, denominated in `WAD`.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/22/exp-ln
    /// Note: This function is an approximation. Monotonically increasing.
    function expWad(int256 x) internal pure returns (int256 r) {
        unchecked {
            // When the result is less than 0.5 we return zero.
            // This happens when `x <= (log(1e-18) * 1e18) ~ -4.15e19`.
            if (x <= -41446531673892822313) return r;

            /// @solidity memory-safe-assembly
            assembly {
                // When the result is greater than `(2**255 - 1) / 1e18` we can not represent it as
                // an int. This happens when `x >= floor(log((2**255 - 1) / 1e18) * 1e18) ≈ 135`.
                if iszero(slt(x, 135305999368893231589)) {
                    mstore(0x00, 0xa37bfec9) // `ExpOverflow()`.
                    revert(0x1c, 0x04)
                }
            }

            // `x` is now in the range `(-42, 136) * 1e18`. Convert to `(-42, 136) * 2**96`
            // for more intermediate precision and a binary basis. This base conversion
            // is a multiplication by 1e18 / 2**96 = 5**18 / 2**78.
            x = (x << 78) / 5 ** 18;

            // Reduce range of x to (-½ ln 2, ½ ln 2) * 2**96 by factoring out powers
            // of two such that exp(x) = exp(x') * 2**k, where k is an integer.
            // Solving this gives k = round(x / log(2)) and x' = x - k * log(2).
            int256 k = ((x << 96) / 54916777467707473351141471128 + 2 ** 95) >> 96;
            x = x - k * 54916777467707473351141471128;

            // `k` is in the range `[-61, 195]`.

            // Evaluate using a (6, 7)-term rational approximation.
            // `p` is made monic, we'll multiply by a scale factor later.
            int256 y = x + 1346386616545796478920950773328;
            y = ((y * x) >> 96) + 57155421227552351082224309758442;
            int256 p = y + x - 94201549194550492254356042504812;
            p = ((p * y) >> 96) + 28719021644029726153956944680412240;
            p = p * x + (4385272521454847904659076985693276 << 96);

            // We leave `p` in `2**192` basis so we don't need to scale it back up for the division.
            int256 q = x - 2855989394907223263936484059900;
            q = ((q * x) >> 96) + 50020603652535783019961831881945;
            q = ((q * x) >> 96) - 533845033583426703283633433725380;
            q = ((q * x) >> 96) + 3604857256930695427073651918091429;
            q = ((q * x) >> 96) - 14423608567350463180887372962807573;
            q = ((q * x) >> 96) + 26449188498355588339934803723976023;

            /// @solidity memory-safe-assembly
            assembly {
                // Div in assembly because solidity adds a zero check despite the unchecked.
                // The q polynomial won't have zeros in the domain as all its roots are complex.
                // No scaling is necessary because p is already `2**96` too large.
                r := sdiv(p, q)
            }

            // r should be in the range `(0.09, 0.25) * 2**96`.

            // We now need to multiply r by:
            // - The scale factor `s ≈ 6.031367120`.
            // - The `2**k` factor from the range reduction.
            // - The `1e18 / 2**96` factor for base conversion.
            // We do this all at once, with an intermediate result in `2**213`
            // basis, so the final right shift is always by a positive amount.
            r = int256(
                (uint256(r) * 3822833074963236453042738258902158003155416615667) >> uint256(195 - k)
            );
        }
    }

    /// @dev Returns `ln(x)`, denominated in `WAD`.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/22/exp-ln
    /// Note: This function is an approximation. Monotonically increasing.
    function lnWad(int256 x) internal pure returns (int256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            // We want to convert `x` from `10**18` fixed point to `2**96` fixed point.
            // We do this by multiplying by `2**96 / 10**18`. But since
            // `ln(x * C) = ln(x) + ln(C)`, we can simply do nothing here
            // and add `ln(2**96 / 10**18)` at the end.

            // Compute `k = log2(x) - 96`, `r = 159 - k = 255 - log2(x) = 255 ^ log2(x)`.
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // We place the check here for more optimal stack operations.
            if iszero(sgt(x, 0)) {
                mstore(0x00, 0x1615e638) // `LnWadUndefined()`.
                revert(0x1c, 0x04)
            }
            // forgefmt: disable-next-item
            r := xor(r, byte(and(0x1f, shr(shr(r, x), 0x8421084210842108cc6318c6db6d54be)),
                0xf8f9f9faf9fdfafbf9fdfcfdfafbfcfef9fafdfafcfcfbfefafafcfbffffffff))

            // Reduce range of x to (1, 2) * 2**96
            // ln(2^k * x) = k * ln(2) + ln(x)
            x := shr(159, shl(r, x))

            // Evaluate using a (8, 8)-term rational approximation.
            // `p` is made monic, we will multiply by a scale factor later.
            // forgefmt: disable-next-item
            let p := sub( // This heavily nested expression is to avoid stack-too-deep for via-ir.
                sar(96, mul(add(43456485725739037958740375743393,
                sar(96, mul(add(24828157081833163892658089445524,
                sar(96, mul(add(3273285459638523848632254066296,
                    x), x))), x))), x)), 11111509109440967052023855526967)
            p := sub(sar(96, mul(p, x)), 45023709667254063763336534515857)
            p := sub(sar(96, mul(p, x)), 14706773417378608786704636184526)
            p := sub(mul(p, x), shl(96, 795164235651350426258249787498))
            // We leave `p` in `2**192` basis so we don't need to scale it back up for the division.

            // `q` is monic by convention.
            let q := add(5573035233440673466300451813936, x)
            q := add(71694874799317883764090561454958, sar(96, mul(x, q)))
            q := add(283447036172924575727196451306956, sar(96, mul(x, q)))
            q := add(401686690394027663651624208769553, sar(96, mul(x, q)))
            q := add(204048457590392012362485061816622, sar(96, mul(x, q)))
            q := add(31853899698501571402653359427138, sar(96, mul(x, q)))
            q := add(909429971244387300277376558375, sar(96, mul(x, q)))

            // `p / q` is in the range `(0, 0.125) * 2**96`.

            // Finalization, we need to:
            // - Multiply by the scale factor `s = 5.549…`.
            // - Add `ln(2**96 / 10**18)`.
            // - Add `k * ln(2)`.
            // - Multiply by `10**18 / 2**96 = 5**18 >> 78`.

            // The q polynomial is known not to have zeros in the domain.
            // No scaling required because p is already `2**96` too large.
            p := sdiv(p, q)
            // Multiply by the scaling factor: `s * 5**18 * 2**96`, base is now `5**18 * 2**192`.
            p := mul(1677202110996718588342820967067443963516166, p)
            // Add `ln(2) * k * 5**18 * 2**192`.
            // forgefmt: disable-next-item
            p := add(mul(16597577552685614221487285958193947469193820559219878177908093499208371, sub(159, r)), p)
            // Add `ln(2**96 / 10**18) * 5**18 * 2**192`.
            p := add(600920179829731861736702779321621459595472258049074101567377883020018308, p)
            // Base conversion: mul `2**18 / 2**192`.
            r := sar(174, p)
        }
    }

    /// @dev Returns `W_0(x)`, denominated in `WAD`.
    /// See: https://en.wikipedia.org/wiki/Lambert_W_function
    /// a.k.a. Product log function. This is an approximation of the principal branch.
    /// Note: This function is an approximation. Monotonically increasing.
    function lambertW0Wad(int256 x) internal pure returns (int256 w) {
        // forgefmt: disable-next-item
        unchecked {
            if ((w = x) <= -367879441171442322) revert OutOfDomain(); // `x` less than `-1/e`.
            int256 wad = int256(WAD);
            int256 p = x;
            uint256 c; // Whether we need to avoid catastrophic cancellation.
            uint256 i = 4; // Number of iterations.
            if (w <= 0x1ffffffffffff) {
                if (-0x4000000000000 <= w) {
                    i = 1; // Inputs near zero only take one step to converge.
                } else if (w <= -0x3ffffffffffffff) {
                    i = 32; // Inputs near `-1/e` take very long to converge.
                }
            } else if (uint256(w >> 63) == uint256(0)) {
                /// @solidity memory-safe-assembly
                assembly {
                    // Inline log2 for more performance, since the range is small.
                    let v := shr(49, w)
                    let l := shl(3, lt(0xff, v))
                    l := add(or(l, byte(and(0x1f, shr(shr(l, v), 0x8421084210842108cc6318c6db6d54be)),
                        0x0706060506020504060203020504030106050205030304010505030400000000)), 49)
                    w := sdiv(shl(l, 7), byte(sub(l, 31), 0x0303030303030303040506080c13))
                    c := gt(l, 60)
                    i := add(2, add(gt(l, 53), c))
                }
            } else {
                int256 ll = lnWad(w = lnWad(w));
                /// @solidity memory-safe-assembly
                assembly {
                    // `w = ln(x) - ln(ln(x)) + b * ln(ln(x)) / ln(x)`.
                    w := add(sdiv(mul(ll, 1023715080943847266), w), sub(w, ll))
                    i := add(3, iszero(shr(68, x)))
                    c := iszero(shr(143, x))
                }
                if (c == uint256(0)) {
                    do { // If `x` is big, use Newton's so that intermediate values won't overflow.
                        int256 e = expWad(w);
                        /// @solidity memory-safe-assembly
                        assembly {
                            let t := mul(w, div(e, wad))
                            w := sub(w, sdiv(sub(t, x), div(add(e, t), wad)))
                        }
                        if (p <= w) break;
                        p = w;
                    } while (--i != uint256(0));
                    /// @solidity memory-safe-assembly
                    assembly {
                        w := sub(w, sgt(w, 2))
                    }
                    return w;
                }
            }
            do { // Otherwise, use Halley's for faster convergence.
                int256 e = expWad(w);
                /// @solidity memory-safe-assembly
                assembly {
                    let t := add(w, wad)
                    let s := sub(mul(w, e), mul(x, wad))
                    w := sub(w, sdiv(mul(s, wad), sub(mul(e, t), sdiv(mul(add(t, wad), s), add(t, t)))))
                }
                if (p <= w) break;
                p = w;
            } while (--i != c);
            /// @solidity memory-safe-assembly
            assembly {
                w := sub(w, sgt(w, 2))
            }
            // For certain ranges of `x`, we'll use the quadratic-rate recursive formula of
            // R. Iacono and J.P. Boyd for the last iteration, to avoid catastrophic cancellation.
            if (c == uint256(0)) return w;
            int256 t = w | 1;
            /// @solidity memory-safe-assembly
            assembly {
                x := sdiv(mul(x, wad), t)
            }
            x = (t * (wad + lnWad(x)));
            /// @solidity memory-safe-assembly
            assembly {
                w := sdiv(x, add(wad, t))
            }
        }
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  GENERAL NUMBER UTILITIES                  */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Calculates `floor(x * y / d)` with full precision.
    /// Throws if result overflows a uint256 or when `d` is zero.
    /// Credit to Remco Bloemen under MIT license: https://2π.com/21/muldiv
    function fullMulDiv(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            // 512-bit multiply `[p1 p0] = x * y`.
            // Compute the product mod `2**256` and mod `2**256 - 1`
            // then use the Chinese Remainder Theorem to reconstruct
            // the 512 bit result. The result is stored in two 256
            // variables such that `product = p1 * 2**256 + p0`.

            // Temporarily use `result` as `p0` to save gas.
            result := mul(x, y) // Lower 256 bits of `x * y`.
            for {} 1 {} {
                // If overflows.
                if iszero(mul(or(iszero(x), eq(div(result, x), y)), d)) {
                    let mm := mulmod(x, y, not(0))
                    let p1 := sub(mm, add(result, lt(mm, result))) // Upper 256 bits of `x * y`.

                    /*------------------- 512 by 256 division --------------------*/

                    // Make division exact by subtracting the remainder from `[p1 p0]`.
                    let r := mulmod(x, y, d) // Compute remainder using mulmod.
                    let t := and(d, sub(0, d)) // The least significant bit of `d`. `t >= 1`.
                    // Make sure the result is less than `2**256`. Also prevents `d == 0`.
                    // Placing the check here seems to give more optimal stack operations.
                    if iszero(gt(d, p1)) {
                        mstore(0x00, 0xae47f702) // `FullMulDivFailed()`.
                        revert(0x1c, 0x04)
                    }
                    d := div(d, t) // Divide `d` by `t`, which is a power of two.
                    // Invert `d mod 2**256`
                    // Now that `d` is an odd number, it has an inverse
                    // modulo `2**256` such that `d * inv = 1 mod 2**256`.
                    // Compute the inverse by starting with a seed that is correct
                    // correct for four bits. That is, `d * inv = 1 mod 2**4`.
                    let inv := xor(2, mul(3, d))
                    // Now use Newton-Raphson iteration to improve the precision.
                    // Thanks to Hensel's lifting lemma, this also works in modular
                    // arithmetic, doubling the correct bits in each step.
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**8
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**16
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**32
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**64
                    inv := mul(inv, sub(2, mul(d, inv))) // inverse mod 2**128
                    result :=
                        mul(
                            // Divide [p1 p0] by the factors of two.
                            // Shift in bits from `p1` into `p0`. For this we need
                            // to flip `t` such that it is `2**256 / t`.
                            or(
                                mul(sub(p1, gt(r, result)), add(div(sub(0, t), t), 1)),
                                div(sub(result, r), t)
                            ),
                            mul(sub(2, mul(d, inv)), inv) // inverse mod 2**256
                        )
                    break
                }
                result := div(result, d)
                break
            }
        }
    }

    /// @dev Calculates `floor(x * y / d)` with full precision.
    /// Behavior is undefined if `d` is zero or the final result cannot fit in 256 bits.
    /// Performs the full 512 bit calculation regardless.
    function fullMulDivUnchecked(uint256 x, uint256 y, uint256 d)
        internal
        pure
        returns (uint256 result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            result := mul(x, y)
            let mm := mulmod(x, y, not(0))
            let p1 := sub(mm, add(result, lt(mm, result)))
            let t := and(d, sub(0, d))
            let r := mulmod(x, y, d)
            d := div(d, t)
            let inv := xor(2, mul(3, d))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            inv := mul(inv, sub(2, mul(d, inv)))
            result :=
                mul(
                    or(mul(sub(p1, gt(r, result)), add(div(sub(0, t), t), 1)), div(sub(result, r), t)),
                    mul(sub(2, mul(d, inv)), inv)
                )
        }
    }

    /// @dev Calculates `floor(x * y / d)` with full precision, rounded up.
    /// Throws if result overflows a uint256 or when `d` is zero.
    /// Credit to Uniswap-v3-core under MIT license:
    /// https://github.com/Uniswap/v3-core/blob/main/contracts/libraries/FullMath.sol
    function fullMulDivUp(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 result) {
        result = fullMulDiv(x, y, d);
        /// @solidity memory-safe-assembly
        assembly {
            if mulmod(x, y, d) {
                result := add(result, 1)
                if iszero(result) {
                    mstore(0x00, 0xae47f702) // `FullMulDivFailed()`.
                    revert(0x1c, 0x04)
                }
            }
        }
    }

    /// @dev Returns `floor(x * y / d)`.
    /// Reverts if `x * y` overflows, or `d` is zero.
    function mulDiv(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require(d != 0 && (y == 0 || x <= type(uint256).max / y))`.
            if iszero(mul(or(iszero(x), eq(div(z, x), y)), d)) {
                mstore(0x00, 0xad251c27) // `MulDivFailed()`.
                revert(0x1c, 0x04)
            }
            z := div(z, d)
        }
    }

    /// @dev Returns `ceil(x * y / d)`.
    /// Reverts if `x * y` overflows, or `d` is zero.
    function mulDivUp(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(x, y)
            // Equivalent to `require(d != 0 && (y == 0 || x <= type(uint256).max / y))`.
            if iszero(mul(or(iszero(x), eq(div(z, x), y)), d)) {
                mstore(0x00, 0xad251c27) // `MulDivFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(z, d))), div(z, d))
        }
    }

    /// @dev Returns `ceil(x / d)`.
    /// Reverts if `d` is zero.
    function divUp(uint256 x, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(d) {
                mstore(0x00, 0x65244e4e) // `DivFailed()`.
                revert(0x1c, 0x04)
            }
            z := add(iszero(iszero(mod(x, d))), div(x, d))
        }
    }

    /// @dev Returns `max(0, x - y)`.
    function zeroFloorSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(gt(x, y), sub(x, y))
        }
    }

    /// @dev Returns `condition ? x : y`, without branching.
    function ternary(bool condition, uint256 x, uint256 y) internal pure returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := xor(x, mul(xor(x, y), iszero(condition)))
        }
    }

    /// @dev Exponentiate `x` to `y` by squaring, denominated in base `b`.
    /// Reverts if the computation overflows.
    function rpow(uint256 x, uint256 y, uint256 b) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mul(b, iszero(y)) // `0 ** 0 = 1`. Otherwise, `0 ** n = 0`.
            if x {
                z := xor(b, mul(xor(b, x), and(y, 1))) // `z = isEven(y) ? scale : x`
                let half := shr(1, b) // Divide `b` by 2.
                // Divide `y` by 2 every iteration.
                for { y := shr(1, y) } y { y := shr(1, y) } {
                    let xx := mul(x, x) // Store x squared.
                    let xxRound := add(xx, half) // Round to the nearest number.
                    // Revert if `xx + half` overflowed, or if `x ** 2` overflows.
                    if or(lt(xxRound, xx), shr(128, x)) {
                        mstore(0x00, 0x49f7642b) // `RPowOverflow()`.
                        revert(0x1c, 0x04)
                    }
                    x := div(xxRound, b) // Set `x` to scaled `xxRound`.
                    // If `y` is odd:
                    if and(y, 1) {
                        let zx := mul(z, x) // Compute `z * x`.
                        let zxRound := add(zx, half) // Round to the nearest number.
                        // If `z * x` overflowed or `zx + half` overflowed:
                        if or(xor(div(zx, x), z), lt(zxRound, zx)) {
                            // Revert if `x` is non-zero.
                            if x {
                                mstore(0x00, 0x49f7642b) // `RPowOverflow()`.
                                revert(0x1c, 0x04)
                            }
                        }
                        z := div(zxRound, b) // Return properly scaled `zxRound`.
                    }
                }
            }
        }
    }

    /// @dev Returns the square root of `x`, rounded down.
    function sqrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            // `floor(sqrt(2**15)) = 181`. `sqrt(2**15) - 181 = 2.84`.
            z := 181 // The "correct" value is 1, but this saves a multiplication later.

            // This segment is to get a reasonable initial estimate for the Babylonian method. With a bad
            // start, the correct # of bits increases ~linearly each iteration instead of ~quadratically.

            // Let `y = x / 2**r`. We check `y >= 2**(k + 8)`
            // but shift right by `k` bits to ensure that if `x >= 256`, then `y >= 256`.
            let r := shl(7, lt(0xffffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffffff, shr(r, x))))
            z := shl(shr(1, r), z)

            // Goal was to get `z*z*y` within a small factor of `x`. More iterations could
            // get y in a tighter range. Currently, we will have y in `[256, 256*(2**16))`.
            // We ensured `y >= 256` so that the relative difference between `y` and `y+1` is small.
            // That's not possible if `x < 256` but we can just verify those cases exhaustively.

            // Now, `z*z*y <= x < z*z*(y+1)`, and `y <= 2**(16+8)`, and either `y >= 256`, or `x < 256`.
            // Correctness can be checked exhaustively for `x < 256`, so we assume `y >= 256`.
            // Then `z*sqrt(y)` is within `sqrt(257)/sqrt(256)` of `sqrt(x)`, or about 20bps.

            // For `s` in the range `[1/256, 256]`, the estimate `f(s) = (181/1024) * (s+1)`
            // is in the range `(1/2.84 * sqrt(s), 2.84 * sqrt(s))`,
            // with largest error when `s = 1` and when `s = 256` or `1/256`.

            // Since `y` is in `[256, 256*(2**16))`, let `a = y/65536`, so that `a` is in `[1/256, 256)`.
            // Then we can estimate `sqrt(y)` using
            // `sqrt(65536) * 181/1024 * (a + 1) = 181/4 * (y + 65536)/65536 = 181 * (y + 65536)/2**18`.

            // There is no overflow risk here since `y < 2**136` after the first branch above.
            z := shr(18, mul(z, add(shr(r, x), 65536))) // A `mul()` is saved from starting `z` at 181.

            // Given the worst case multiplicative error of 2.84 above, 7 iterations should be enough.
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))
            z := shr(1, add(z, div(x, z)))

            // If `x+1` is a perfect square, the Babylonian method cycles between
            // `floor(sqrt(x))` and `ceil(sqrt(x))`. This statement ensures we return floor.
            // See: https://en.wikipedia.org/wiki/Integer_square_root#Using_only_integer_division
            z := sub(z, lt(div(x, z), z))
        }
    }

    /// @dev Returns the cube root of `x`, rounded down.
    /// Credit to bout3fiddy and pcaversaccio under AGPLv3 license:
    /// https://github.com/pcaversaccio/snekmate/blob/main/src/utils/Math.vy
    /// Formally verified by xuwinnie:
    /// https://github.com/vectorized/solady/blob/main/audits/xuwinnie-solady-cbrt-proof.pdf
    function cbrt(uint256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            let r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // Makeshift lookup table to nudge the approximate log2 result.
            z := div(shl(div(r, 3), shl(lt(0xf, shr(r, x)), 0xf)), xor(7, mod(r, 3)))
            // Newton-Raphson's.
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            z := div(add(add(div(x, mul(z, z)), z), z), 3)
            // Round down.
            z := sub(z, lt(div(x, mul(z, z)), z))
        }
    }

    /// @dev Returns the square root of `x`, denominated in `WAD`, rounded down.
    function sqrtWad(uint256 x) internal pure returns (uint256 z) {
        unchecked {
            if (x <= type(uint256).max / 10 ** 18) return sqrt(x * 10 ** 18);
            z = (1 + sqrt(x)) * 10 ** 9;
            z = (fullMulDivUnchecked(x, 10 ** 18, z) + z) >> 1;
        }
        /// @solidity memory-safe-assembly
        assembly {
            z := sub(z, gt(999999999999999999, sub(mulmod(z, z, x), 1))) // Round down.
        }
    }

    /// @dev Returns the cube root of `x`, denominated in `WAD`, rounded down.
    /// Formally verified by xuwinnie:
    /// https://github.com/vectorized/solady/blob/main/audits/xuwinnie-solady-cbrt-proof.pdf
    function cbrtWad(uint256 x) internal pure returns (uint256 z) {
        unchecked {
            if (x <= type(uint256).max / 10 ** 36) return cbrt(x * 10 ** 36);
            z = (1 + cbrt(x)) * 10 ** 12;
            z = (fullMulDivUnchecked(x, 10 ** 36, z * z) + z + z) / 3;
        }
        /// @solidity memory-safe-assembly
        assembly {
            let p := x
            for {} 1 {} {
                if iszero(shr(229, p)) {
                    if iszero(shr(199, p)) {
                        p := mul(p, 100000000000000000) // 10 ** 17.
                        break
                    }
                    p := mul(p, 100000000) // 10 ** 8.
                    break
                }
                if iszero(shr(249, p)) { p := mul(p, 100) }
                break
            }
            let t := mulmod(mul(z, z), z, p)
            z := sub(z, gt(lt(t, shr(1, p)), iszero(t))) // Round down.
        }
    }

    /// @dev Returns the factorial of `x`.
    function factorial(uint256 x) internal pure returns (uint256 result) {
        /// @solidity memory-safe-assembly
        assembly {
            result := 1
            if iszero(lt(x, 58)) {
                mstore(0x00, 0xaba0f2a2) // `FactorialOverflow()`.
                revert(0x1c, 0x04)
            }
            for {} x { x := sub(x, 1) } { result := mul(result, x) }
        }
    }

    /// @dev Returns the log2 of `x`.
    /// Equivalent to computing the index of the most significant bit (MSB) of `x`.
    /// Returns 0 if `x` is zero.
    function log2(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(r, shl(3, lt(0xff, shr(r, x))))
            // forgefmt: disable-next-item
            r := or(r, byte(and(0x1f, shr(shr(r, x), 0x8421084210842108cc6318c6db6d54be)),
                0x0706060506020504060203020504030106050205030304010505030400000000))
        }
    }

    /// @dev Returns the log2 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log2Up(uint256 x) internal pure returns (uint256 r) {
        r = log2(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(shl(r, 1), x))
        }
    }

    /// @dev Returns the log10 of `x`.
    /// Returns 0 if `x` is zero.
    function log10(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            if iszero(lt(x, 100000000000000000000000000000000000000)) {
                x := div(x, 100000000000000000000000000000000000000)
                r := 38
            }
            if iszero(lt(x, 100000000000000000000)) {
                x := div(x, 100000000000000000000)
                r := add(r, 20)
            }
            if iszero(lt(x, 10000000000)) {
                x := div(x, 10000000000)
                r := add(r, 10)
            }
            if iszero(lt(x, 100000)) {
                x := div(x, 100000)
                r := add(r, 5)
            }
            r := add(r, add(gt(x, 9), add(gt(x, 99), add(gt(x, 999), gt(x, 9999)))))
        }
    }

    /// @dev Returns the log10 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log10Up(uint256 x) internal pure returns (uint256 r) {
        r = log10(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(exp(10, r), x))
        }
    }

    /// @dev Returns the log256 of `x`.
    /// Returns 0 if `x` is zero.
    function log256(uint256 x) internal pure returns (uint256 r) {
        /// @solidity memory-safe-assembly
        assembly {
            r := shl(7, lt(0xffffffffffffffffffffffffffffffff, x))
            r := or(r, shl(6, lt(0xffffffffffffffff, shr(r, x))))
            r := or(r, shl(5, lt(0xffffffff, shr(r, x))))
            r := or(r, shl(4, lt(0xffff, shr(r, x))))
            r := or(shr(3, r), lt(0xff, shr(r, x)))
        }
    }

    /// @dev Returns the log256 of `x`, rounded up.
    /// Returns 0 if `x` is zero.
    function log256Up(uint256 x) internal pure returns (uint256 r) {
        r = log256(x);
        /// @solidity memory-safe-assembly
        assembly {
            r := add(r, lt(shl(shl(3, r), 1), x))
        }
    }

    /// @dev Returns the scientific notation format `mantissa * 10 ** exponent` of `x`.
    /// Useful for compressing prices (e.g. using 25 bit mantissa and 7 bit exponent).
    function sci(uint256 x) internal pure returns (uint256 mantissa, uint256 exponent) {
        /// @solidity memory-safe-assembly
        assembly {
            mantissa := x
            if mantissa {
                if iszero(mod(mantissa, 1000000000000000000000000000000000)) {
                    mantissa := div(mantissa, 1000000000000000000000000000000000)
                    exponent := 33
                }
                if iszero(mod(mantissa, 10000000000000000000)) {
                    mantissa := div(mantissa, 10000000000000000000)
                    exponent := add(exponent, 19)
                }
                if iszero(mod(mantissa, 1000000000000)) {
                    mantissa := div(mantissa, 1000000000000)
                    exponent := add(exponent, 12)
                }
                if iszero(mod(mantissa, 1000000)) {
                    mantissa := div(mantissa, 1000000)
                    exponent := add(exponent, 6)
                }
                if iszero(mod(mantissa, 10000)) {
                    mantissa := div(mantissa, 10000)
                    exponent := add(exponent, 4)
                }
                if iszero(mod(mantissa, 100)) {
                    mantissa := div(mantissa, 100)
                    exponent := add(exponent, 2)
                }
                if iszero(mod(mantissa, 10)) {
                    mantissa := div(mantissa, 10)
                    exponent := add(exponent, 1)
                }
            }
        }
    }

    /// @dev Convenience function for packing `x` into a smaller number using `sci`.
    /// The `mantissa` will be in bits [7..255] (the upper 249 bits).
    /// The `exponent` will be in bits [0..6] (the lower 7 bits).
    /// Use `SafeCastLib` to safely ensure that the `packed` number is small
    /// enough to fit in the desired unsigned integer type:
    /// ```
    ///     uint32 packed = SafeCastLib.toUint32(FixedPointMathLib.packSci(777 ether));
    /// ```
    function packSci(uint256 x) internal pure returns (uint256 packed) {
        (x, packed) = sci(x); // Reuse for `mantissa` and `exponent`.
        /// @solidity memory-safe-assembly
        assembly {
            if shr(249, x) {
                mstore(0x00, 0xce30380c) // `MantissaOverflow()`.
                revert(0x1c, 0x04)
            }
            packed := or(shl(7, x), packed)
        }
    }

    /// @dev Convenience function for unpacking a packed number from `packSci`.
    function unpackSci(uint256 packed) internal pure returns (uint256 unpacked) {
        unchecked {
            unpacked = (packed >> 7) * 10 ** (packed & 0x7f);
        }
    }

    /// @dev Returns the average of `x` and `y`. Rounds towards zero.
    function avg(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = (x & y) + ((x ^ y) >> 1);
        }
    }

    /// @dev Returns the average of `x` and `y`. Rounds towards negative infinity.
    function avg(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = (x >> 1) + (y >> 1) + (x & y & 1);
        }
    }

    /// @dev Returns the absolute value of `x`.
    function abs(int256 x) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(sar(255, x), add(sar(255, x), x))
        }
    }

    /// @dev Returns the absolute distance between `x` and `y`.
    function dist(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(mul(xor(sub(y, x), sub(x, y)), gt(x, y)), sub(y, x))
        }
    }

    /// @dev Returns the absolute distance between `x` and `y`.
    function dist(int256 x, int256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(mul(xor(sub(y, x), sub(x, y)), sgt(x, y)), sub(y, x))
        }
    }

    /// @dev Returns the minimum of `x` and `y`.
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), lt(y, x)))
        }
    }

    /// @dev Returns the minimum of `x` and `y`.
    function min(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), slt(y, x)))
        }
    }

    /// @dev Returns the maximum of `x` and `y`.
    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), gt(y, x)))
        }
    }

    /// @dev Returns the maximum of `x` and `y`.
    function max(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, y), sgt(y, x)))
        }
    }

    /// @dev Returns `x`, bounded to `minValue` and `maxValue`.
    function clamp(uint256 x, uint256 minValue, uint256 maxValue)
        internal
        pure
        returns (uint256 z)
    {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, minValue), gt(minValue, x)))
            z := xor(z, mul(xor(z, maxValue), lt(maxValue, z)))
        }
    }

    /// @dev Returns `x`, bounded to `minValue` and `maxValue`.
    function clamp(int256 x, int256 minValue, int256 maxValue) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := xor(x, mul(xor(x, minValue), sgt(minValue, x)))
            z := xor(z, mul(xor(z, maxValue), slt(maxValue, z)))
        }
    }

    /// @dev Returns greatest common divisor of `x` and `y`.
    function gcd(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            for { z := x } y {} {
                let t := y
                y := mod(z, y)
                z := t
            }
        }
    }

    /// @dev Returns `a + (b - a) * (t - begin) / (end - begin)`,
    /// with `t` clamped between `begin` and `end` (inclusive).
    /// Agnostic to the order of (`a`, `b`) and (`end`, `begin`).
    /// If `begins == end`, returns `t <= begin ? a : b`.
    function lerp(uint256 a, uint256 b, uint256 t, uint256 begin, uint256 end)
        internal
        pure
        returns (uint256)
    {
        if (begin > end) {
            t = ~t;
            begin = ~begin;
            end = ~end;
        }
        if (t <= begin) return a;
        if (t >= end) return b;
        unchecked {
            if (b >= a) return a + fullMulDiv(b - a, t - begin, end - begin);
            return a - fullMulDiv(a - b, t - begin, end - begin);
        }
    }

    /// @dev Returns `a + (b - a) * (t - begin) / (end - begin)`.
    /// with `t` clamped between `begin` and `end` (inclusive).
    /// Agnostic to the order of (`a`, `b`) and (`end`, `begin`).
    /// If `begins == end`, returns `t <= begin ? a : b`.
    function lerp(int256 a, int256 b, int256 t, int256 begin, int256 end)
        internal
        pure
        returns (int256)
    {
        if (begin > end) {
            t = int256(~uint256(t));
            begin = int256(~uint256(begin));
            end = int256(~uint256(end));
        }
        if (t <= begin) return a;
        if (t >= end) return b;
        // forgefmt: disable-next-item
        unchecked {
            if (b >= a) return int256(uint256(a) + fullMulDiv(uint256(b) - uint256(a),
                uint256(t) - uint256(begin), uint256(end) - uint256(begin)));
            return int256(uint256(a) - fullMulDiv(uint256(a) - uint256(b),
                uint256(t) - uint256(begin), uint256(end) - uint256(begin)));
        }
    }

    /// @dev Returns if `x` is an even number. Some people may need this.
    function isEven(uint256 x) internal pure returns (bool) {
        return x & uint256(1) == uint256(0);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   RAW NUMBER OPERATIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @dev Returns `x + y`, without checking for overflow.
    function rawAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x + y;
        }
    }

    /// @dev Returns `x + y`, without checking for overflow.
    function rawAdd(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x + y;
        }
    }

    /// @dev Returns `x - y`, without checking for underflow.
    function rawSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x - y;
        }
    }

    /// @dev Returns `x - y`, without checking for underflow.
    function rawSub(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x - y;
        }
    }

    /// @dev Returns `x * y`, without checking for overflow.
    function rawMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            z = x * y;
        }
    }

    /// @dev Returns `x * y`, without checking for overflow.
    function rawMul(int256 x, int256 y) internal pure returns (int256 z) {
        unchecked {
            z = x * y;
        }
    }

    /// @dev Returns `x / y`, returning 0 if `y` is zero.
    function rawDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := div(x, y)
        }
    }

    /// @dev Returns `x / y`, returning 0 if `y` is zero.
    function rawSDiv(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := sdiv(x, y)
        }
    }

    /// @dev Returns `x % y`, returning 0 if `y` is zero.
    function rawMod(uint256 x, uint256 y) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mod(x, y)
        }
    }

    /// @dev Returns `x % y`, returning 0 if `y` is zero.
    function rawSMod(int256 x, int256 y) internal pure returns (int256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := smod(x, y)
        }
    }

    /// @dev Returns `(x + y) % d`, return 0 if `d` if zero.
    function rawAddMod(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := addmod(x, y, d)
        }
    }

    /// @dev Returns `(x * y) % d`, return 0 if `d` if zero.
    function rawMulMod(uint256 x, uint256 y, uint256 d) internal pure returns (uint256 z) {
        /// @solidity memory-safe-assembly
        assembly {
            z := mulmod(x, y, d)
        }
    }
}

// src/constants.sol

uint256 constant YEAR = 365 * 86400; 
uint256 constant LENDER_REWARD_RATE = 30_000;
uint256 constant BORROWER_REWARD_RATE = 60_000;
uint256 constant TOTAL_RATE = 100_000;

// src/interfaces/IInvestmentModule.sol

interface IInvestmentModule {

    function getCurrentAPR(address lendingPool, address token) external returns(uint256); 
    
    function invest(address lendingPool, address token, uint256 amount) external returns(uint256);
    function withdraw(address lendingPool, address token, uint256 amount) external returns(uint256);

    function claim(address lendingPool, address token) external returns(uint256);  
}

// src/interfaces/IRewardModule.sol

interface IRewardModule {
    function getInvestToken() external returns(address);
    function getRewardToken() external returns(address);
    function getCurrentAPR() external view returns(uint256);

    function deposit(uint256 amount) external returns(uint256 rewards);
    function withdraw(uint256 amount) external returns(uint256 rewards);
    function claimReward() external returns(uint256 rewards);
}

// src/libraries/Events.sol

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

// src/oracle/DIAOracleV2Multiupdate.sol

contract DIAOracleV2 {
    mapping (string => uint256) public values;
    address oracleUpdater;
    
    event OracleUpdate(string key, uint128 value, uint128 timestamp);
    event UpdaterAddressChange(address newUpdater);
    
    constructor() {
        oracleUpdater = msg.sender;
    }
    
    function setValue(string memory key, uint128 value, uint128 timestamp) public {
        require(msg.sender == oracleUpdater);
        uint256 cValue = (((uint256)(value)) << 128) + timestamp;
        values[key] = cValue;
        emit OracleUpdate(key, value, timestamp);
    }

    function setMultipleValues(string[] memory keys, uint256[] memory compressedValues) public {
        require(msg.sender == oracleUpdater);
        require(keys.length == compressedValues.length);
        
        for (uint128 i = 0; i < keys.length; i++) {
            string memory currentKey = keys[i];
            uint256 currentCvalue = compressedValues[i];
            uint128 value = (uint128)(currentCvalue >> 128);
            uint128 timestamp = (uint128)(currentCvalue % 2**128);

            values[currentKey] = currentCvalue;
            emit OracleUpdate(currentKey, value, timestamp);
        }
    }
    
    function getValue(string memory key) external view returns (uint128, uint128) {
        uint256 cValue = values[key];
        uint128 timestamp = (uint128)(cValue % 2**128);
        uint128 value = (uint128)(cValue >> 128);
        return (value, timestamp);
    }
    
    function updateOracleUpdaterAddress(address newOracleUpdaterAddress) public {
        require(msg.sender == oracleUpdater);
        oracleUpdater = newOracleUpdaterAddress;
        emit UpdaterAddressChange(newOracleUpdaterAddress);
    }
}

// lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC165.sol)

// lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC20.sol)

// lib/openzeppelin-contracts/contracts/utils/Address.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert Errors.FailedCall();
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {Errors.FailedCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {Errors.FailedCall}) in case
     * of an unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {Errors.FailedCall} error.
     */
    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {Errors.FailedCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            assembly ("memory-safe") {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert Errors.FailedCall();
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/Pausable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Pausable.sol)

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    bool private _paused;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    /**
     * @dev The operation failed because the contract is paused.
     */
    error EnforcedPause();

    /**
     * @dev The operation failed because the contract is not paused.
     */
    error ExpectedPause();

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        if (paused()) {
            revert EnforcedPause();
        }
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        if (!paused()) {
            revert ExpectedPause();
        }
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC-165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// lib/openzeppelin-contracts/contracts/access/AccessControl.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/AccessControl.sol)

/**
 * @dev Contract module that allows children to implement role-based access
 * control mechanisms. This is a lightweight version that doesn't allow enumerating role
 * members except through off-chain means by accessing the contract event logs. Some
 * applications may benefit from on-chain enumerability, for those cases see
 * {AccessControlEnumerable}.
 *
 * Roles are referred to by their `bytes32` identifier. These should be exposed
 * in the external API and be unique. The best way to achieve this is by
 * using `public constant` hash digests:
 *
 * ```solidity
 * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
 * ```
 *
 * Roles can be used to represent a set of permissions. To restrict access to a
 * function call, use {hasRole}:
 *
 * ```solidity
 * function foo() public {
 *     require(hasRole(MY_ROLE, msg.sender));
 *     ...
 * }
 * ```
 *
 * Roles can be granted and revoked dynamically via the {grantRole} and
 * {revokeRole} functions. Each role has an associated admin role, and only
 * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
 *
 * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
 * that only accounts with this role will be able to grant or revoke other
 * roles. More complex role relationships can be created by using
 * {_setRoleAdmin}.
 *
 * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
 * grant and revoke this role. Extra precautions should be taken to secure
 * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
 * to enforce additional security measures for this role.
 */
abstract contract AccessControl is Context, IAccessControl, ERC165 {
    struct RoleData {
        mapping(address account => bool) hasRole;
        bytes32 adminRole;
    }

    mapping(bytes32 role => RoleData) private _roles;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with an {AccessControlUnauthorizedAccount} error including the required role.
     */
    modifier onlyRole(bytes32 role) {
        _checkRole(role);
        _;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(bytes32 role, address account) public view virtual returns (bool) {
        return _roles[role].hasRole[account];
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `_msgSender()`
     * is missing `role`. Overriding this function changes the behavior of the {onlyRole} modifier.
     */
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, _msgSender());
    }

    /**
     * @dev Reverts with an {AccessControlUnauthorizedAccount} error if `account`
     * is missing `role`.
     */
    function _checkRole(bytes32 role, address account) internal view virtual {
        if (!hasRole(role, account)) {
            revert AccessControlUnauthorizedAccount(account, role);
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) public view virtual returns (bytes32) {
        return _roles[role].adminRole;
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleGranted} event.
     */
    function grantRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     *
     * May emit a {RoleRevoked} event.
     */
    function revokeRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account);
    }

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     *
     * May emit a {RoleRevoked} event.
     */
    function renounceRole(bytes32 role, address callerConfirmation) public virtual {
        if (callerConfirmation != _msgSender()) {
            revert AccessControlBadConfirmation();
        }

        _revokeRole(role, callerConfirmation);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 previousAdminRole = getRoleAdmin(role);
        _roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Attempts to grant `role` to `account` and returns a boolean indicating if `role` was granted.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleGranted} event.
     */
    function _grantRole(bytes32 role, address account) internal virtual returns (bool) {
        if (!hasRole(role, account)) {
            _roles[role].hasRole[account] = true;
            emit RoleGranted(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Attempts to revoke `role` to `account` and returns a boolean indicating if `role` was revoked.
     *
     * Internal function without access restriction.
     *
     * May emit a {RoleRevoked} event.
     */
    function _revokeRole(bytes32 role, address account) internal virtual returns (bool) {
        if (hasRole(role, account)) {
            _roles[role].hasRole[account] = false;
            emit RoleRevoked(role, account, _msgSender());
            return true;
        } else {
            return false;
        }
    }
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC1363.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC1363.sol)

/**
 * @title IERC1363
 * @dev Interface of the ERC-1363 standard as defined in the https://eips.ethereum.org/EIPS/eip-1363[ERC-1363].
 *
 * Defines an extension interface for ERC-20 tokens that supports executing code on a recipient contract
 * after `transfer` or `transferFrom`, or code on a spender contract after `approve`, in a single transaction.
 */
interface IERC1363 is IERC20, IERC165 {
    /*
     * Note: the ERC-165 identifier for this interface is 0xb0202a11.
     * 0xb0202a11 ===
     *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
     *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
     *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
     *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
     */

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
     * and then calls {IERC1363Receiver-onTransferReceived} on `to`.
     * @param from The address which you want to send tokens from.
     * @param to The address which you want to transfer to.
     * @param value The amount of tokens to be transferred.
     * @param data Additional data with no specified format, sent in call to `to`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value) external returns (bool);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens and then calls {IERC1363Spender-onApprovalReceived} on `spender`.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     * @param data Additional data with no specified format, sent in call to `spender`.
     * @return A boolean value indicating whether the operation succeeded unless throwing.
     */
    function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
}

// src/LendingPoolState.sol

struct PoolInfo {
    address poolAddress;
    address principalToken;
    // address[] collateralTokens;
    uint256 totalDeposits;
    uint256 totalBorrows;
    uint256 totalEarnings;
    uint256 totalCollaterals;
    uint256 utilizationRate;
    uint256 borrowAPR;
    uint256 earnAPR;
}

struct CollateralData {
    address token;
    uint256 totalSupply;
    uint256 oraclePrice;
}

struct CollateralsData {
    CollateralData[] tokenData;
    uint256 loanToValue;
    uint256 liquidationThreshold;
    uint256 liquidationBonus;
}

struct PositionCollateral {
    address token;
    uint256 amount;
    uint256 rewards;
    uint256 value; 
}
struct UserCollateralData {
    PositionCollateral[] collaterals;
    uint256 totalValue;
}

struct UserCreditPositionData {
    address poolAddress;
    address tokenAddress;
    uint256 liquidityAmount;
    uint256 liquidityValue;
    uint256 cashAmount;
    uint256 cashValue;
    uint256 earnedAmount;
    uint256 earnedValue;
}

struct UserDebtPositionData {
    address poolAddress;
    address tokenAddress;
    uint256 borrowAmount;
    uint256 borrowValue;
    uint256 collateralValue;
    uint256 currentDebtAmount;
    uint256 currentDebtValue;
    uint256 liquidationPoint;
    uint256 borrowCapacity;
    uint256 availableToBorrowAmount;
    uint256 availableToBorrowValue;
    uint256 rewards;
}

struct DebtPositionCollateral {
    uint256 amount;
    uint256 share;
    // uint256 rewardIndex;
    uint256 accruedRewards;
    uint256 lastAPR;
    uint256 lastRewardedAt;
}

struct DebtPosition {
    mapping(address token => DebtPositionCollateral collateral) collaterals;
    uint256 borrowAmount;
    uint256 repaidAmount;
    uint256 debtAmount; 
    uint256 totalBorrow;
}

struct CreditPosition {
    uint256 depositAmount;
    uint256 withdrawAmount;
    uint256 creditAmount;
    uint256 totalDeposit;
    uint256 earnedAmount;
    uint256 earnedValue;
}

struct InvestReserveData {
    uint256 totalDeposits;
    uint256 totalInvested;
    uint256 totalRewards;
    // uint256 rewardIndex;
    uint256 rewardAPR;
    uint256 lastAPRUpdatedAt;
    uint256 shares;
}

struct ReserveData {
    uint256 totalDeposits; // Total Deposits 
    uint256 totalWithdrawals; // Total Accumulated withdrawals
    // mapping (address token => uint256 collateralAmount) totalCollaterals;
    // mapping (address token => uint256 invest) totalInvests;
    mapping (address token => InvestReserveData invest) totalCollaterals;
    uint256 totalBorrows; // Total Accumulated borrows
    uint256 totalRepaid; // Total Accumulated repaid
    uint256 totalInvested;
    uint256 totalRewards;
    // uint256 rewardIndex;
    uint256 rewardAPR;
    uint256 lastAPRUpdatedAt;
    uint256 totalRewardShares;
    uint256 totalCredit; 
}

struct RateData {
    uint256 utilizationRate;
    uint256 borrowRate;
    uint256 liquidityRate;
    uint256 debtIndex;
    uint256 liquidityIndex;
    uint256 lastUpdated;
}

struct TokenInfo {
    bool whitelisted;
    string collateralKey;
}

struct CollateralInfo {
    IERC20 tokenAddress;
    TokenInfo tokenInfo;
}

struct InitialCollateralInfo {
    IERC20 tokenAddress;
    string collateralKey;
}

struct TokenConfig {
    IERC20 principalToken; // USDT
    string principalKey;
    IERC20[] collateralTokens;
    mapping(address token => TokenInfo tokenInfo) collateralsInfo;
    DIAOracleV2 oracle;
    IInvestmentModule investModule;
}

struct RewardConfig {
    // mapping(address token => IRewardModule[] modules) rewardModules;
    mapping(address token => IRewardModule module) rewardModules;
}

struct InitializeTokenConfig {
    IERC20 principalToken; // USDT
    string principalKey;
    DIAOracleV2 oracle; 
    IInvestmentModule investModule;    
    InitialCollateralInfo[] collaterals;    
}

struct FeeConfig {
    uint256 protocolFeeRate; // Protocol fee rate on interest (e.g., 5%)
    address protocolFeeRecipient; // Protocol fee recipient 
}

struct RateConfig {
    uint256 baseRate; // Base rate (e.g., 2%)
    uint256 rateSlope1; // Slope 1 for utilization below optimal rate (e.g., 4%)
    uint256 rateSlope2; // Slope 2 for utilization above optimal rate (e.g., 20%)
    uint256 optimalUtilizationRate; // Optimal utilization rate (e.g., 80%)
    uint256 reserveFactor;
}

struct RiskConfig {
    uint256 loanToValue; // loan to value (e.g., 75%)
    uint256 liquidationThreshold; // Liquidation threshold (e.g., 80%)
    uint256 minimumBorrowToken;
    uint256 borrowTokenCap;    
    uint256 healthFactorForClose; // user’s health factor:  0.95<hf<1, the loan is eligible for a liquidation of 50%. user’s health factor:  hf<=0.95, the loan is eligible for a liquidation of 100%.
    uint256 liquidationBonus;    // Liquidation penalty (e.g., 5%)
}

struct PositionData {
    mapping(address => DebtPosition) debtPositions;
    mapping(address => CreditPosition) creditPositions;
    uint256 totalCredit;
    uint256 totalDebt;
}

struct InitializeParam {
    InitializeTokenConfig tokenConfig;
    FeeConfig feeConfig;
    RiskConfig riskConfig;
    RateConfig rateConfig;
}

struct State {
    TokenConfig tokenConfig;
    FeeConfig feeConfig;
    RiskConfig riskConfig;
    RateConfig rateConfig;
    ReserveData reserveData;
    RewardConfig rewardConfig;
    RateData rateData;
    PositionData positionData;
}

// src/interfaces/ILendingPool.sol

/// @title ILendingPool
/// @author Petro1912 
interface ILendingPool {
    
    function initialize(InitializeParam memory param) external;

    function setTokenRewardModule(address token, IRewardModule module) external;

    function getPoolInfo() external view returns (PoolInfo memory);

    function getLastRewardAPRUpdatedAt(address investToken) external view returns (uint256 lastUpdatedAt);

    // function getRewardIndex(address investToken) external view returns(uint256 rewardIndex);
    // function getRewardModules(address token) external view returns (IRewardModule[] memory);

    function getRewardModule(address token) external view returns (IRewardModule);

    function getInvestmentModule() external view returns (IInvestmentModule);

    function getInvestReserveData(address token) external view returns (uint256 totalDeposits, uint256 totalInvested, uint256 lastRewardedAt);

    function updateInvestReserveData(bool isInvest, address token, uint256 investAmount, uint256 rewards, uint256 rewardAPR) external;
    
    function getLiquidityPositionData(address) external view returns (UserCreditPositionData memory);

    function getDebtPositionData(address) external view returns (UserDebtPositionData memory);
}

// src/libraries/InvestmentLib.sol

library InvestmentLib {

    function getInvestReserveData(State storage state, address token) external view returns (uint256 totalDeposits, uint256 totalInvested, uint256 lastRewardedAt) {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            totalDeposits = state.reserveData.totalDeposits;
            totalInvested = state.reserveData.totalInvested;
            lastRewardedAt = state.reserveData.lastAPRUpdatedAt;
        } else {
            totalDeposits = state.reserveData.totalCollaterals[token].totalDeposits;
            totalInvested = state.reserveData.totalCollaterals[token].totalInvested;
            lastRewardedAt = state.reserveData.totalCollaterals[token].lastAPRUpdatedAt;
        }
    }

    // function getRewardIndex(State storage state, address token) external view returns (uint256 rewardIndex) {
    //     bool isPrincipal = token == address(state.tokenConfig.principalToken);
    //     if (isPrincipal) {
    //         rewardIndex = state.reserveData.rewardIndex;
    //     } else {
    //         rewardIndex = state.reserveData.totalCollaterals[token].rewardIndex;
    //     }
    // }

    function getLastRewardAPRUpdatedAt(State storage state, address token) external view returns (uint256 lastUpdatedAt) {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        if (isPrincipal) {
            lastUpdatedAt = state.reserveData.lastAPRUpdatedAt;
        } else {
            lastUpdatedAt = state.reserveData.totalCollaterals[token].lastAPRUpdatedAt;
        }
    }
    
    function updateInvestReserveData(
        State storage state,
        bool isInvest, 
        address token, 
        uint256 investAmount, 
        uint256 rewards, 
        uint256 rewardAPR
    ) external {
        bool isPrincipal = token == address(state.tokenConfig.principalToken);
        uint256 lastUpdatedAt = isPrincipal ? 
            state.reserveData.lastAPRUpdatedAt : 
            state.reserveData.totalCollaterals[token].lastAPRUpdatedAt;

        bool isUpdated = lastUpdatedAt != block.timestamp;

        if (isPrincipal) {
            ReserveData storage reserveData = state.reserveData;
            if (investAmount != 0) {
                if (isInvest) {
                    reserveData.totalInvested += investAmount;
                } else {
                    reserveData.totalInvested -= investAmount;
                }
            }

            reserveData.totalRewards += rewards;
            if (isUpdated) {
                reserveData.rewardAPR = rewardAPR;
                reserveData.lastAPRUpdatedAt = block.timestamp;
            }
        } else {
            InvestReserveData storage investData = state.reserveData.totalCollaterals[token];
            if (investAmount != 0) {
                if (isInvest) {
                    investData.totalInvested += investAmount;
                } else {
                    investData.totalInvested -= investAmount;
                }
            }
            
            investData.totalRewards += rewards;
            if (isUpdated) {
                investData.rewardAPR = rewardAPR;
                investData.lastAPRUpdatedAt = block.timestamp;
            }
        }
    }
}

// src/libraries/InitializeAction.sol

library InitializeAction {

    function addCollateralTokens(
        State storage state, 
        InitialCollateralInfo[] memory _collateralsInfo
    ) external {
        uint256 tokenCount = _collateralsInfo.length;
        for (uint256 i = 0; i < tokenCount; ) {
            _addCollateralToken(state, _collateralsInfo[i]);
            unchecked {
                ++i;
            }
        }
    }    

    function _addCollateralToken(
        State storage state, 
        InitialCollateralInfo memory _collateralInfo
    ) internal {
        address collateralToken = address(_collateralInfo.tokenAddress);
        require(collateralToken != address(0), "WrongAddress");

        state.tokenConfig.collateralTokens.push(_collateralInfo.tokenAddress);
        state.tokenConfig.collateralsInfo[collateralToken].whitelisted = true;
        state.tokenConfig.collateralsInfo[collateralToken].collateralKey = _collateralInfo.collateralKey;
    }

    function setLoanToValue(
        State storage state, 
        uint256 _loanToValue
    ) external {
        require(_loanToValue > 0 && _loanToValue <= 1e18, "InvalidValue");
        state.riskConfig.loanToValue = _loanToValue;
        emit Events.LoanToValueUpdated(_loanToValue);
    }

    function setLiquidationThreshold(
        State storage state, 
        uint256 _liquidationThreshold
    ) external {
        require(_liquidationThreshold > state.riskConfig.loanToValue && _liquidationThreshold <= 1e18, "InvalidValue");
        state.riskConfig.liquidationThreshold = _liquidationThreshold;
        emit Events.LiquidationThresholdUpdated(_liquidationThreshold);
    }

    function setHealthFactorForClose(
        State storage state, 
        uint256 _healthFactorForClose
    ) external {
        require(_healthFactorForClose > 0 && _healthFactorForClose <= 1e18, "InvalidValue");
        state.riskConfig.healthFactorForClose = _healthFactorForClose;
        emit Events.HealthFactorForCloseUpdated(_healthFactorForClose);
    }    

    function setLiquidationBonus(
        State storage state, 
        uint256 _liquidationBonus
    ) external {
        require(_liquidationBonus > 0 && _liquidationBonus <= 1e18, "InvalidValue");
        state.riskConfig.liquidationBonus = _liquidationBonus;
        emit Events.LiquidationBonusUpdated(_liquidationBonus);
    }

    function setProtocolFeeRate(
        State storage state, 
        uint256 _protocolFeeRate
    ) external {
        require(_protocolFeeRate > 0 && _protocolFeeRate <= 1e18, "InvalidValue");
        state.feeConfig.protocolFeeRate = _protocolFeeRate;
        emit Events.ProtocolFeeRateUpdated(_protocolFeeRate);
    }

    function setProtocolFeeRecipient(
        State storage state, 
        address _protocolFeeRecipient
    ) external {
        require(_protocolFeeRecipient != address(0), "WrongAddress");
        state.feeConfig.protocolFeeRecipient = _protocolFeeRecipient;
        emit Events.ProtocolFeeRecipientUpdated(_protocolFeeRecipient);
    }

    function setBorrowTokenCap(
        State storage state, 
        uint256 _borrowTokenCap
    ) external {
        require(_borrowTokenCap > 0, "InvalidValue");
        state.riskConfig.borrowTokenCap = _borrowTokenCap;
        emit Events.BorrowTokenCapUpdated(_borrowTokenCap);
    }

    function setMinimuBorrowToken(
        State storage state,
        uint256 _minBorrowToken
    ) external {
        require(_minBorrowToken > 0, "InvalidValue");
        state.riskConfig.minimumBorrowToken = _minBorrowToken;
        emit Events.MinimumBorrowTokenUpdated(_minBorrowToken);
    }

    function setInterestRateConfig(        
        State storage state, 
        RateConfig memory _rateConfig
    ) external {
        RateConfig storage rateConfig = state.rateConfig;

        rateConfig.baseRate = _rateConfig.baseRate;
        rateConfig.rateSlope1 = _rateConfig.rateSlope1;
        rateConfig.rateSlope2 = _rateConfig.rateSlope2;
        rateConfig.reserveFactor = _rateConfig.reserveFactor;
        rateConfig.optimalUtilizationRate = _rateConfig.optimalUtilizationRate;
    }

    // function setTokenRewardModules(
    //     State storage state,
    //     address token,
    //     IRewardModule[] memory modules
    // ) external {
    //     require(token == address(state.tokenConfig.principalToken) || state.tokenConfig.collateralsInfo[token].whitelisted, "InvalidToken");
    //     require(modules.length > 0, "WrongRewardConfig");
    //     state.rewardConfig.rewardModules[token] = modules;        
    // }

    function setTokenRewardModule(
        State storage state,
        address token,
        IRewardModule module
    ) external {
        require(token == address(state.tokenConfig.principalToken) || state.tokenConfig.collateralsInfo[token].whitelisted, "InvalidToken");
        require(address(module) != address(0), "WrongRewardConfig");
        state.rewardConfig.rewardModules[token] = module;        
    }

}

// src/libraries/InterestRateModel.sol

library InterestRateModel {
    using FixedPointMathLib for uint256;
    
    uint256 constant YEAR = 365 * 86400;   
    uint256 public constant WAD = 1e18;

    function updateInterestRates(State storage state) external {
        
        RateData storage rateData = state.rateData;
        ReserveData storage reserveData = state.reserveData;

        uint256 utilizationRate = _calculateUtilizationRate(reserveData.totalBorrows, reserveData.totalDeposits);
        uint256 borrowRate = _calculateBorrowRate(state, utilizationRate);
        uint256 liquidityRate = borrowRate.mulWad(utilizationRate).mulWad(WAD - state.rateConfig.reserveFactor);
        
        rateData.utilizationRate = utilizationRate;
        rateData.borrowRate = borrowRate;
        rateData.liquidityRate = liquidityRate;

        // update Liquidity and Debt Index
        if (block.timestamp > rateData.lastUpdated) {
            uint256 elapsed = block.timestamp - rateData.lastUpdated;
            rateData.debtIndex = rateData.debtIndex.mulWad(WAD + borrowRate.mulDiv(elapsed, YEAR));
            rateData.liquidityIndex = rateData.liquidityIndex.mulWad(WAD + liquidityRate.mulDiv(elapsed, YEAR));      
            rateData.lastUpdated = block.timestamp;            
        }
    }

    function calcUpdatedInterestRates(State storage state) external view returns (uint256 debtIndex, uint256 creditIndex) {
        
        RateData storage rateData = state.rateData;
        ReserveData storage reserveData = state.reserveData;

        uint256 utilizationRate = _calculateUtilizationRate(reserveData.totalBorrows, reserveData.totalDeposits);
        uint256 borrowRate = _calculateBorrowRate(state, utilizationRate);
        
        uint256 liquidityRate = borrowRate.mulWad(utilizationRate).mulWad(WAD - state.rateConfig.reserveFactor);

        // update Liquidity and Debt Index
        if (block.timestamp > rateData.lastUpdated) {
            uint256 elapsed = block.timestamp - rateData.lastUpdated;
            debtIndex = rateData.debtIndex.mulWad(WAD + borrowRate.mulDiv(elapsed, YEAR));
            creditIndex = rateData.liquidityIndex.mulWad(WAD + liquidityRate.mulDiv(elapsed, YEAR));        
        }
    }
    
    function calcUpdatedRates(State storage state) external view returns (uint256 utilizationRate, uint256 liquidityRate, uint256 borrowRate) {
        ReserveData storage reserveData = state.reserveData;

        utilizationRate = _calculateUtilizationRate(reserveData.totalBorrows, reserveData.totalDeposits);
        borrowRate = _calculateBorrowRate(state, utilizationRate);
        
        liquidityRate = borrowRate.mulWad(utilizationRate).mulWad(WAD - state.rateConfig.reserveFactor);
    }    
    
    function _calculateUtilizationRate(uint256 borrows, uint256 deposits) internal pure returns(uint256) {
        if (borrows == 0)
            return 0;

        return borrows.divWad(deposits);
    }

    function _calculateBorrowRate(State storage state, uint256 utilizationRate) internal view returns(uint256 borrowRate) {
        
        uint256 baseRate = state.rateConfig.baseRate;
        uint256 rateSlope1 = state.rateConfig.rateSlope1;
        uint256 rateSlope2 = state.rateConfig.rateSlope2;
        uint256 optimalUtilizationRate = state.rateConfig.optimalUtilizationRate;

        if (utilizationRate < optimalUtilizationRate) {
            borrowRate = baseRate + (utilizationRate * rateSlope1) / optimalUtilizationRate;
        } else {
            borrowRate = baseRate + rateSlope1 + ((utilizationRate - optimalUtilizationRate) * rateSlope2) / (WAD - optimalUtilizationRate);
        }
    }

    function getCreditAmount(State storage state, uint256 amount) external view returns(uint256 credit) {
        credit = amount.divWad(state.rateData.liquidityIndex);
    }

    // amount of principal => debtToken Amount
    function getDebtAmount(State storage state, uint256 amount) external view returns(uint256 debt) {
        debt = amount.divWadUp(state.rateData.debtIndex);
    }

    function getCashAmount(State storage state, uint256 credit) external view returns(uint256 cash) {
        cash = credit.mulWadUp(state.rateData.liquidityIndex);
    }

    function getRepaidAmount(State storage state, uint256 debt) external view returns(uint256 amount) {
        amount = debt.mulWadUp(state.rateData.debtIndex);
    }

}

// src/libraries/PriceLib.sol

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

// src/libraries/ValveLib.sol

library ValveLib {
    uint256 constant emergencyRate = 95_000;
    uint256 constant safeRate = 90_000; // buffer rate is 5%
    uint256 constant unitRate = 100_000;

    uint256 constant determinePrincipal = 10; // one hour    
    uint256 constant minimumInvestToken = 1e18;

    function determineInvestOrWithdraw(address _token) 
        internal 
        view 
        returns (
            bool isInvest, 
            uint256 amount
        ) 
    {
        (
            uint256 totalDeposit,
            uint256 totalInvest,
            uint256 lastRewardedAt
        ) = ILendingPool(address(this)).getInvestReserveData(_token);

        if (totalDeposit == 0)
            return (false, totalInvest);

        uint256 totalUtilizedRate = unitRate * totalInvest / totalDeposit;
        if (totalUtilizedRate >= emergencyRate) {
            isInvest = false;
            amount = (totalUtilizedRate - safeRate) * totalDeposit / unitRate;
        } else if (block.timestamp > lastRewardedAt + determinePrincipal) {
            isInvest = totalUtilizedRate < safeRate;
            amount = isInvest?
                        (safeRate - totalUtilizedRate) * totalDeposit / unitRate :
                        (totalUtilizedRate - safeRate) * totalDeposit / unitRate; 

            if (amount < minimumInvestToken)
                amount = 0;
        }
    }

    // function determineRewardModule(address _token) external view returns (uint8) {
    //     uint8 maxIndex = 0;
    //     IRewardModule[] memory rewardModules = ILendingPool(address(this)).getRewardModules(_token);
    //     uint8 modulesCount = uint8(rewardModules.length);
        
    //     if (rewardModules.length == 1)
    //         return maxIndex;

    //     uint256 maxAPR = rewardModules[0].getCurrentAPR();
    //     for (uint8 i = 1; i < modulesCount; ) {
    //         uint256 apr = rewardModules[i].getCurrentAPR();
    //         if (apr > maxAPR) 
    //             maxIndex = i;

    //         unchecked {
    //             ++i;
    //         }
    //     }

    //     return maxIndex;
    // }

    function executeInvestOrWithdraw(address _token) external returns (uint256 rewardAPR) {
        (
            bool isInvest, 
            uint256 amount
        ) = determineInvestOrWithdraw(_token);

        if (amount != 0) {
            IInvestmentModule investModule = ILendingPool(address(this)).getInvestmentModule();
            if (isInvest) {
                IERC20(_token).approve(address(investModule), amount);
                rewardAPR = investModule.invest(address(this), _token, amount);
            } 
            else {
                // require(amount >= 450000e18, "this is error");
                rewardAPR = investModule.withdraw(address(this), _token, amount);
            }
        } else {
            rewardAPR = ILendingPool(address(this)).getRewardModule(_token).getCurrentAPR();
        }

    }    

}

// lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC-20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    /**
     * @dev An operation with an ERC-20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transferFrom, (from, to, value)));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 requestedDecrease) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeCall(token.approve, (spender, value));

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeCall(token.approve, (spender, 0)));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Performs an {ERC1363} transferAndCall, with a fallback to the simple {ERC20} transfer if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            safeTransfer(token, to, value);
        } else if (!token.transferAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} transferFromAndCall, with a fallback to the simple {ERC20} transferFrom if the target
     * has no code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * Reverts if the returned value is other than `true`.
     */
    function transferFromAndCallRelaxed(
        IERC1363 token,
        address from,
        address to,
        uint256 value,
        bytes memory data
    ) internal {
        if (to.code.length == 0) {
            safeTransferFrom(token, from, to, value);
        } else if (!token.transferFromAndCall(from, to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Performs an {ERC1363} approveAndCall, with a fallback to the simple {ERC20} approve if the target has no
     * code. This can be used to implement an {ERC721}-like safe transfer that rely on {ERC1363} checks when
     * targeting contracts.
     *
     * NOTE: When the recipient address (`to`) has no code (i.e. is an EOA), this function behaves as {forceApprove}.
     * Opposedly, when the recipient address (`to`) has code, this function only attempts to call {ERC1363-approveAndCall}
     * once without retrying, and relies on the returned value to be true.
     *
     * Reverts if the returned value is other than `true`.
     */
    function approveAndCallRelaxed(IERC1363 token, address to, uint256 value, bytes memory data) internal {
        if (to.code.length == 0) {
            forceApprove(token, to, value);
        } else if (!token.approveAndCall(to, value, data)) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturnBool} that reverts if call fails to meet the requirements.
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            let success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            // bubble errors
            if iszero(success) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
            returnSize := returndatasize()
            returnValue := mload(0)
        }

        if (returnSize == 0 ? address(token).code.length == 0 : returnValue != 1) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silently catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly ("memory-safe") {
            success := call(gas(), token, 0, add(data, 0x20), mload(data), 0, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0)
        }
        return success && (returnSize == 0 ? address(token).code.length > 0 : returnValue == 1);
    }
}

// src/libraries/InitializeConfig.sol

library InitializeConfig {

    function initialize(State storage state, InitializeParam memory param) external {
        initilizeTokenConfig(state, param.tokenConfig);
        initializeRiskConfig(state, param.riskConfig);
        initializeFeeConfig(state, param.feeConfig);
        initializeRateData(state, param.rateConfig);
    }

    function initilizeTokenConfig(
        State storage state, 
        InitializeTokenConfig memory tokenInfo
    ) internal {
        require(address(tokenInfo.principalToken) != address(0), "Wrong Address");
        state.tokenConfig.principalToken = tokenInfo.principalToken;
        state.tokenConfig.principalKey = tokenInfo.principalKey;
        state.tokenConfig.oracle = tokenInfo.oracle;
        state.tokenConfig.investModule = tokenInfo.investModule;
        InitializeAction.addCollateralTokens(state, tokenInfo.collaterals);
    }
    
    function initializeRiskConfig(
        State storage state, 
        RiskConfig memory riskConfig
    ) internal {
        InitializeAction.setLoanToValue(state, riskConfig.loanToValue);
        InitializeAction.setLiquidationThreshold(state, riskConfig.liquidationThreshold);
        InitializeAction.setMinimuBorrowToken(state, riskConfig.minimumBorrowToken);
        InitializeAction.setBorrowTokenCap(state, riskConfig.borrowTokenCap);
        InitializeAction.setHealthFactorForClose(state, riskConfig.healthFactorForClose);
        InitializeAction.setLiquidationBonus(state, riskConfig.liquidationBonus);
    }

    function initializeFeeConfig(
        State storage state, 
        FeeConfig memory feeConfig
    ) internal {
        InitializeAction.setProtocolFeeRate(state, feeConfig.protocolFeeRate);
        InitializeAction.setProtocolFeeRecipient(state, feeConfig.protocolFeeRecipient);
    }

    function initializeRateData(
        State storage state, 
        RateConfig memory rateConfig
    ) internal {
        state.rateData.debtIndex = 1e18;
        state.rateData.liquidityIndex = 1e18;
        state.rateData.borrowRate = rateConfig.baseRate;
        state.rateData.lastUpdated = block.timestamp;

        InitializeAction.setInterestRateConfig(state, rateConfig);
    }

}

// src/libraries/AccountingLib.sol

library AccountingLib {

    using FixedPointMathLib for uint256;
    using PriceLib for State;
    using InterestRateModel for State;

    uint256 constant WAD = 1e18;

    function getHealthInfo(
        State storage state, 
        address user
    ) 
        external 
        view
        returns(
            uint256 collateralAmount, 
            uint256 totalBorrowedAmount, 
            uint256 healthFactor
        ) 
    {        
        return _calcHealthInfo(state, user);
    }

    function getMaxLiquidationAmount(
        State storage state, 
        address user
    ) 
        external 
        view
        returns(
            uint256 healthFactor,
            uint256 totalBorrowedAmount,
            uint256 maxLiquidationAmount, 
            uint256 maxLiqudiationBonus
        ) 
    { 
        (, totalBorrowedAmount, healthFactor) = _calcHealthInfo(state, user);
        (
            maxLiquidationAmount,
            maxLiqudiationBonus
        )  = _calcMaxLiquidationAmount(state, totalBorrowedAmount, healthFactor);
    }

    function _calcHealthInfo(
        State storage state, 
        address user
    ) 
        internal 
        view
        returns(
            uint256 collateralAmount, 
            uint256 totalBorrowedAmount, 
            uint256 healthFactor
        ) 
    {
        DebtPosition storage position = state.positionData.debtPositions[user];
        if (position.debtAmount == 0)
            return (0, 0, WAD);

        uint256 liquidationThreshold = state.riskConfig.liquidationThreshold;
        uint256 repaidAmount = state.getRepaidAmount(position.debtAmount);
        collateralAmount = _collateralValueInUSD(state, position);
        totalBorrowedAmount = _principalValueInUSD(state, repaidAmount);        

        healthFactor = collateralAmount.mulDiv(liquidationThreshold, totalBorrowedAmount);
    }

    function _calcMaxLiquidationAmount(
        State storage state, 
        uint256 totalBorrowedAmount, 
        uint256 healthFactor
    ) 
        internal 
        view
        returns(
            uint256 liquidationAmount, 
            uint256 liqudiationBonus
        ) 
    {
        if (healthFactor >= WAD) {
            liquidationAmount = 0;
            liqudiationBonus = 0;            
        } else {
            uint256 closeFactor = state.riskConfig.healthFactorForClose;
            if (healthFactor <= closeFactor)
                liquidationAmount = totalBorrowedAmount;                
            else
                liquidationAmount = totalBorrowedAmount;
            
            liqudiationBonus = totalBorrowedAmount * state.riskConfig.liquidationBonus;
        }
        
    }
    
    function getCollateralValueInPrincipal(State storage state, DebtPosition storage position) external view returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position);      
    }

    function getCollateralValueInPrincipal(State storage state, DebtPosition storage position, address collateralToken) external view returns(uint256 principalAmount) {
        return _collateralValueInPrincipal(state, position, collateralToken);
    }

    function getCollateralValueInUSD(State storage state, DebtPosition storage position) external view returns(uint256 usdValue) {
        return _collateralValueInUSD(state, position);
    }    

    function getCollateralValueInUSD(State storage state, address collateralToken, uint256 amount) external view returns (uint256 usdValue) {
        return amount.mulDiv(state.collateralPriceInUSD(collateralToken), 1e8);
    }

    function getPrincipalValueInUSD(State storage state, uint256 repaidAmount) external view returns(uint256 usdValue) {
        return _principalValueInUSD(state, repaidAmount);
    }  

    function _collateralValueInPrincipal(State storage state, DebtPosition storage position) internal view returns(uint256 principalAmount) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        for (uint256 i = 0; i < tokensCount; ) {
            principalAmount += _collateralValueInPrincipal(state, position, address(collateralTokens[i]));

            unchecked {
                ++i;
            }
        }        
    }

    function _collateralValueInPrincipal(State storage state, DebtPosition storage position, address collateralToken) internal view returns(uint256 principalAmount) {

        uint256 amount = position.collaterals[address(collateralToken)].amount;    
        uint256 collateralPriceInPrincipal = state.collateralPriceInPrincipal(collateralToken);
        if (amount != 0) {
            principalAmount = amount.mulWad(collateralPriceInPrincipal);
        }
    }

    function _collateralValueInUSD(State storage state, DebtPosition storage position) internal view returns(uint256 principalAmount) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        for (uint256 i = 0; i < tokensCount; ) {
            principalAmount += _collateralValueInUSD(state, position, address(collateralTokens[i]));

            unchecked {
                ++i;
            }
        }        
    }

    function _collateralValueInUSD(State storage state, DebtPosition storage position, address collateralToken) internal view returns(uint256 usdValue) {

        uint256 amount = position.collaterals[collateralToken].amount;    
        if (amount != 0) {
            uint256 collateralPrice = state.collateralPriceInUSD(collateralToken);
            usdValue = amount.mulDiv(collateralPrice, 1e8);
        }
    }

    function _principalValueInUSD(State storage state, uint256 repaidAmount) internal view returns(uint256 usdValue) {
        if (repaidAmount != 0) {
            uint256 principalPrice = state.principalPriceInUSD();
            usdValue = repaidAmount.mulDiv(principalPrice, 1e8);
        }
    }    
    
}

// src/libraries/PositionInfo.sol

library PositionInfo {

    using FixedPointMathLib for uint256;
    using InterestRateModel for State;
    using PriceLib for State;
    
    function getUserCollateralData(State storage state, address user) external view returns(UserCollateralData memory collateralData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        
        uint256 totalValue;
        PositionCollateral[] memory collaterals = new PositionCollateral[](tokensCount); 
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collaterals[tokenAddress].amount;
            uint256 accruedRewards = position.collaterals[tokenAddress].accruedRewards;
            uint256 collateralValue;
            if (collateralAmount != 0) {
                collateralValue = collateralAmount.mulDiv(state.collateralPriceInUSD(tokenAddress), 1e8);
                totalValue += collateralValue;
            }
            
            collaterals[i] = PositionCollateral({
                token: tokenAddress,
                amount: collateralAmount,
                rewards: accruedRewards,
                value: collateralValue
            });

            unchecked {
                ++i;
            }   
        }
        collateralData = UserCollateralData({
            collaterals: collaterals,
            totalValue: totalValue
        });
    } 

    function getLiquidityPositionData(State storage state, address user) public view returns(UserCreditPositionData memory positionData) {
        CreditPosition storage position = state.positionData.creditPositions[user];
        
        uint256 price = state.principalPriceInUSD();
        uint256 liquidityAmount = position.depositAmount;
        // if (liquidityAmount != 0) {
            uint256 liquidityValue = position.depositAmount.mulDiv(price, 1e8);
            uint256 cashAmount = state.getCashAmount(position.creditAmount);
            uint256 cashValue = cashAmount.mulDivUp(price, 1e8);

            uint256 earnedAmount = cashAmount > liquidityAmount? position.earnedAmount + cashAmount - liquidityAmount : position.earnedAmount;
            uint256 earnedValue = cashValue > liquidityValue? position.earnedValue + cashValue - liquidityValue : position.earnedValue;

            positionData = UserCreditPositionData({
                poolAddress: address(this),
                tokenAddress: address(state.tokenConfig.principalToken),
                liquidityAmount: liquidityAmount,
                liquidityValue: liquidityValue,
                cashAmount: cashAmount,
                cashValue: cashValue,
                earnedAmount: earnedAmount,
                earnedValue: earnedValue
            });
        // }
    }

    function getDebtPositionData(State storage state, address user) public view returns(UserDebtPositionData memory positionData) {
        DebtPosition storage position = state.positionData.debtPositions[user];
        uint256 principalPrice = state.principalPriceInUSD();
        positionData.borrowAmount = position.borrowAmount;
        positionData.borrowValue = position.borrowAmount.mulDiv(principalPrice, 1e8);
        positionData.currentDebtAmount = state.getRepaidAmount(position.debtAmount);
        positionData.currentDebtValue = state.getRepaidAmount(position.debtAmount).mulDivUp(principalPrice, 1e8);

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        uint256 collateralValue;
        uint256 rewards;
        for (uint i = 0; i < tokensCount; ) {
            address tokenAddress = address(collateralTokens[i]);
            uint256 collateralAmount = position.collaterals[tokenAddress].amount;
            if (collateralAmount != 0)
                collateralValue += collateralAmount.mulDiv(state.collateralPriceInUSD(tokenAddress), 1e8);
                
            rewards += position.collaterals[tokenAddress].accruedRewards;
            unchecked {
                ++i;
            }
        }

        // if (collateralValue != 0) {
            positionData.poolAddress = address(this);
            positionData.tokenAddress = address(state.tokenConfig.principalToken);
            positionData.collateralValue = collateralValue;
            positionData.liquidationPoint = collateralValue.mulWad(state.riskConfig.liquidationThreshold);
            positionData.borrowCapacity = collateralValue.mulWad(state.riskConfig.loanToValue);
            positionData.rewards = rewards;
            if (positionData.borrowCapacity > positionData.currentDebtValue) {
                positionData.availableToBorrowAmount = principalPrice == 0? 0 : (positionData.borrowCapacity - positionData.currentDebtValue).mulDiv(1e8, principalPrice);
                positionData.availableToBorrowValue = positionData.borrowCapacity - positionData.currentDebtValue;
            }
            
        // }
    }
}

// src/libraries/PoolStatistics.sol

library PoolStatistics {
    
    using AccountingLib for State;
    using InterestRateModel for State;
    using PriceLib for State;

    function getPoolStatistics(State storage state) 
        public 
        view
        returns (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) 
    {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;

        totalDeposits = state.reserveData.totalDeposits;
        totalBorrows = state.reserveData.totalBorrows;
        uint256 totalCredit = state.getCashAmount(state.reserveData.totalCredit);

        if (totalCredit > totalDeposits) {
            totalEarnings = totalCredit - totalDeposits;
        }

        for (uint i = 0; i < tokensCount; ) {
            address collateralToken = address(collateralTokens[i]);
            totalCollaterals += state.getCollateralValueInUSD(
                collateralToken, 
                state.reserveData.totalCollaterals[collateralToken].totalDeposits
            );
            unchecked {
                ++i;
            }
        }
    }

    function getPoolInfo(State storage state) public view returns(PoolInfo memory info) {
        (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) = getPoolStatistics(state);

        (
            uint256 utilizationRate, 
            uint256 liquidityRate, 
            uint256 borrowRate 
        ) = state.calcUpdatedRates();

        info = PoolInfo({
            poolAddress: address(this),
            principalToken: address(state.tokenConfig.principalToken),
            // collateralTokens: getCollateralTokens(),
            totalDeposits: totalDeposits,
            totalBorrows: totalBorrows,
            totalCollaterals: totalCollaterals,
            totalEarnings: totalEarnings, 
            utilizationRate: utilizationRate,
            borrowAPR: borrowRate,
            earnAPR: liquidityRate
        });
    }

    function getCollateralsData(State storage state) public view returns(CollateralsData memory info) {

        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        CollateralData[] memory _tokenData = new CollateralData[](tokensCount); 
        for (uint256 i = 0; i < tokensCount; ) {
            address _tokenAddress = address(collateralTokens[i]);
            uint256 _totalSupply = state.reserveData.totalCollaterals[_tokenAddress].totalDeposits;
            uint256 _oraclePrice = state.collateralPriceInUSD(_tokenAddress);
            _tokenData[i] = CollateralData({
                token: _tokenAddress,
                totalSupply: _totalSupply,
                oraclePrice: _oraclePrice
            });
            
            unchecked {
                ++i;
            }
        }

        info = CollateralsData({
            tokenData: _tokenData,
            loanToValue: state.riskConfig.loanToValue,
            liquidationThreshold: state.riskConfig.liquidationThreshold,
            liquidationBonus: state.riskConfig.liquidationBonus
        });
    }
}

// src/LendingPoolStorage.sol

abstract contract LendingPoolStorage {
    using PositionInfo for State;
    using PoolStatistics for State;
    using InvestmentLib for State;
    
    State internal state;

    function getPrincipalToken() public view returns (address principalToken) {
        principalToken = address(state.tokenConfig.principalToken);
    }

    function getCollateralTokens() public view returns (address[] memory) {
        IERC20[] memory collateralTokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = collateralTokens.length;
        address[] memory addresses = new address[](tokensCount);
        for (uint i = 0; i < tokensCount; ) {
            addresses[i] = address(collateralTokens[i]);
            unchecked {
                ++i;
            }
        }
        
        return addresses;
    }

    // function getRewardModules(address token) public view returns (IRewardModule[] memory modules) {
    //     modules = state.rewardConfig.rewardModules[token];
    // }

    function getRewardModule(address token) public view returns (IRewardModule module) {
        module = state.rewardConfig.rewardModules[token];
    }

    function getInvestmentModule() public view returns (IInvestmentModule module) {
        module = state.tokenConfig.investModule;
    }

    function getPoolStatistics() 
        public 
        view
        returns (
            uint256 totalDeposits, 
            uint256 totalCollaterals, 
            uint256 totalBorrows,
            uint256 totalEarnings
        ) 
    {
        return state.getPoolStatistics();
    }

    function getPoolInfo() public view returns(PoolInfo memory info) {
        return state.getPoolInfo();
    }

    function getCollateralsData() public view returns(CollateralsData memory info) {
        return state.getCollateralsData();
    }

    function getUserCollateralData(address user) public view returns(UserCollateralData memory collateralData) {
        return state.getUserCollateralData(user);
    } 

    function getLiquidityPositionData(address user) public view returns(UserCreditPositionData memory positionData) {
        return state.getLiquidityPositionData(user);
    }

    function getDebtPositionData(address user) public view returns(UserDebtPositionData memory positionData) {
        return state.getDebtPositionData(user);
    }

    // function getRewardIndex(address token) external view returns (uint256 rewardIndex) {
    //     rewardIndex = state.getRewardIndex(token);
    // }

    function getInvestReserveData(address token) public view returns (uint256 totalDeposits, uint256 totalInvested, uint256 lastRewardedAt) {
        return state.getInvestReserveData(token);
    }    

    function getLastRewardAPRUpdatedAt(address token) external view returns (uint256 lastUpdatedAt) {
        return state.getLastRewardAPRUpdatedAt(token);
    }
    
    function updateInvestReserveData(
        bool isInvest, 
        address token, 
        uint256 investAmount, 
        uint256 rewards, 
        uint256 rewardAPR
    ) public {
        state.updateInvestReserveData(isInvest, token, investAmount, rewards, rewardAPR);
    }

}

// src/libraries/TransferLib.sol

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

// src/libraries/Liquidation.sol

 

library Liquidation  {

    using FixedPointMathLib for uint256;
    using InterestRateModel for State;
    using TransferLib for State;
    using AccountingLib for State;    
    using PriceLib for State;

    function liquidate(State storage state, address _borrower, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        _validateLiquidation(state, _borrower, _amount);

        //update reserve and borrower's debt
        DebtPosition storage position = state.positionData.debtPositions[_borrower];
        uint256 debt = state.getDebtAmount(_amount);
        uint256 repaid = position.borrowAmount.mulDiv(debt, position.debtAmount); 
        state.reserveData.totalBorrows -= repaid;
        position.borrowAmount -= repaid; 
        state.positionData.totalDebt -= debt;
        position.debtAmount -= debt;

        // repaid principal behalf of borrower
        IERC20[] memory tokens = state.tokenConfig.collateralTokens;
        uint256 tokensCount = tokens.length;
        uint256 totalPaid = _amount.mulWad(state.riskConfig.liquidationBonus);

        state.transferPrincipal(msg.sender, address(this), _amount);
        for (uint256 i = 0;  i < tokensCount; ) {
            address token = address(tokens[i]);
            uint256 principalAmount = state.getCollateralValueInPrincipal(position, token);
            if (totalPaid > principalAmount) {
                totalPaid -= principalAmount;
                state.transferCollateral(token, msg.sender, principalAmount);  
            } else {
                state.transferCollateral(token, msg.sender, totalPaid);  
                break;      
            }

            unchecked {
                ++i;
            }
        }
    }

    function _validateLiquidation(State storage state, address _borrower, uint256 _amount) internal view {
        (
            uint256 healthFactor,
            ,
            uint256 maxLiquidationAmount, 
            
        ) = state.getMaxLiquidationAmount(_borrower);

        require(healthFactor < 1e18, "This account is healthy");
        require(maxLiquidationAmount >= _amount, "Amount is too large");
    }

}

// src/libraries/Repay.sol

library Repay {
    
    using PriceLib for State;
    using TransferLib for State;    
    using AccountingLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    function repay(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate repay amount
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateRepay(state, position, _amount);
        uint256 debt = state.getDebtAmount(_amount);
        
        // update debt, and borrow amount
        uint256 repaid = position.borrowAmount.mulDiv(debt, position.debtAmount); 
        
        state.reserveData.totalBorrows -= repaid; 
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= debt;
        
        position.borrowAmount -= repaid;
        position.repaidAmount += repaid;
        position.debtAmount -= debt;
        
        // state.reserveData
        state.transferPrincipal(msg.sender, address(this), _amount);

        emit Events.Repaid(msg.sender, _amount, repaid);
    }  

    function repayAll(State storage state) external {
        // update interest rate model
        state.updateInterestRates();
        
        // calculate fully repaid amount
        uint256 repaid = _calculateRepaidAmount(state);

        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        // update borrow and debt info
        state.reserveData.totalBorrows -= position.borrowAmount;
        state.reserveData.totalRepaid += repaid;
        state.positionData.totalDebt -= position.debtAmount;

        position.borrowAmount = 0;
        position.repaidAmount += repaid;
        position.debtAmount = 0;

        // state.reserveData
        state.transferPrincipal(msg.sender, address(this), repaid);

        emit Events.Repaid(msg.sender, position.borrowAmount, repaid);
    }

    function getFullRepayAmount(State storage state) external view returns (uint256 repaid) {
        // update interest rate model
        (uint256 debtIndex, ) = state.calcUpdatedInterestRates();
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        repaid = position.debtAmount.mulWadUp(debtIndex);
    }

    function _calculateRepaidAmount(State storage state) internal view returns (uint256 repaid) {
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        repaid = state.getRepaidAmount(position.debtAmount);
    }

    function _validateRepay(State storage state, DebtPosition storage position, uint256 _amount) internal view {
        uint256 repayAmount = position.debtAmount.mulWad(state.rateData.debtIndex);
        require(_amount > 0 || _amount <= repayAmount, "Invalid repay amount");        
    }
}

// src/libraries/Supply.sol

library Supply {

    using TransferLib for State;
    using InterestRateModel for State;
    using AccountingLib for State;
    using FixedPointMathLib for uint256;

    function supply(State storage state, uint256 _cashAmount, uint256 _minCredit) external returns(uint256 credit) {
        require(_cashAmount > 0, "Invalid deposit amount");

        // Update interest rates based on new liquidity
        state.updateInterestRates();

        CreditPosition storage position = state.positionData.creditPositions[msg.sender];
        
        // update reserve data and credit position
        credit = state.getCreditAmount(_cashAmount);
        require(credit >= _minCredit, "Minimum credit doesn't reach");
        
        state.reserveData.totalCredit += _cashAmount;
        state.reserveData.totalDeposits += _cashAmount;
        state.positionData.totalCredit += credit;
        position.totalDeposit += _cashAmount;
        position.depositAmount += _cashAmount;
        position.creditAmount += credit;

        // Transfer the borrow token from the lender to the contract
        state.transferPrincipal(msg.sender, address(this), _cashAmount);

        emit Events.DepositPrincipal(msg.sender, _cashAmount, credit);
    }

    function withrawSupply(State storage state, uint256 _cashAmount) external returns (uint256 creditAmount) {
        require(_cashAmount > 0, "Invalid deposit amount");

        // Update interest rates based on new liquidity
        state.updateInterestRates();
        
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];

        creditAmount = state.getCreditAmount(_cashAmount);
        uint256 withdrawalCash = position.depositAmount.mulDiv(creditAmount, position.creditAmount);

        state.reserveData.totalDeposits -= withdrawalCash;
        state.positionData.totalCredit -= creditAmount;
        state.reserveData.totalWithdrawals += _cashAmount;
        
        position.depositAmount -= withdrawalCash;
        position.creditAmount -= creditAmount;
        position.withdrawAmount += _cashAmount; 

        uint256 earnedAmount = _cashAmount - withdrawalCash;
        position.earnedAmount += _cashAmount - withdrawalCash;
        position.earnedValue += state.getPrincipalValueInUSD(earnedAmount);       

        state.transferPrincipal(msg.sender, _cashAmount);

        emit Events.WithdrawPrincipal(msg.sender, _cashAmount, creditAmount);
    }

    function withrawAllSupply(State storage state) external returns (uint256 cash, uint256 totalEarned) {
        // Update interest rates based on new liquidity
        state.updateInterestRates();
        
        CreditPosition storage position = state.positionData.creditPositions[msg.sender];

        uint256 creditAmount = position.creditAmount;
        cash = state.getCashAmount(creditAmount);
        
        state.reserveData.totalDeposits -= position.depositAmount;
        state.positionData.totalCredit -= creditAmount;
        state.reserveData.totalWithdrawals += cash;
        
        position.depositAmount = 0;
        position.creditAmount = 0;
        position.withdrawAmount += cash;

        uint256 earnedAmount = cash - position.depositAmount;
        position.earnedAmount += earnedAmount;
        position.earnedValue += state.getPrincipalValueInUSD(earnedAmount);
        
        totalEarned = position.withdrawAmount - position.totalDeposit;

        state.transferPrincipal(msg.sender, cash);

        emit Events.WithdrawPrincipal(msg.sender, cash, creditAmount);
    }
} 

// src/libraries/Borrow.sol

library Borrow {

    using PriceLib for State;
    using TransferLib for State;    
    using AccountingLib for State;
    using InterestRateModel for State;
    using FixedPointMathLib for uint256;

    uint256 constant YEAR = 365 * 86400; 
    uint256 constant LENDER_RATE = 30_000;
    uint256 constant BORROWER_RATE = 60_000;
    uint256 constant ALL_RATE = 100_000;

    function depositCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        require(_amount > 0, "Invalid deposit amount");
        
        // update interest rate model
        state.updateInterestRates();
        InvestReserveData storage reserveData = state.reserveData.totalCollaterals[_collateralToken];
        DebtPositionCollateral storage positionCollateral = state.positionData.debtPositions[msg.sender].collaterals[_collateralToken];
        
        // Update collateral data for the user
        uint256 totalDeposits = reserveData.totalDeposits;
        uint256 collateralAmount = positionCollateral.amount;

        reserveData.totalDeposits = totalDeposits + _amount;
        positionCollateral.amount = collateralAmount + _amount;

        bool isSetRewardModule = _setAccruedRewards(_collateralToken, positionCollateral, collateralAmount);
        
        // Transfer the collateral token from the user to the contract
        state.transferCollateral(_collateralToken, msg.sender, address(this), _amount);

        if (isSetRewardModule)
            positionCollateral.lastAPR = ValveLib.executeInvestOrWithdraw(_collateralToken);
        
        emit Events.CollateralDeposited(msg.sender, _amount);
    }
    
    function withdrawCollateral(State storage state, address _collateralToken, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();

        // validate enough collateral to withdraw
        ReserveData storage reserveData = state.reserveData;
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        InvestReserveData storage investData = reserveData.totalCollaterals[_collateralToken];
        DebtPositionCollateral storage positionCollateral = position.collaterals[_collateralToken];
        _validateWithdrawCollateral(state, position, _collateralToken, _amount);

        // update collateral data for the user        
        uint256 totalDeposits = investData.totalDeposits;
        uint256 collateralAmount = positionCollateral.amount;

        investData.totalDeposits = totalDeposits - _amount;
        positionCollateral.amount = collateralAmount - _amount;
        
        bool isSetRewardModule = _setAccruedRewards(_collateralToken, positionCollateral, collateralAmount);        
        if (isSetRewardModule)
            positionCollateral.lastAPR = ValveLib.executeInvestOrWithdraw(_collateralToken);

        // Transfer the collateral token from the user to the contract
        state.transferCollateral(_collateralToken, msg.sender, _amount);

        emit Events.CollateralWithdrawn(msg.sender, _amount);
    }

    function borrow(State storage state, uint256 _amount) external {
        // update interest rate model
        state.updateInterestRates();
        
        DebtPosition storage position = state.positionData.debtPositions[msg.sender];
        _validateBorrow(state, position, _amount);

        uint256 debt = state.getDebtAmount(_amount);
        // update borrow data for user & pool
        // update debt for the user's position
        state.reserveData.totalBorrows += _amount;
        position.totalBorrow += _amount;
        position.borrowAmount += _amount;
        position.debtAmount += debt;
        state.positionData.totalDebt += debt;

        // Transfer the principal token from the contract to the user
        state.transferPrincipal(msg.sender, _amount);

        // IRewardModule rewardModule = ILendingPool(address(this)).getRewardModule(address(state.tokenConfig.principalToken));
        // bool isSetRewardModule = address(rewardModule) != address(0);
        // if (isSetRewardModule)
        //     ValveLib.executeInvestOrWithdraw(address(state.tokenConfig.principalToken));

        emit Events.Borrowed(msg.sender, _amount);
    }

    function _setAccruedRewards(
        address _collateralToken, 
        DebtPositionCollateral storage positionCollateral,
        uint256 collateralAmount
    ) internal returns (bool isSetRewardModule) {
        IRewardModule rewardModule = ILendingPool(address(this)).getRewardModule(_collateralToken);
        isSetRewardModule = address(rewardModule) != address(0);
        if (isSetRewardModule) {
            if (positionCollateral.lastRewardedAt == 0) 
                positionCollateral.lastRewardedAt = block.timestamp;
            else {
                if (collateralAmount != 0) {
                    uint256 reward = collateralAmount.mulWad(positionCollateral.lastAPR).mulDiv(block.timestamp - positionCollateral.lastRewardedAt, YEAR);
                    positionCollateral.accruedRewards += reward.mulDiv(BORROWER_REWARD_RATE, TOTAL_RATE);
                    positionCollateral.lastRewardedAt = block.timestamp;
                }
            }
        }
    }

    function _validateWithdrawCollateral(
        State storage state, 
        DebtPosition storage position,
        address _collateralToken,
        uint256 _amount
    ) internal view {
        require(_amount > 0, "InvalidAmount");
        require(_amount <= position.collaterals[_collateralToken].amount, "AmountLarge");
        
        uint256 liquidationThreshold = state.riskConfig.liquidationThreshold;
        
        uint256 borrowAmount = state.getRepaidAmount(position.debtAmount);
        uint256 collateralInUSD = state.getCollateralValueInUSD(position);
        uint256 borrowInUSD = state.getPrincipalValueInUSD(borrowAmount);
        uint256 collateralUsed = borrowInUSD.divWadUp(liquidationThreshold);
        uint256 maxWithdrawAllowed = collateralInUSD - collateralUsed;

        uint256 withdrawInUsd = state.collateralValueInUSD(_collateralToken, _amount); 

        require(withdrawInUsd <= maxWithdrawAllowed, "NotEnoughcollateral");
    }

    function _validateBorrow(
        State storage state, 
        DebtPosition storage position,
        uint256 _amount
    ) internal view {
        require(_amount > state.riskConfig.minimumBorrowToken, "InvalidAmount");

        uint256 loanToValue = state.riskConfig.loanToValue;

        uint256 borrowedAmount = position.borrowAmount;
        uint256 collateralAmount = state.getCollateralValueInPrincipal(position);
        uint256 maxBorrowAllowed = collateralAmount.divWad(loanToValue);        

        require(_amount + borrowedAmount <= maxBorrowAllowed, "NotEnoughCollateral");
        require(_amount + state.reserveData.totalBorrows <= state.riskConfig.borrowTokenCap, "BorrowCapReached");
    }

}

// src/LendingPoolAction.sol

contract LendingPoolAction is LendingPoolStorage {
    
    using Borrow for State;
    using Repay for State;
    using Supply for State;
    using Liquidation for State;

    // Supply Logic 
    function supply(uint256 _cashAmount, uint256 _minCredit) external returns(uint256 credit) {
        credit = state.supply(_cashAmount, _minCredit);
    }

    function withrawSupply(uint256 _creditAmount) external returns (uint256 cash) {
        cash = state.withrawSupply(_creditAmount);
    }

    function withrawAllSupply() external returns (uint256 cash, uint256 totalEarned) {
        (cash, totalEarned) = state.withrawAllSupply();
    }

    // Borrow Logic 
    function depositCollateral(address _collateralToken, uint256 _amount) external {
        state.depositCollateral(_collateralToken, _amount);
    }
    
    function withdrawCollateral(address _collateralToken, uint256 _amount) external {
        state.withdrawCollateral(_collateralToken, _amount);
    }

    function borrow(uint256 _amount) external {
        state.borrow(_amount);
    }

    function repay(uint256 _amount) external {
        state.repay(_amount);
    }  

    function repayAll() external {
        state.repayAll();
    }

    function getFullRepayAmount() external view returns (uint256 repaid) {
        repaid = state.getFullRepayAmount();
    }

    // Liquidate Logic
    function liquidate(address _borrower, uint256 _amount) external {
        state.liquidate(_borrower, _amount);
    }

}

// src/LendingPool.sol

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

// src/LendingPoolFactory.sol

contract LendingPoolFactory is Ownable {

    address[] public poolAddresses;

    event PoolAdded(address poolAddress);
    
    constructor() Ownable(msg.sender) {}

    function createLendingPool() public onlyOwner returns(address poolAddress) {
        poolAddress = address(new LendingPool(msg.sender));
        poolAddresses.push(poolAddress);
        
        emit PoolAdded(poolAddress);
    }

    function getAllPoolsInfo() public view returns (PoolInfo[] memory) {
        uint256 poolsCount = poolAddresses.length;
        PoolInfo[] memory pools = new PoolInfo[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            pools[i] = ILendingPool(poolAddresses[i]).getPoolInfo();

            unchecked {
                ++i;
            }
        }

        return pools;
    }

    function getUserCreditPositions(address user) public view returns (UserCreditPositionData[] memory creditPositions) {
        uint256 poolsCount = poolAddresses.length;
        creditPositions = new UserCreditPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            creditPositions[i] = ILendingPool(poolAddresses[i]).getLiquidityPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }

    function getUserDebtPositions(address user) public view returns (UserDebtPositionData[] memory debtPositions) {
        uint256 poolsCount = poolAddresses.length;
        debtPositions = new UserDebtPositionData[](poolsCount);
        for (uint i = 0; i < poolsCount; ) {
            debtPositions[i] = ILendingPool(poolAddresses[i]).getDebtPositionData(user);
            unchecked {
                ++i;
            }
        }    
    }
}

