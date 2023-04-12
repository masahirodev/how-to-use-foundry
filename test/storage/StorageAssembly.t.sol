// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/storage/StorageAssmebly.sol";

// forge test --match-contract StorageAssemblyTest --match-test testGetSlot -vvvvv --gas-report
// forge inspect StorageAssembly storage-layout --pretty

contract StorageAssemblyTest is Test {
    using stdStorage for StdStorage;

    StorageAssembly public storageAssembly;

    function setUp() public {
        storageAssembly = new StorageAssembly();
    }

    function testGetSlot() public {
        assertEq(storageAssembly.getSlotStorageA(), 0);
        assertEq(storageAssembly.getSlotStorageB(), 1);
        assertEq(storageAssembly.getSlotStorageC(), 2);
    }

    function testGetStorageValue() public {
        assertEq(storageAssembly.getStorageValue(0), 1);
        assertEq(storageAssembly.getStorageValue(1), 2);
        assertEq(storageAssembly.getStorageValue(2), 3);
    }

    function testSetStorageValue(uint256 valueA, uint256 valueB, uint256 valueC) public {
        storageAssembly.setStorageValue(0, valueA);
        assertEq(storageAssembly.storageA(), valueA);
        assertEq(storageAssembly.getStorageValue(0), valueA);

        storageAssembly.setStorageValue(1, valueB);
        assertEq(storageAssembly.storageB(), valueB);
        assertEq(storageAssembly.getStorageValue(1), valueB);

        storageAssembly.setStorageValue(2, valueC);
        assertEq(storageAssembly.storageC(), valueC);
        assertEq(storageAssembly.getStorageValue(2), valueC);
    }

    function testSetStorageValueFuzz(uint256 slot, uint256 value) public {
        storageAssembly.setStorageValue(slot, value);
        assertEq(storageAssembly.getStorageValue(slot), value);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                 　　　　　　sample forge test　　                      //
    ////////////////////////////////////////////////////////////////////// */

    // find slot
    function testGetSlotForgeStdStorage() public {
        uint256 slot = stdstore.target(address(storageAssembly)).sig("storageA()").find();
        assertEq(slot, storageAssembly.getSlotStorageA());
    }

    // read value
    function testReadStorageValueForgeStdStorage() public {
        uint256 value = stdstore.target(address(storageAssembly)).sig("storageA()").read_uint();
        assertEq(value, storageAssembly.storageA());
    }

    // wtite value
    function testWriteStorageValueForgeStdStorage(uint256 value) public {
        stdstore.target(address(storageAssembly)).sig("storageA()").checked_write(value);
        assertEq(value, storageAssembly.storageA());
    }
}
