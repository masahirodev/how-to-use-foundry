// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/bit/Bitwise.sol";
import "contracts/bit/BitwiseAssembly.sol";

// forge test --match-contract BitwiseAssemblyTest --match-test testBitwiseAssemblyAnd -vvvvv --gas-report

contract BitwiseAssemblyTest is Test {
    Bitwise public bitwise;
    BitwiseAssembly public bitwiseAssembly;

    function setUp() public {
        bitwise = new Bitwise();
        bitwiseAssembly = new BitwiseAssembly();
    }

    function testBitwiseAssemblyAnd(uint256 x, uint256 y) public {
        assertEq(bitwise.and(x, y), bitwiseAssembly.and(x, y));
    }

    function testBitwiseAssemblyOr(uint256 x, uint256 y) public {
        assertEq(bitwise.or(x, y), bitwiseAssembly.or(x, y));
    }

    function testBitwiseAssemblyXor(uint256 x, uint256 y) public {
        assertEq(bitwise.xor(x, y), bitwiseAssembly.xor(x, y));
    }

    function testBitwiseAssemblyNot(uint256 x) public {
        assertEq(bitwise.not(x), bitwiseAssembly.not(x));
    }

    function testBitwiseAssemblyShiftLeft(uint256 x, uint256 bits) public {
        assertEq(bitwise.shiftLeft(x, bits), bitwiseAssembly.shiftLeft(x, bits));
    }

    function testBitwiseAssemblyShiftRight(uint256 x, uint256 bits) public {
        assertEq(bitwise.shiftRight(x, bits), bitwiseAssembly.shiftRight(x, bits));
    }

    // Get first n bits from x
    function testBitwiseAssemblyGetFirstNBits() public {
        uint256 x = 10;
        uint256 n = 3;
        uint256 result = 5;

        assertEq(bitwiseAssembly.getFirstNBits(x, n), result);
    }

    function testBitwiseAssemblyGetFirstNBitsFuzz(uint256 x, uint256 n) public {
        uint256 len = getBitLength(x);
        vm.assume(n < len);

        assertEq(bitwise.getFirstNBits(x, n), bitwiseAssembly.getFirstNBits(x, n));
    }

    function testBitwiseAssemblyGetFirstNBitsCallAssemblyFuzz(uint256 x, uint256 n) public {
        uint256 len = getBitLength(x);
        vm.assume(n < len);

        assertEq(bitwiseAssembly.getFirstNBits(x, n), bitwiseAssembly.getFirstNBitsCallAssembly(x, n));
    }

    // Set value to first of x
    function testBitwiseAssemblySetFirstBitsFuzz(uint256 x, uint256 value) public {
        uint256 lenX = getBitLength(x);
        uint256 lenValue = getBitLength(value);
        vm.assume(lenX >= lenValue);
        vm.assume(lenX < 256);

        assertEq(bitwise.setFirstBits(x, value), bitwiseAssembly.setFirstBits(x, value));
    }

    // Get last n bits from x
    function testBitwiseAssemblyGetLastNBitsFuzz(uint256 x, uint256 n) public {
        vm.assume(n < 256);
        assertEq(bitwise.getLastNBits(x, n), bitwiseAssembly.getLastNBits(x, n));
    }

    // Set value to last of x
    function testBitwiseAssemblySetLastBits() public {
        uint256 x = 181;
        uint256 value = 10;
        uint256 result = 186;

        assertEq(bitwise.setLastBits(x, value), result);
        assertEq(bitwiseAssembly.setLastBits(x, value), result);
    }

    // Set value to last of x
    function testBitwiseAssemblySetLastBitsFuzz(uint256 x, uint256 value) public {
        uint256 lenX = getBitLength(x);
        uint256 lenValue = getBitLength(value);
        vm.assume(lenX >= lenValue);
        vm.assume(lenX < 256);

        assertEq(bitwise.setLastBits(x, value), bitwiseAssembly.setLastBits(x, value));
    }

    // Get from n bits to n + m bits in x
    function testBitwiseAssemblyGetBitsInRange() public {
        uint256 x = 1002;
        uint256 n = 4;
        uint256 m = 3;
        uint256 result = 5;

        assertEq(bitwiseAssembly.getBitsInRange(x, n, m), result);
    }

    function testBitwiseAssemblyGetBitsInRangeFuzz(uint256 x, uint256 n, uint256 m) public {
        uint256 lenX = getBitLength(x);

        vm.assume(lenX < 256);
        vm.assume(n < lenX && m < lenX);
        vm.assume(n + m < lenX);

        assertEq(bitwise.getBitsInRange(x, n, m), bitwiseAssembly.getBitsInRange(x, n, m));
    }

    // Set from n bits to n + m bits in x
    function testBitwiseAssemblySetBitsInRange() public {
        uint256 x = 1002;
        uint256 n = 3;
        uint256 value = 8;

        uint256 result = bitwiseAssembly.setBitsInRange(x, n, value);

        uint256 len = getBitLength(value);
        assertEq(bitwiseAssembly.getBitsInRange(result, n, len), value);
    }

    function testBitwiseAssemblySetBitsInRangeFuzz(uint256 x, uint256 n, uint256 value) public {
        uint256 lenX = getBitLength(x);
        uint256 lenValue = getBitLength(value);

        vm.assume(lenX < 256);
        vm.assume(n < lenX && lenValue <= lenX);
        vm.assume(n + lenValue <= lenX);

        assertEq(bitwise.setBitsInRange(x, n, value), bitwiseAssembly.setBitsInRange(x, n, value));
    }

    // Get Bit Length (helper function)
    function testBitwiseAssemblyGetBitLengthFuzz(uint256 x) public {
        assertEq(bitwise.getBitLength(x), bitwiseAssembly.getBitLength(x));
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

    function testGetBitLengthCallAssembly(uint256 x) public {
        assertEq(bitwiseAssembly.getBitLengthCallAssembly(x), bitwiseAssembly.getBitLength(x));
    }
}
