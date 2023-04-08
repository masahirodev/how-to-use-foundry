// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/storage/MappingStorageAssembly.sol";

// forge test --match-contract MappingStorageAssemblyTest --match-test testGetMappingStructStorageAssembly -vvvvv --gas-report
// forge inspect MappingStorageAssembly storage-layout --pretty

contract MappingStorageAssemblyTest is Test {
    using stdStorage for StdStorage;

    MappingStorageAssembly public storageAssembly;

    function setUp() public {
        storageAssembly = new MappingStorageAssembly();
    }

    function testGetMappingStorageAssemblyFuzz(uint256 key, uint256 value) public {
        storageAssembly.setMappingStorage(key, value);
        assertEq(storageAssembly.getMappingStorage(key), value);

        assertEq(storageAssembly.getMappingStorageAssembly(key), value);
    }

    function testSetMappingStorageAssemblyFuzz(uint256 key, uint256 value) public {
        storageAssembly.setMappingStorageAssembly(key, value);
        assertEq(storageAssembly.getMappingStorage(key), value);

        assertEq(storageAssembly.getMappingStorageAssembly(key), value);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                             hash mapping                            //
    ////////////////////////////////////////////////////////////////////// */

    function testGetStorageSlot() public view {
        // 0xaa7b7cd2
        console.logBytes4(storageAssembly.getHashStorageSlot("HASH_STORAGE"));
    }

    function testSetHashStorageAssembly() public {
        bytes4 slot = 0xaa7b7cd2;
        uint256 key = 1;
        uint256 value = 10;
        storageAssembly.setHashStorageAssembly(slot, key, value);

        assertEq(storageAssembly.getHashStorageAssembly(slot, key), value);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                           double mapping                            //
    ////////////////////////////////////////////////////////////////////// */

    function testGetMappingStorageAssemblyFuzz(uint256 keyA, uint256 keyB, uint256 value) public {
        storageAssembly.setDoubleMapping(keyA, keyB, value);
        assertEq(storageAssembly.getDoubleMapping(keyA, keyB), value);

        assertEq(storageAssembly.getDoubleMappingAssembly(keyA, keyB), value);
    }

    function testSetMappingStorageAssemblyFuzz(uint256 keyA, uint256 keyB, uint256 value) public {
        storageAssembly.setDoubleMappingAssembly(keyA, keyB, value);
        assertEq(storageAssembly.getDoubleMapping(keyA, keyB), value);

        assertEq(storageAssembly.getDoubleMappingAssembly(keyA, keyB), value);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                   sample forge test for mapping                     //
    ////////////////////////////////////////////////////////////////////// */

    // read value Mapping
    function testReadMappingStorageValueForgeStdStorage(uint256 key, uint256 value) public {
        // init
        storageAssembly.setMappingStorage(key, value);

        uint256 read_value =
            stdstore.target(address(storageAssembly)).sig("mappingStorage(uint256)").with_key(key).read_uint();
        assertEq(read_value, storageAssembly.getMappingStorage(key));
    }

    // wtite value Mapping
    function testWriteStorageValueForgeStdStorage(uint256 key, uint256 value) public {
        stdstore.target(address(storageAssembly)).sig("mappingStorage(uint256)").with_key(key).checked_write(value);

        assertEq(value, storageAssembly.getMappingStorage(key));
    }

    // read value Double Mapping
    function testReadDoubleMappingStorageValueForgeStdStorage(uint256 keyA, uint256 keyB, uint256 value) public {
        // init
        storageAssembly.setDoubleMapping(keyA, keyB, value);

        uint256 read_value = stdstore.target(address(storageAssembly)).sig(storageAssembly.doubleMapping.selector)
            .with_key(keyA).with_key(keyB).read_uint();
        assertEq(read_value, storageAssembly.getDoubleMapping(keyA, keyB));
    }

    // wtite value Double Mapping
    function testWriteDoubleStorageValueForgeStdStorage(uint256 keyA, uint256 keyB, uint256 value) public {
        stdstore.target(address(storageAssembly)).sig(storageAssembly.doubleMapping.selector).with_key(keyA).with_key(
            keyB
        ).checked_write(value);

        assertEq(value, storageAssembly.getDoubleMapping(keyA, keyB));
    }
}
