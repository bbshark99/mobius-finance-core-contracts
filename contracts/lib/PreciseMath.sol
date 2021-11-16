// SPDX-License-Identifier: MIT
pragma solidity =0.8.4;

library PreciseMath {

    uint256 private constant decimals = 18;
    uint256 private constant preciseDecimals = 27;

    uint256 private constant decimal = 10**decimals;
    uint256 private constant precise = 10**preciseDecimals;

    function DECIMALS() internal pure returns (uint256) {
        return decimals;
    }

    function DECIMAL_ONE() internal pure returns (uint256) {
        return decimal;
    }

    function PRECISE_ONE() internal pure returns (uint256) {
        return precise;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a >= b) ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a >= b) ? b : a;
    }

    function decimalsTo(
        uint256 a,
        uint256 b,
        uint256 c
    ) internal pure returns (uint256) {
        if (a == 0) return 0;
        if (b == c) return a;
        if (b < c) return a * (10**(c - b));
        return a / (10**(b - c));
    }

    function toDecimal(uint256 a) internal pure returns (uint256) {
        uint256 b = decimalsTo(a, preciseDecimals, decimals + 1);
        if (b % 10 >= 5) b += 10;
        return b / 10;
    }

    function toPrecise(uint256 a) internal pure returns (uint256) {
        return decimalsTo(a, decimals, preciseDecimals);
    }

    function _multiply(
        uint256 a,
        uint256 b,
        uint256 precision
    ) internal pure returns (uint256) {
        if (a == 0 || b == 0) return 0;
        // return (precision / 2).add(a.mul(b)) / precision;
        return (a * b) / precision;
    }

    function _divide(
        uint256 a,
        uint256 b,
        uint256 precision
    ) internal pure returns (uint256) {
        if (a == 0 || b == 0) return 0;
        // return (b / 2).add(a.mul(precision)).div(b);
        return (a * precision) / b;
    }

    function decimalMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
        return _multiply(a, b, decimal);
    }

    function decimalDivide(uint256 a, uint256 b) internal pure returns (uint256) {
        return _divide(a, b, decimal);
    }

    function preciseMultiply(uint256 a, uint256 b) internal pure returns (uint256) {
        return _multiply(a, b, precise);
    }

    function preciseDivide(uint256 a, uint256 b) internal pure returns (uint256) {
        return _divide(a, b, precise);
    }
}
