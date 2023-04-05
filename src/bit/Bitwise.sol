// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bitwise {
    function and(uint256 x, uint256 y) external pure returns (uint256) {
        return x & y;
    }

    function or(uint256 x, uint256 y) external pure returns (uint256) {
        return x | y;
    }

    function xor(uint256 x, uint256 y) external pure returns (uint256) {
        return x ^ y;
    }

    function not(uint256 x) external pure returns (uint256) {
        return ~x;
    }

    function shiftLeft(uint256 x, uint256 bits) external pure returns (uint256) {
        return x << bits;
    }

    function shiftRight(uint256 x, uint256 bits) external pure returns (uint256) {
        return x >> bits;
    }

    // Get first n bits from x
    function getFirstNBits(uint256 x, uint256 n) external pure returns (uint256) {
        uint256 len = getBitLength(x);
        return x >> (len - n);
    }

    // Set value to first of x
    function setFirstBits(uint256 x, uint256 value) external pure returns (uint256) {
        uint256 n = getBitLength(x) - getBitLength(value);
        uint256 mask = (1 << n) - 1;
        return (x & mask) | (value << n);
    }

    // Get last n bits from x
    function getLastNBits(uint256 x, uint256 n) external pure returns (uint256) {
        uint256 mask = (1 << n) - 1;
        return x & mask;
    }

    // Set value to last of x
    function setLastBits(uint256 x, uint256 value) external pure returns (uint256) {
        uint256 n = getBitLength(value);
        uint256 mask = (1 << n) - 1;
        uint256 clear_mask = ~mask;
        return (x & clear_mask) | value;
    }

    // Get from n bits to n + m bits in x
    function getBitsInRange(uint256 x, uint256 n, uint256 m) external pure returns (uint256) {
        uint256 k = getBitLength(x) - n;
        uint256 mask = (1 << k) - 1;
        return (x & mask) >> (k - m);
    }

    // Set from n bits to n + m bits in x
    function setBitsInRange(uint256 x, uint256 n, uint256 value) external pure returns (uint256) {
        uint256 m = getBitLength(value);
        uint256 k = getBitLength(x) - m - n;

        uint256 mask = ((1 << m) - 1) << k;
        uint256 clear_mask = ~mask;

        return (x & clear_mask) | ((value << k) & mask);
    }

    // helper function
    function getBitLength(uint256 x) public pure returns (uint256) {
        uint256 len = 0;
        while (x > 0) {
            x >>= 1;
            unchecked {
                len++;
            }
        }
        return len;
    }
}
