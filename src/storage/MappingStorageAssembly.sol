// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract MappingStorageAssembly {
    mapping(uint256 => uint256) public mappingStorage;

    function setMappingStorage(uint256 key, uint256 value) public {
        mappingStorage[key] = value;
    }

    function getMappingStorage(uint256 key) public view returns (uint256) {
        return mappingStorage[key];
    }

    function getMappingStorageAssembly(uint256 key) public view returns (uint256 value) {
        assembly {
            let slot := mappingStorage.slot

            mstore(0, key)
            mstore(32, slot)
            let mappingSlot := keccak256(0, 64)

            value := sload(mappingSlot)
        }
    }

    function setMappingStorageAssembly(uint256 key, uint256 value) public {
        assembly {
            let slot := mappingStorage.slot

            mstore(0x20, slot)
            mstore(0x00, key)
            let mappingSlot := keccak256(0x00, 0x40)

            sstore(mappingSlot, value)
        }
    }

    /*///////////////////////////////////////////////////////////////////////
    //                             hash mapping                            //
    ////////////////////////////////////////////////////////////////////// */

    uint256 private constant HASH_STORAGE = 0xaa7b7cd2;

    function getHashStorageSlot(string memory method) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(method)));
    }

    function getHashStorageAssembly(bytes4 slot, uint256 key) public view returns (uint256 value) {
        assembly {
            mstore(0x00, key)
            mstore(0x20, slot)
            let mappingSlot := keccak256(0x00, 0x24)

            value := sload(mappingSlot)
        }
    }

    function setHashStorageAssembly(bytes4 slot, uint256 key, uint256 value) public {
        assembly {
            mstore(0x20, slot)
            mstore(0x00, key)
            let mappingSlot := keccak256(0x00, 0x24)

            sstore(mappingSlot, value)
        }
    }

    /*///////////////////////////////////////////////////////////////////////
    //                           double mapping                            //
    ////////////////////////////////////////////////////////////////////// */

    mapping(uint256 => mapping(uint256 => uint256)) public doubleMapping;

    function setDoubleMapping(uint256 keyA, uint256 keyB, uint256 value) public {
        doubleMapping[keyA][keyB] = value;
    }

    function getDoubleMapping(uint256 keyA, uint256 keyB) public view returns (uint256) {
        return doubleMapping[keyA][keyB];
    }

    function getDoubleMappingAssembly(uint256 keyA, uint256 keyB) public view returns (uint256 value) {
        assembly {
            mstore(0x00, keyA)
            mstore(0x20, doubleMapping.slot)
            let slot := keccak256(0x00, 0x40)

            mstore(0x00, keyB)
            mstore(0x20, slot)
            slot := keccak256(0x00, 0x40)

            value := sload(slot)
        }
    }

    function setDoubleMappingAssembly(uint256 keyA, uint256 keyB, uint256 value) public {
        assembly {
            mstore(0x00, keyA)
            mstore(0x20, doubleMapping.slot)
            let slot := keccak256(0x00, 0x40)

            mstore(0x00, keyB)
            mstore(0x20, slot)
            slot := keccak256(0x00, 0x40)

            sstore(slot, value)
        }
    }
}
