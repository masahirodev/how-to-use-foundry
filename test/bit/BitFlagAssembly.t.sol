// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/bit/BitFlag.sol";
import "contracts/bit/BitFlagAssembly.sol";

// forge test --match-contract BitFlagAssemblyTest --match-test testSetBitFlagFuzz -vvvvv --gas-report

contract BitFlagAssemblyTest is Test {
    BitFlag public bitFlag;
    BitFlagAssembly public bitFlagAssembly;

    function setUp() public {
        bitFlag = new BitFlag();
        bitFlagAssembly = new BitFlagAssembly();
    }

    // Set bit flag
    function testSetBitFlagFuzz(uint256 _bitFlag) public {
        bitFlag.setBitFlag(_bitFlag);
        bitFlagAssembly.setBitFlag(_bitFlag);

        assertEq(bitFlag.bitFlag(), bitFlagAssembly.bitFlag());
    }

    // Set N bit flag
    function testBitFlagAssemblySetNBitFlagFuzz(uint256 n) public {
        vm.assume(n < 256);

        bitFlag.setNBitFlag(n);
        bitFlagAssembly.setNBitFlag(n);

        assertEq(bitFlag.bitFlag(), bitFlagAssembly.bitFlag());
    }

    // Clear N bit flag
    function testBitFlagAssemblyClearNBitFlagFuzz(uint256 n) public {
        vm.assume(n < 256);

        bitFlag.clearNBitFlag(n);
        bitFlagAssembly.clearNBitFlag(n);

        assertEq(bitFlag.bitFlag(), bitFlagAssembly.bitFlag());
    }

    // Check N bit flag
    function testBitFlagAssemblyCheckNBitFlagFuzz(uint256 _bitFlag, uint256 n) public {
        vm.assume(n < 256);

        bitFlag.setBitFlag(_bitFlag);
        bitFlagAssembly.setBitFlag(_bitFlag);

        assertEq(bitFlag.checkNBitFlag(n), bitFlagAssembly.checkNBitFlag(n));
    }

    // Check N bit flag boolean
    function testBitFlagAssemblyCheckNBitFlagBoolFuzz(uint256 _bitFlag, uint256 n) public {
        vm.assume(n < 256);

        bitFlag.setBitFlag(_bitFlag);
        bitFlagAssembly.setBitFlag(_bitFlag);

        assertEq(bitFlag.checkNBitFlagBool(n), bitFlagAssembly.checkNBitFlagBool(n));
    }

    // Count bit flag
    function testBitFlagAssemblyCountBitFlagFuzz(uint256 x) public {
        assertEq(bitFlag.countBitFlag(x), bitFlagAssembly.countBitFlag(x));
    }
}
