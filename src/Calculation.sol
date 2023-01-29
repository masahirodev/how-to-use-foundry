// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Calculation {
    function contractFunctionAdd(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function contractFunctionSub(uint256 a, uint256 b) public pure returns (uint256) {
        return a - b;
    }
}
