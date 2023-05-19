// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "contracts/utils/HandleStringAssembly.sol";

// forge test --match-contract HandleStringAssemblyTest --match-test testSetGetStringStorage -vvvvv --gas-report

contract HandleStringAssemblyTest is Test {
    HandleStringAssembly public testContract;

    constructor() {
        testContract = new HandleStringAssembly();
    }

    function setUp() public {
        // testContract = new Slot();
    }

    function testSetGetStringStorage(string memory str) public {
        testContract.setStringStorage(str);
        assertEq(str, testContract.getStringStorage());
    }

    function testSetStringStorageAssembly(string memory str) public {
        // length < 32
        // vm.assume(bytes(str).length < 32);

        // length >= 32
        // vm.assume(bytes(str).length >= 32;
        // str = "1234567890123456789012345678901234567890";

        testContract.setStringStorageAssembly(str);
        assertEq(str, testContract.getStringStorage());
    }

    function testGetStringStorageAssembly(string memory str) public {
        // length < 32
        // vm.assume(bytes(str).length < 32);

        // length >= 32
        // vm.assume(bytes(str).length >= 32 && bytes(str).length < 64);
        // str = "1234567890123456789012345678901234567890";

        testContract.setStringStorage(str);
        assertEq(str, testContract.getStringStorageAssembly());
    }

    function testSetGetStringStorageVsAssembly(string memory str) public {
        testContract.setStringStorage(str);
        assertEq(str, testContract.getStringStorage());

        testContract.setStringStorage(str);
        assertEq(str, testContract.getStringStorage());

        testContract.setStringStorageAssembly(str);
        assertEq(str, testContract.getStringStorageAssembly());
    }

    /* /////////////////////////////////////////////////////////////////////////////
    mapping(uint256 => string)
    ///////////////////////////////////////////////////////////////////////////// */

    function testSetGetStringMappingStorage(string memory str, uint256 index) public {
        testContract.setStringMappingStorage(str, index);
        assertEq(str, testContract.getStringMappingStorage(index));
    }

    function testSetMappingStorageAssembly(string memory str, uint256 index) public {
        // vm.assume(bytes(str).length < 32);
        testContract.setStringMappingStorageAssembly(str, index);
        assertEq(str, testContract.getStringMappingStorage(index));
    }

    function testGetMappingStorageAssembly(string memory str, uint256 index) public {
        // length < 32
        // vm.assume(bytes(str).length < 32);

        // length >= 32
        // vm.assume(bytes(str).length >= 32 && bytes(str).length < 64);
        // str = "1234567890123456789012345678901234567890";

        testContract.setStringMappingStorage(str, index);
        assertEq(str, testContract.getStringMappingStorageAssembly(index));
    }
}
