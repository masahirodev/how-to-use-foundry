// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract BitFlag {
    uint256 public bitFlag = 0;

    function setBitFlag(uint256 _bitFlag) public {
        bitFlag = _bitFlag;
    }

    // Set N bit flag
    function setNBitFlag(uint256 n) public {
        uint256 mask = 1 << n;
        uint256 clear_mask = ~mask;
        bitFlag = (bitFlag & clear_mask) | mask;
    }

    // Clear N bit flag
    function clearNBitFlag(uint256 n) public {
        uint256 mask = ~(1 << n);
        bitFlag &= mask;
    }

    // Check N bit flag
    function checkNBitFlag(uint256 n) public view returns (uint256) {
        return (1 & (bitFlag >> n));
    }

    // Check N bit flag boolean
    function checkNBitFlagBool(uint256 n) public view returns (bool) {
        // return (1 & (bitFlag >> n) == 1);
        return (bitFlag & (1 << n) != 0);
    }

    // Count bit flag
    function countBitFlag(uint256 x) external pure returns (uint256 count) {
        for (uint256 i = 0; i < 256;) {
            unchecked {
                if ((x & (1 << i)) != 0) {
                    count++;
                }
                i++;
            }
        }
    }
}
