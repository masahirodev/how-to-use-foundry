// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

contract SlotContract1 {
    uint256 a;
    uint256 b;
    uint256 c;
}

contract SlotContract2 {
    uint64 a;
    uint64 b;
    uint256 c;
}

contract SlotContract3 {
    uint64 a;
    uint256 b;
    uint64 c;
}
