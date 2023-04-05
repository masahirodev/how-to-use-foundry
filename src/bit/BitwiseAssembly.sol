// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BitwiseAssembly {
    // x & y
    function and(uint256 x, uint256 y) external pure returns (uint256 result) {
        assembly {
            result := and(x, y)
        }
        return result;
    }

    // x | y
    function or(uint256 x, uint256 y) external pure returns (uint256 result) {
        assembly {
            result := or(x, y)
        }
    }

    // x ^ y
    function xor(uint256 x, uint256 y) external pure returns (uint256 result) {
        assembly {
            result := xor(x, y)
        }
    }

    // ~x
    function not(uint256 x) external pure returns (uint256 result) {
        assembly {
            result := not(x)
        }
    }

    // x << bits
    function shiftLeft(uint256 x, uint256 bits) external pure returns (uint256 result) {
        assembly {
            result := shl(bits, x)
        }
    }

    // x >> bits
    function shiftRight(uint256 x, uint256 bits) external pure returns (uint256 result) {
        assembly {
            result := shr(bits, x)
        }
    }

    // Get first n bits from x
    function getFirstNBits(uint256 x, uint256 n) external pure returns (uint256 result) {
        uint256 len = getBitLength(x);
        assembly {
            result := shr(sub(len, n), x)
        }
    }

    // Get first n bits from x
    function getFirstNBitsCallAssembly(uint256 x, uint256 n) external returns (uint256 result) {
        address addr = address(this);
        bytes4 sign = bytes4(keccak256("getBitLength(uint256)"));

        assembly {
            let freePointer := mload(0x40)
            mstore(freePointer, sign)

            // Set arg
            mstore(add(freePointer, 0x04), x)

            // Attention GasLimits
            let success := call(100000, addr, 0, freePointer, 0x24, freePointer, 0x20)
            let len := mload(freePointer)

            result := shr(sub(len, n), x)
        }
    }

    // Set value to first of x
    function setFirstBits(uint256 x, uint256 value) external pure returns (uint256 result) {
        uint256 n = getBitLength(x) - getBitLength(value);
        assembly {
            let mask := sub(shl(n, 1), 1)
            result := or(and(x, mask), shl(n, value))
        }
    }

    // Get last n bits from x
    // n Arithmetic over/underflow --> uint8
    function getLastNBits(uint256 x, uint256 n) external pure returns (uint256 result) {
        assembly {
            let mask := sub(shl(n, 1), 1)
            result := and(x, mask)
        }
    }

    // Set value to last of x
    function setLastBits(uint256 x, uint256 value) external pure returns (uint256 result) {
        uint256 n = getBitLength(value);
        assembly {
            let mask := sub(shl(n, 1), 1)
            result := and(x, not(mask))
            result := or(result, value)
        }
    }

    // Get from n bits to n + m bits in x
    function getBitsInRange(uint256 x, uint256 n, uint256 m) external pure returns (uint256 result) {
        uint256 k = getBitLength(x) - n;
        assembly {
            let mask := sub(shl(k, 1), 1)
            result := and(x, mask)
            result := shr(sub(k, m), result)
        }
    }

    // Set from n bits to n + m bits in x
    function setBitsInRange(uint256 x, uint256 n, uint256 value) external pure returns (uint256 result) {
        uint256 m = getBitLength(value);
        uint256 k = getBitLength(x) - m - n;

        assembly {
            let mask := shl(k, sub(shl(m, 1), 1))
            let right := and(shl(k, value), mask)

            result := and(x, not(mask))
            result := or(result, right)
        }
    }

    // helper function
    function getBitLength(uint256 x) public pure returns (uint256 i) {
        assembly {
            i := 0
            for {} gt(x, 0) {} {
                x := shr(1, x)
                i := add(i, 1)
            }
        }
    }

    function getBitLengthCallAssembly(uint256 x) public returns (uint256 i) {
        address addr = address(this);
        bytes4 sign = bytes4(keccak256("getBitLength(uint256)"));

        assembly {
            let freePointer := mload(0x40)
            mstore(freePointer, sign)

            // set arg
            mstore(add(freePointer, 0x04), x)

            // Attention GasLimits
            let result := call(100000, addr, 0, freePointer, 0x24, freePointer, 0x20)
            i := mload(freePointer)
        }
    }
}
