// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/storage/StructStorageAssembly.sol";

// forge test --match-contract StructStorageAssemblyTest --match-test testGetMappingStructStorageAssembly -vvvvv --gas-report
// forge inspect StructStorageAssembly storage-layout --pretty

contract StructStorageAssemblyTest is Test {
    using stdStorage for StdStorage;

    StructStorageAssembly public storageAssembly;

    function setUp() public {
        storageAssembly = new StructStorageAssembly();
    }

    function testSetGetMappingStructStorage(uint256 key, uint128 h, uint64 i, uint64 j, uint64 k) public {
        storageAssembly.setMappingStructStorage(key, h, i, j, k);

        (uint128 valueH, uint64 valueI, uint64 valueJ, uint64 valueK) = storageAssembly.getMappingStructStorage(key);

        assertEq(h, valueH);
        assertEq(i, valueI);
        assertEq(j, valueJ);
        assertEq(k, valueK);
    }

    // if you want to test index=0 you need to change the return type
    function testGetMappingStructStorageAssembly() public {
        storageAssembly.setMappingStructStorage(1, 2, 3, 4, 5);
        assertEq(storageAssembly.getMappingStructStorageAssembly(1, 1), 3);
        assertEq(storageAssembly.getMappingStructStorageAssembly(1, 2), 4);
        assertEq(storageAssembly.getMappingStructStorageAssembly(1, 3), 5);
    }

    // if you want to test index=0 you need to change the return type
    function testGetMappingStructStorageAssemblyFuzz(uint256 key, uint128 h, uint64 i, uint64 j, uint64 k) public {
        storageAssembly.setMappingStructStorage(key, h, i, j, k);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 1), i);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 2), j);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 3), k);
    }

    function testGetMappingStructStorageAssemblyOtherSlotMethodFuzz(
        uint256 key,
        uint128 h,
        uint64 i,
        uint64 j,
        uint64 k
    ) public {
        storageAssembly.setMappingStructStorage(key, h, i, j, k);
        (uint128 valueH, uint64 valueI, uint64 valueJ, uint64 valueK) =
            storageAssembly.getMappingStructStorageAssemblyOtherSlotMethod(key);

        assertEq(h, valueH);
        assertEq(i, valueI);
        assertEq(j, valueJ);
        assertEq(k, valueK);
    }

    // if you want to test index=0 you need to change the return type
    function testSetMappingStructStorageAssemblyFuzz(uint256 key, uint128 h, uint64 i, uint64 j, uint64 k) public {
        storageAssembly.setMappingStructStorage(key, h, i, j, k);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 1), i);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 2), j);
        assertEq(storageAssembly.getMappingStructStorageAssembly(key, 3), k);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                   sample forge test for mapping                     //
    ////////////////////////////////////////////////////////////////////// */

    // forge attention
    // Accessing packed slots is not supported
    // Slot(s) may not be found if the tuple contains types shorter than 32 bytes

    // read value Struct Mapping
    function testReadMappingStorageValueForgeStdStorage(uint256 key, uint256 valueX, uint256 valueY) public {
        // init
        storageAssembly.setMappingStructStorageFoundry(key, valueX, valueY);

        // X depth 0
        uint256 slotX = stdstore.target(address(storageAssembly)).sig(
            storageAssembly.mappingStructStoragesFoundry.selector
        ).with_key(key).depth(0).find();

        uint256 x = uint256(vm.load(address(storageAssembly), bytes32(uint256(slotX))));

        // Y depth 1
        uint256 y = stdstore.target(address(storageAssembly)).sig(storageAssembly.mappingStructStoragesFoundry.selector)
            .with_key(key).depth(1).read_uint();

        assertEq(x, valueX);
        assertEq(y, valueY);
    }

    // wtite value Mapping
    function testWriteMappingStorageValueForgeStdStorage(uint256 key, uint256 valueX, uint256 valueY) public {
        // X depth 0
        stdstore.target(address(storageAssembly)).sig(storageAssembly.mappingStructStoragesFoundry.selector).with_key(
            key
        ).depth(0).checked_write(valueX);

        // Y depth 1
        stdstore.target(address(storageAssembly)).sig(storageAssembly.mappingStructStoragesFoundry.selector).with_key(
            key
        ).depth(1).checked_write(valueY);

        (uint256 x, uint256 y) = storageAssembly.getMappingStructStorageFoundry(key);

        assertEq(x, valueX);
        assertEq(y, valueY);
    }
}
