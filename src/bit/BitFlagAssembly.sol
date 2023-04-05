// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract BitFlagAssembly {
    uint256 public bitFlag = 0;

    function setBitFlag(uint256 _bitFlag) public {
        assembly {
            // Store the updated "bitFlag"
            sstore(0x0, _bitFlag)
        }
    }

    // Set N bit flag
    function setNBitFlag(uint256 n) public {
        assembly {
            // load slot "bitFlag"
            let slot0 := sload(0x0)
            let mask := shl(n, 1)
            let result := or(and(slot0, not(mask)), mask)

            // Store the updated "bitFlag"
            sstore(0x0, result)
        }
    }

    // Clear N bit flag
    function clearNBitFlag(uint256 n) public {
        assembly {
            // load slot "bitFlag"
            let slot0 := sload(0x0)
            let mask := not(shl(n, 1))
            let result := and(slot0, mask)

            // Store the updated "bitFlag"
            sstore(0x0, result)
        }
    }

    // Check N bit flag
    function checkNBitFlag(uint256 n) public view returns (uint256 result) {
        assembly {
            // load slot "bitFlag"
            let slot0 := sload(0x0)
            result := and(1, shr(n, slot0))
        }

        return (1 & (bitFlag >> n));
    }

    // Check N bit flag boolean
    function checkNBitFlagBool(uint256 n) public view returns (bool result) {
        assembly {
            // load slot "bitFlag"
            let slot0 := sload(0x0)
            result := and(1, shr(n, slot0))
            result := eq(result, 1)
        }
    }

    // Count bit flag
    function countBitFlag(uint256 x) external pure returns (uint256 count) {
        assembly {
            count := 0
            for {} gt(x, 0) {} {
                count := add(count, 1)
                x := and(x, sub(x, 1))
            }
        }
    }
}
