// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract PackingStorageAssembly {
    uint128 public storageD = 10;
    uint64 public storageE = 20;
    uint64 public storageF = 30;

    /*
    | uint64   | uint64   | uint128  |
    | storageF | storageE | storageD |
    | 00...030 | 00...020 | 00...010 |
    */

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

    function getSlotStorageD() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageD.slot
        }
    }

    function getSlotStorageE() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageE.slot
        }
    }

    function getSlotStorageF() public pure returns (uint256 _slot) {
        assembly {
            _slot := storageF.slot
        }
    }

    function getStorageValuePacking(uint256 slot, uint256 key) public view returns (uint256 value) {
        assembly {
            value := sload(slot)

            switch key
            case 0 {
                let mask := sub(shl(128, 1), 1)
                value := and(value, mask)
            }
            case 1 {
                value := shr(128, value)
                let mask := sub(shl(64, 1), 1)
                value := and(value, mask)
            }
            case 2 {
                value := shr(192, value)
                let mask := sub(shl(64, 1), 1)
                value := and(value, mask)
            }
            default {}
        }
    }

    function getStorageValuePackingPractical(uint256 slot) public view returns (uint128 d, uint64 e, uint64 f) {
        assembly {
            let value := sload(slot)
            d := value
            e := shr(128, value)
            f := shr(192, value)
        }
    }

    function setStorageValuePacking(uint256 slot, uint256 key, uint256 value) public {
        assembly {
            let result := sload(slot)

            switch key
            case 0 {
                let mask := sub(shl(128, 1), 1)
                result := and(result, not(mask))
                result := or(result, value)
            }
            case 1 {
                let mask := shl(128, sub(shl(64, 1), 1))
                value := and(shl(128, value), mask)

                result := and(result, not(mask))
                result := or(result, value)
            }
            case 2 {
                let mask := sub(shl(192, 1), 1)
                result := or(and(result, mask), shl(192, value))
            }
            default { result := value }
            sstore(slot, result)
        }
    }
}
