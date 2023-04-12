// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract StorageAssembly {
    uint256 public storageA = 1; // slot0
    uint256 public storageB = 2; // slot1
    uint256 public storageC = 3; // slot2

    function getSlotStorageA() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageA.slot
        }
    }

    function getSlotStorageB() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageB.slot
        }
    }

    function getSlotStorageC() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageC.slot
        }
    }

    function getStorageValue(uint256 slot) public view returns (uint256 value) {
        assembly {
            value := sload(slot)
        }
    }

    function setStorageValue(uint256 slot, uint256 value) public {
        assembly {
            sstore(slot, value)
        }
    }
}
