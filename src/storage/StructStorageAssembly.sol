// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract StructStorageAssembly {
    struct StructStorage {
        uint128 storageH;
        uint64 storageI;
        uint64 storageJ;
        uint64 storageK;
    }

    mapping(uint256 => StructStorage) public mappingStructStorages;

    /*
    Slot α + 1
    | uint64   | uint64   | uint128  |
    | storageJ | storageI | storageH |
    | 00...030 | 00...020 | 00...010 |

    Slot α + 2
    | uint64   |
    | storageK |
    | 00...030 |
    */

    function setMappingStructStorage(uint256 key, uint128 valueH, uint64 valueI, uint64 valueJ, uint64 valueK) public {
        mappingStructStorages[key].storageH = valueH;
        mappingStructStorages[key].storageI = valueI;
        mappingStructStorages[key].storageJ = valueJ;
        mappingStructStorages[key].storageK = valueK;
    }

    function getMappingStructStorage(uint256 key)
        public
        view
        returns (uint128 valueH, uint64 valueI, uint64 valueJ, uint64 valueK)
    {
        valueH = mappingStructStorages[key].storageH;
        valueI = mappingStructStorages[key].storageI;
        valueJ = mappingStructStorages[key].storageJ;
        valueK = mappingStructStorages[key].storageK;
    }

    // if you want to test index=0 you need to change the return type
    function getMappingStructStorageAssembly(uint256 key, uint256 index) public view returns (uint64 result) {
        uint128 h;
        uint64 i;
        uint64 j;
        uint64 k;

        assembly {
            mstore(0x00, key)
            mstore(0x20, mappingStructStorages.slot)
            let slot := keccak256(0, 0x40)

            let value := sload(slot)

            h := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            i := shr(128, value)
            j := shr(192, value)

            value := sload(add(slot, 1))
            k := value

            switch index
            case 1 { result := i }
            case 2 { result := j }
            case 3 { result := k }
            default { result := 0 }
        }
    }

    function getMappingStructStorageAssemblyOtherSlotMethod(uint256 key)
        public
        view
        returns (uint128 h, uint64 i, uint64 j, uint64 k)
    {
        StructStorage storage mappingStructStorage = mappingStructStorages[key];

        assembly {
            let slot := mappingStructStorage.slot
            let value := sload(slot)

            h := and(value, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            i := shr(128, value)
            j := shr(192, value)

            value := sload(add(slot, 1))
            k := value
        }
    }

    function setMappingStructStorageAssembly(uint256 key, uint128 h, uint64 i, uint64 j, uint64 k) public {
        StructStorage storage mappingStructStorage = mappingStructStorages[key];

        assembly {
            let slot := mappingStructStorage.slot
            let value := or(or(shl(192, j), shl(128, i)), h)
            sstore(slot, value)
            value := k
            sstore(add(slot, 1), value)
        }
    }

    /*///////////////////////////////////////////////////////////////////////
    //                   sample forge test for mapping                     //
    ////////////////////////////////////////////////////////////////////// */

    struct StructStorageFoundry {
        uint256 storageX;
        uint256 storageY;
    }

    mapping(uint256 => StructStorageFoundry) public mappingStructStoragesFoundry;

    function setMappingStructStorageFoundry(uint256 key, uint256 valueX, uint256 valueY) public {
        mappingStructStoragesFoundry[key].storageX = valueX;
        mappingStructStoragesFoundry[key].storageY = valueY;
    }

    function getMappingStructStorageFoundry(uint256 key) public view returns (uint256 valueX, uint256 valueY) {
        valueX = mappingStructStoragesFoundry[key].storageX;
        valueY = mappingStructStoragesFoundry[key].storageY;
    }
}
