// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {ConcatConvertAssembly} from "contracts/utils/ConcatConvertAssembly.sol";

// forge test --match-contract ConcatConvertAssemblyTest --match-test testConcatBasic -vvvvv --gas-report

contract ConcatConvertAssemblyTest is Test {
    ConcatConvertAssembly public testContract;

    string str1 = "hoauegfolauhoausghado";
    string str2 = "safj;aoiewjfa@oa";

    function setUp() public {
        testContract = new ConcatConvertAssembly();
    }

    // frequently used concat function
    function testConcatBasic() public {
        string memory data = testContract.concatBasic(str1, str2);
        string memory result = string.concat(str1, str2);
        assertEq(result, data);
    }

    function testConcatBasicFuzz(string memory _str1, string memory _str2) public {
        string memory data = testContract.concatBasic(_str1, _str2);
        string memory result = string.concat(_str1, _str2);
        assertEq(result, data);
    }

    // stepped concat to convert to assembly
    function testConcatStep() public {
        string memory data = testContract.concatStep(str1, str2);
        string memory result = string.concat(str1, str2);
        assertEq(result, data);
    }

    function testConcatStepFuzz(string memory _str1, string memory _str2) public {
        string memory data = testContract.concatStep(_str1, _str2);
        string memory result = string.concat(_str1, _str2);
        assertEq(result, data);
    }

    // concat assembly
    function testConcatAssmeblyStatic() public {
        string memory data = testContract.concatAssembly(str1, str2);
        string memory result = string.concat(str1, str2);
        assertEq(result, data);
    }

    function testConcatAssmeblyFuzz32bytes(string memory _str1, string memory _str2) public {
        uint256 totalLength = bytes(_str1).length + bytes(_str2).length;

        vm.assume(totalLength % 32 == 0);
        // console.logUint(totalLength);

        string memory data = testContract.concatAssembly(_str1, _str2);
        string memory result = string.concat(_str1, _str2);

        assertEq(result, data);
    }

    function testConcatAssmeblyFuzzNot32bytes(string memory _str1, string memory _str2) public {
        uint256 totalLength = bytes(_str1).length + bytes(_str2).length;

        vm.assume(totalLength % 32 != 0);
        // console.logUint(totalLength);

        string memory data = testContract.concatAssembly(_str1, _str2);
        string memory result = string.concat(_str1, _str2);

        assertEq(result, data);
    }
}
