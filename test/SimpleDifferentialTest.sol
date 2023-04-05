// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import {Calculation} from "contracts/Calculation.sol";

contract DifferentialTests is Calculation, Test {
    using Strings for uint256;

    function testContractVsTsAdd() public {
        uint256 a = 1;
        uint256 b = 2;

        string[] memory runTsInputs = new string[](5);
        runTsInputs[0] = "npx";
        runTsInputs[1] = "ts-node";
        runTsInputs[2] = "ts-src/add.ts";
        runTsInputs[3] = Strings.toString(a);
        runTsInputs[4] = Strings.toString(b);

        bytes memory tsResult = vm.ffi(runTsInputs);
        uint256 tsAdd = abi.decode(tsResult, (uint256));

        uint256 add = contractFunctionAdd(a, b);

        assertEq(tsAdd, add);
    }

    //This test causes an error.
    function testFuzzTestContractVsTsAdd(uint8 a, uint8 b) public {
        vm.assume(a > 0 && b > 0);

        string[] memory runTsInputs = new string[](5);
        runTsInputs[0] = "npx";
        runTsInputs[1] = "ts-node";
        runTsInputs[2] = "ts-src/add.ts";
        runTsInputs[3] = Strings.toString(a);
        runTsInputs[4] = Strings.toString(b);

        bytes memory tsResult = vm.ffi(runTsInputs);
        uint256 tsAdd = abi.decode(tsResult, (uint256));

        //Error Arithmetic over/underflow
        uint256 add = a + b;

        assertEq(tsAdd, add);
    }

    //This test takes about 250s.
    function testFuzzTestSafeMathVsTsAdd(uint8 a, uint8 b) public {
        vm.assume(a > 0 && b > 0);

        string[] memory runTsInputs = new string[](5);
        runTsInputs[0] = "npx";
        runTsInputs[1] = "ts-node";
        runTsInputs[2] = "ts-src/add.ts";
        runTsInputs[3] = Strings.toString(a);
        runTsInputs[4] = Strings.toString(b);

        bytes memory tsResult = vm.ffi(runTsInputs);
        uint256 tsAdd = abi.decode(tsResult, (uint256));

        //Change uint256 add = a + b;
        uint256 add = SafeMath.add(a, b);

        assertEq(tsAdd, add);
    }

    //Requires pre-compilation.
    //This test takes about 30s.
    function testFuzzContractVsJsAdd(uint8 a, uint8 b) public {
        vm.assume(a > 0 && b > 0);

        string[] memory runTsInputs = new string[](4);
        runTsInputs[0] = "node";
        runTsInputs[1] = "ts-src/add.js";
        runTsInputs[2] = Strings.toString(a);
        runTsInputs[3] = Strings.toString(b);

        bytes memory tsResult = vm.ffi(runTsInputs);
        uint256 tsAdd = abi.decode(tsResult, (uint256));

        uint256 add = contractFunctionAdd(a, b);

        assertEq(tsAdd, add);
    }

    function testFuzzContractVsJsAddAndSub(uint8 a, uint8 b) public {
        vm.assume(a > 0 && b > 0 && a > b);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/addAndSub.js";
        runJsInputs[2] = Strings.toString(a);
        runJsInputs[3] = Strings.toString(b);
        bytes memory tsResult = vm.ffi(runJsInputs);
        (uint256 JsAdd, uint256 JsSub) = abi.decode(tsResult, (uint256, uint256));

        uint256 add = contractFunctionAdd(a, b);
        uint256 sub = contractFunctionSub(a, b);

        assertEq(add, JsAdd);
        assertEq(sub, JsSub);
    }

    function testImportDataContractVsJsAddAndSub() public {
        string[] memory loadJsDataInputs = new string[](2);
        loadJsDataInputs[0] = "cat";
        loadJsDataInputs[1] = "data/data.txt";
        bytes memory loadResult = vm.ffi(loadJsDataInputs);
        (uint8 a, uint8 b) = abi.decode(loadResult, (uint8, uint8));

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/addAndSub.js";
        runJsInputs[2] = Strings.toString(a);
        runJsInputs[3] = Strings.toString(b);
        bytes memory tsResult = vm.ffi(runJsInputs);
        (uint256 JsAdd, uint256 JsSub) = abi.decode(tsResult, (uint256, uint256));

        uint256 add = SafeMath.add(a, b);
        uint256 sub = SafeMath.sub(a, b);

        assertEq(add, JsAdd);
        assertEq(sub, JsSub);
    }
}
