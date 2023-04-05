// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/bit/Bitflag.sol";

// forge test --match-contract BitFlagTest --match-test testConstructor -vvvvv --gas-report

contract BitFlagTest is Test {
    BitFlag public bitFlag;

    function setUp() public {
        bitFlag = new BitFlag();
    }

    function testConstructor() public {
        assertEq(bitFlag.bitFlag(), 0);
    }

    function testSetBitFlag(uint256 _bitFlag) public {
        bitFlag.setBitFlag(_bitFlag);
        assertEq(bitFlag.bitFlag(), _bitFlag);
    }

    // Set N bit flag
    function testSetNBitFlag() public {
        uint256 n = 1;
        bitFlag.setNBitFlag(n);
        assertEq(bitFlag.checkNBitFlag(n), 1);

        // 33 = 100001
        bitFlag.setBitFlag(33);
        assertEq(bitFlag.checkNBitFlag(2), 0);
        assertEq(bitFlag.checkNBitFlag(3), 0);
        assertEq(bitFlag.checkNBitFlag(4), 0);

        n = 3;
        // 100001 --> 101001 = 41
        bitFlag.setNBitFlag(n);
        assertEq(bitFlag.checkNBitFlag(2), 0);
        assertEq(bitFlag.checkNBitFlag(3), 1);
        assertEq(bitFlag.checkNBitFlag(4), 0);
        assertEq(bitFlag.bitFlag(), 41);
    }

    function testSetNBitFlagFuzz(uint256 n) public {
        vm.assume(n < 256);
        bitFlag.setNBitFlag(n);
        assertEq(bitFlag.checkNBitFlag(n), 1);
    }

    // Clear N bit flag
    function testClearNBitFlag() public {
        // 41 = 101001
        bitFlag.setBitFlag(41);
        assertEq(bitFlag.checkNBitFlag(2), 0);
        assertEq(bitFlag.checkNBitFlag(3), 1);
        assertEq(bitFlag.checkNBitFlag(4), 0);

        uint256 n = 3;
        // 101001 --> 100001 = 33
        bitFlag.clearNBitFlag(n);
        assertEq(bitFlag.checkNBitFlag(2), 0);
        assertEq(bitFlag.checkNBitFlag(3), 0);
        assertEq(bitFlag.checkNBitFlag(4), 0);
        assertEq(bitFlag.bitFlag(), 33);
    }

    function testClearNBitFlagFuzz(uint256 n) public {
        vm.assume(n < 256);
        bitFlag.clearNBitFlag(n);
        assertEq(bitFlag.checkNBitFlag(n), 0);
    }

    // Check N bit flag
    function testCheckNBitFlag() public {
        // 1011
        bitFlag.setBitFlag(11);
        assertEq(bitFlag.checkNBitFlag(0), 1);
        assertEq(bitFlag.checkNBitFlag(1), 1);
        assertEq(bitFlag.checkNBitFlag(2), 0);
        assertEq(bitFlag.checkNBitFlag(3), 1);
    }

    // Check N bit flag boolean
    function testCheckNBitFlagBool() public {
        // 0101
        bitFlag.setBitFlag(5);
        assertEq(bitFlag.checkNBitFlagBool(0), true);
        assertEq(bitFlag.checkNBitFlagBool(1), false);
        assertEq(bitFlag.checkNBitFlagBool(2), true);
        assertEq(bitFlag.checkNBitFlagBool(3), false);
    }

    function testCountBitFlag() public {
        // 11 = 1011
        assertEq(bitFlag.countBitFlag(11), 3);

        // 5 = 0101
        assertEq(bitFlag.countBitFlag(5), 2);

        // 33 = 100001
        assertEq(bitFlag.countBitFlag(33), 2);
    }
}
