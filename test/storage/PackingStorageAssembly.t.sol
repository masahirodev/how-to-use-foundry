// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/storage/PackingStorageAssembly.sol";

// forge test --match-contract PackingStorageAssemblyTest --match-test testGetSlotPacking -vvvvv --gas-report
// forge inspect PackingStorageAssembly storage-layout --pretty

contract PackingStorageAssemblyTest is Test {
    using stdStorage for StdStorage;

    PackingStorageAssembly public storageAssembly;

    function setUp() public {
        storageAssembly = new PackingStorageAssembly();
    }

    function testGetSlotPacking() public {
        uint256 slot = 0;
        assertEq(storageAssembly.getSlotStorageD(), slot);
        assertEq(storageAssembly.getSlotStorageE(), slot);
        assertEq(storageAssembly.getSlotStorageF(), slot);
    }

    function testGetStorageValuePacking() public {
        uint256 slot = 0;
        assertEq(storageAssembly.getStorageValuePacking(slot, 0), 10);
        assertEq(storageAssembly.getStorageValuePacking(slot, 1), 20);
        assertEq(storageAssembly.getStorageValuePacking(slot, 2), 30);

        uint256 value = uint256(30) << 192 | uint256(20) << 128 | uint256(10);
        assertEq(storageAssembly.getStorageValue(slot), value);
        assertEq(storageAssembly.getStorageValuePacking(slot, 3), value);
    }

    function testGetStorageValuePackingPractical() public {
        uint256 slot = 0;
        (uint128 d, uint64 e, uint64 f) = storageAssembly.getStorageValuePackingPractical(slot);
        assertEq(d, 10);
        assertEq(e, 20);
        assertEq(f, 30);
    }

    function testSetStorageValuePacking(uint128 D, uint64 E, uint64 F) public {
        uint256 slot = 3;
        storageAssembly.setStorageValuePacking(slot, 0, D);
        assertEq(storageAssembly.getStorageValuePacking(slot, 0), D);

        storageAssembly.setStorageValuePacking(slot, 1, E);
        assertEq(storageAssembly.getStorageValuePacking(slot, 1), E);

        storageAssembly.setStorageValuePacking(slot, 2, F);
        assertEq(storageAssembly.getStorageValuePacking(slot, 2), F);
    }

    function testSetStorageValuePackingFuzz(uint128 D, uint64 E, uint64 F) public {
        uint256 slot = 3;
        uint256 value = uint256(F) << 192 | uint256(E) << 128 | uint256(D);
        storageAssembly.setStorageValue(3, value);

        assertEq(storageAssembly.getStorageValue(slot), value);
        assertEq(storageAssembly.getStorageValuePacking(slot, 3), value);

        assertEq(storageAssembly.getStorageValuePacking(slot, 0), D);
        assertEq(storageAssembly.getStorageValuePacking(slot, 1), E);
        assertEq(storageAssembly.getStorageValuePacking(slot, 2), F);
    }

    /*///////////////////////////////////////////////////////////////////////
    //                   sample forge test for mapping                     //
    ////////////////////////////////////////////////////////////////////// */

    // forge attention
    // Accessing packed slots is not supported
    // Slot(s) may not be found if the tuple contains types shorter than 32 bytes

    // read value
    function testReadPackingStorageValueForge() public {
        uint256 slot = 0;
        uint256 pack1 = storageAssembly.storageD();
        uint256 pack2 = storageAssembly.storageE();
        uint256 pack3 = storageAssembly.storageF();
        uint256 value = pack3 << 192 | pack2 << 128 | pack1;

        bytes32 data = vm.load(address(storageAssembly), bytes32(uint256(slot)));
        assertEq(uint256(data), value);
    }

    // wtite value
    function testWritePackingStorageValueForge(uint256 value1, uint256 value2, uint256 value3) public {
        uint256 slot = 0;
        uint256 pack1 = storageAssembly.storageD();
        uint256 pack2 = storageAssembly.storageE();
        uint256 pack3 = storageAssembly.storageF();

        // storageD = uint128
        pack1 = uint128(value1);

        // storageE,F = uint64
        pack2 = uint64(value2);
        pack3 = uint64(value3);

        uint256 updateValue = pack3 << 192 | pack2 << 128 | pack1;

        vm.store(address(storageAssembly), bytes32(uint256(slot)), bytes32(uint256(updateValue)));

        assertEq(pack1, storageAssembly.storageD());
        assertEq(pack2, storageAssembly.storageE());
        assertEq(pack3, storageAssembly.storageF());
    }
}
