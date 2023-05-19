// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract HandleStringAssembly {
    string stringStorage;

    function setStringStorage(string memory str) public {
        stringStorage = str;
    }

    function getStringStorage() public view returns (string memory) {
        return stringStorage;
    }

    function setStringStorageAssembly(string memory str) public {
        assembly {
            let slot := stringStorage.slot
            let len := mload(str)

            switch lt(len, 32)
            // length < 32
            case 1 {
                // (value & length) set to slot
                sstore(slot, add(mload(add(str, 0x20)), mul(len, 2)))
            }
            // length >= 32
            default {
                // length info set to slot
                sstore(slot, add(mul(len, 2), 1))

                // key
                mstore(0x0, slot)
                let sc := keccak256(0x00, 0x20)

                // value set
                for {
                    let mc := add(str, 0x20)
                    let end := add(mc, len)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } { sstore(sc, mload(mc)) }
            }
        }
    }

    function getStringStorageAssembly() public view returns (string memory str) {
        assembly {
            // free memory pointer
            str := mload(0x40)

            let slot := stringStorage.slot
            let value := sload(slot)
            let len := div(and(value, sub(mul(0x100, iszero(and(value, 1))), 1)), 2)
            let mc := add(str, 0x20)

            // set length
            mstore(str, len)

            // set value
            switch lt(len, 32)
            // length < 32
            case 1 { mstore(mc, value) }
            // length >= 32
            default {
                // key
                mstore(0x0, slot)
                let sc := keccak256(0x00, 0x20)

                for { let end := add(mc, len) } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } { mstore(mc, sload(sc)) }
            }

            mstore(0x40, and(add(add(mc, len), 31), not(31)))
        }
    }

    /* /////////////////////////////////////////////////////////////////////////////
    mapping(uint256 => string)
    ///////////////////////////////////////////////////////////////////////////// */

    mapping(uint256 => string) stringMappingStorage;

    function setStringMappingStorage(string memory str, uint256 index) public {
        stringMappingStorage[index] = str;
    }

    function getStringMappingStorage(uint256 index) public view returns (string memory) {
        return stringMappingStorage[index];
    }

    function setStringMappingStorageAssembly(string memory str, uint256 index) public {
        assembly {
            mstore(0x20, stringMappingStorage.slot)
            mstore(0x00, index)
            let slot := keccak256(0x00, 0x40)
            let len := mload(str)

            switch lt(len, 32)
            // length < 32
            case 1 {
                // (value & length) set to slot
                sstore(slot, add(mload(add(str, 0x20)), mul(len, 2)))
            }
            // length >= 32
            default {
                // length info set to slot
                sstore(slot, add(mul(len, 2), 1))

                // key
                mstore(0x0, slot)
                let sc := keccak256(0x00, 0x20)

                // value set
                for {
                    let mc := add(str, 0x20)
                    let end := add(mc, len)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } { sstore(sc, mload(mc)) }
            }
        }
    }

    function getStringMappingStorageAssembly(uint256 index) public view returns (string memory str) {
        assembly {
            // free memory pointer
            str := mload(0x40)

            mstore(0x20, stringMappingStorage.slot)
            mstore(0x00, index)
            let slot := keccak256(0x00, 0x40)

            let value := sload(slot)
            let len := div(and(value, sub(mul(0x100, iszero(and(value, 1))), 1)), 2)
            let mc := add(str, 0x20)

            // set length
            mstore(str, len)

            // set value
            switch lt(len, 32)
            // length < 32
            case 1 { mstore(mc, value) }
            // length >= 32
            default {
                // key
                mstore(0x0, slot)
                let sc := keccak256(0x00, 0x20)

                for { let end := add(mc, len) } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } { mstore(mc, sload(sc)) }
            }

            mstore(0x40, and(add(add(mc, len), 31), not(31)))
        }
    }
}
