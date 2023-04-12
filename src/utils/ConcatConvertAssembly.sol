// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ConcatConvertAssembly {
    // frequently used concat function
    function concatBasic(string memory str1, string memory str2) public pure returns (string memory) {
        return string.concat(str1, str2);
    }

    // stepped concat to convert to assembly
    function concatStep(string memory str1, string memory str2) public pure returns (string memory) {
        bytes memory str1Bytes = bytes(str1);
        bytes memory str2Bytes = bytes(str2);

        uint256 str1Len = bytes(str1).length;
        uint256 str2Len = bytes(str2).length;

        string memory result = new string(str1Len + str2Len);
        bytes memory resultBytes = bytes(result);

        uint256 j;
        for (uint256 i = 0; i < str1Len;) {
            unchecked {
                resultBytes[j++] = str1Bytes[i];
                i++;
            }
        }
        for (uint256 i = 0; i < str2Len;) {
            unchecked {
                resultBytes[j++] = str2Bytes[i];
                i++;
            }
        }
        return string(resultBytes);
    }

    function concatAssembly(string memory str1, string memory str2) public pure returns (string memory result) {
        assembly {
            // memory space
            // | 0x00 - 0x3f | scratch space
            // | 0x40 - 0x5f | free memory pointer (init = 0x80)
            // | 0x60 - 0x7f | zero slot
            // | 0x80 - 0x9f | dynamic memory arrays

            // free memory pointer
            // result = mload(0x40) => 0x80
            result := mload(0x40)

            // str1 ex.length = 80
            // | 0x00 - 0x1f | length
            // | 0x20 - 0x3f | byte32
            // | 0x40 - 0x5f | byte32
            // | 0x60 - 0x6f | byte16
            let length := mload(str1)

            // write memory space
            mstore(result, length)

            // memory space
            // | 0x00 - 0x3f | scratch space
            // | 0x40 - 0x5f | free memory pointer (init = 0x80)
            // | 0x60 - 0x7f | zero slot
            // | 0x80 - 0x9f | str1.length result
            // | 0xA0          ← memory counter start point

            // set memory counter & last point
            let mc := add(result, 0x20)
            let last := add(mc, length)

            // for { initialize } lt ( judge ) { loop preprocessing } { loop content }

            // initialize
            // str1
            // | 0x00 - 0x1f | length
            // | 0x20 - 0x3f | byte32 ← start(step by step 0x20)
            // | 0x40 - 0x5f | byte32
            // | 0x60 - 0x6f | byte16

            // judge
            // mc < last

            // loop preprocessing
            // mc : step by step 0x20
            // cc : step by step 0x20

            // loop content
            // | loop | mc   | memory space | str1        | cc   |
            // | 1    | 0xA0 | 0xA0 - 0xBF  | 0x20 - 0x3f | 0x20 |
            // | 2    | 0xC0 | 0xC0 - 0xDF  | 0x40 - 0x5f | 0x40 |
            // | 3    | 0xE0 | 0xE0 - 0xEF  | 0x60 - 0x6f | 0x60 |

            for { let cc := add(str1, 0x20) } lt(mc, last) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } { mstore(mc, mload(cc)) }

            // memory space
            // | 0x00 - 0x3f | scratch space
            // | 0x40 - 0x5f | free memory pointer (init = 0x80)
            // | 0x60 - 0x7f | zero slot
            // | 0x80 - 0x9f | str1.length = result
            // | 0xA0 - 0xBF | str1 0x20 - 0x3f
            // | 0xC0 - 0xDF | str1 0x40 - 0x5f
            // | 0xE0 - 0xEF | str1 0x60 - 0x6f
            // | 0xF0          ← memory counter start point

            // str2 ex.length = 72
            // | 0x00 - 0x1f | length
            // | 0x20 - 0x3f | byte32
            // | 0x40 - 0x5f | byte32
            // | 0x60 - 0x6f | byte8
            length := mload(str2)

            // write memory space
            mstore(result, add(length, mload(result)))

            // set memory counter & last point
            mc := last
            last := add(mc, length)

            for { let cc := add(str2, 0x20) } lt(mc, last) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } { mstore(mc, mload(cc)) }

            // memory space
            // | 0x00  - 0x3f  | scratch space
            // | 0x40  - 0x5f  | free memory pointer (init = 0x80)
            // | 0x60  - 0x7f  | zero slot
            // | 0x80  - 0x9f  | str1.length + str2.length = result
            // | 0xA0  - 0xBF  | str1 0x20 - 0x3f
            // | 0xC0  - 0xDF  | str1 0x40 - 0x5f
            // | 0xE0  - 0xEF  | str1 0x60 - 0x6f
            // | 0xF0  - 0xFF  | str2 0x20 - 0x2f
            // | 0x100 - 0x120 | str2 0x30 - 0x4f
            // | 0x100 - 0x117 | str2 0x50 - 0x67

            // abracadabra
            // to 32bytes
            mstore(0x40, and(add(last, 31), not(31)))
        }
        return result;
    }
}
