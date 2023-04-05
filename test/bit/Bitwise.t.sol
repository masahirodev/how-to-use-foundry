// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/bit/Bitwise.sol";

// forge test --match-contract BitwiseTest --match-test testBitwiseAnd -vvvvv --gas-report

// @Attention
// check Arithmetic over/underflow
contract BitwiseTest is Test {
    Bitwise public bitwise;

    function setUp() public {
        bitwise = new Bitwise();
    }

    // and
    function testBitwiseAnd() public {
        uint256 x = 10;
        uint256 y = 13;
        uint256 result = 8;

        // x = 10 = 1010
        // y = 13 = 1101
        // x & y  = 1000 = 8
        assertEq(bitwise.and(x, y), result);
    }

    // or
    function testBitwiseOr() public {
        uint256 x = 10;
        uint256 y = 13;
        uint256 result = 15;

        // x = 10 = 1010
        // y = 13 = 1101
        // x | y  = 1111 = 15
        assertEq(bitwise.or(x, y), result);
    }

    // xor
    function testBitwiseXor() public {
        uint256 x = 10;
        uint256 y = 13;
        uint256 result = 7;

        // x = 10 = 1010
        // y = 13 = 1101
        // x ^ y  = 0111 = 7
        assertEq(bitwise.xor(x, y), result);
    }

    // not
    function testBitwiseNot() public {
        uint256 x = 10;
        uint256 result = 5;

        // x = 10 =      1010
        // ~x     = ...110101
        uint256 d = bitwise.not(x);

        // 1 << 4     =     10000
        // 1 << 3 - 1 =     01111 = mask
        // ~x         = ...110101
        // ~x & mask  =     00101 = 5
        assertEq(bitwise.getLastNBits(d, 4), result);
    }

    // shiftLeft
    function testBitwiseShiftLeft() public {
        uint256 x = 10;
        uint256 bits = 3;
        uint256 result = 80;

        // x = 10 = 1010
        // x << 3 = 1010000 = 80
        assertEq(bitwise.shiftLeft(x, bits), result);
    }

    // shiftRight
    function testBitwiseShiftRight() public {
        uint256 x = 10;
        uint256 bits = 1;
        uint256 result = 5;

        // x = 10 = 1010
        // x >> 1 =  101 = 5
        assertEq(bitwise.shiftRight(x, bits), result);
    }

    // Get first n bits from x
    function testBitwiseGetFirstNBits() public {
        uint256 x = 10;
        uint256 n = 3;
        uint256 result = 5;

        // len = 4
        // len - n = 1 = right

        // x = 10     = 1010
        // x >> right =  101
        assertEq(bitwise.getFirstNBits(x, n), result);
    }

    //  Set value to first of x
    function testBitwiseSetFirstBits() public {
        uint256 x = 190;
        uint256 value = 7;

        // x = 190 = 10111110
        // value = 7 = 111
        // n = 8 - 3 = 5

        // 1 << 5             =   100000
        // (1 << 5) - 1       =   011111 = mask
        // x = 190            = 10111110
        // x & mask           =   011110 = left

        // value = 7          = 111
        // value << 5         = 11100000 = right

        // left         =   011110
        // right        = 11100000
        // left | right = 11111110
        uint256 result = bitwise.setFirstBits(x, value);
        assertEq(result, 254);

        uint256 len = getBitLength(value);
        assertEq(bitwise.getFirstNBits(result, len), value);
    }

    // Get last n bits from x
    function testBitwiseGetLastNBits() public {
        uint256 x = 10;
        uint256 n = 3;
        uint256 result = 2;

        // 1 << 3     = 1000
        // 1 << 3 - 1 = 0111 = mask
        // x          = 1010
        // x & mask   = 0010 = 2
        assertEq(bitwise.getLastNBits(x, n), result);
    }

    // Set value to last of x
    function testBitwiseSetLastBits() public {
        uint256 x = 29;
        uint256 value = 7;

        // value = 7                =       111
        // n = 3

        // 1 << n                   =      1000
        // mask = (1 << n) - 1      =      0111
        // clear_mask = ~mask       = ..1111000

        // x = 29                   =     11101
        // clear_mask               = ..1111000
        // x & clear_mask           =     11000
        // value = 7                =       111
        // (x & clear_mask) | value =     11111 = 31
        uint256 result = bitwise.setLastBits(x, value);

        uint256 len = getBitLength(value);
        assertEq(bitwise.getLastNBits(result, len), value);
    }

    // Get from n bits to n + m bits in x
    function testBitwiseGetBitsInRange() public {
        uint256 x = 1002;
        uint256 n = 4;
        uint256 m = 3;
        uint256 result = 5;

        // x = 1002 = 1111101010
        // k = 10 - 4 = 6

        // 1 << k       = 1000000
        // (1 << k) - 1 = 0111111 = mask

        // x                 = 1111101010
        // mask              =    0111111
        // x & mask          =    0101010
        // x & mask >> 3     =    0101    = 5
        assertEq(bitwise.getBitsInRange(x, n, m), result);
    }

    // Set from n bits to n + m bits in x
    function testBitwiseSetBitsInRange() public {
        uint256 x = 1002;
        uint256 n = 3;
        uint256 value = 8;

        // value = 8 = 1000
        // m = 4

        // x = 1002  = 1111101010
        // k = 10 - 4 - 3 = 3

        // 1 << m            =     10000
        // (1 << m) - 1      =     01111
        // (1 << m) - 1 << 3 =     01111000 = mask
        // ~mask             = ...110000111 = clear_mask

        // x                 =   1111101010
        // clear_mask        = ...110000111
        // x & clear_mask    =   1110000010 = left

        // value = 8           =     1000
        // value << k          =     1000000
        // mask                =    01111000
        // (value << 3) & mask =     1000000 = right

        // left         =   1110000010
        // right        =      1000000
        // left | right =   1111000010 = 962
        uint256 result = bitwise.setBitsInRange(x, n, value);

        uint256 len = getBitLength(value);
        assertEq(bitwise.getBitsInRange(result, n, len), value);
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
