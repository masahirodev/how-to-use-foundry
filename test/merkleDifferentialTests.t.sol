// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "forge-std/console.sol";

import "@murky/differential_testing/test/utils/Strings2.sol";

contract merkleDifferentialTests is Test {
    using {Strings2.toHexString} for bytes;

    function testCreateRandomLeaves(address[128] memory addresses, uint8[128] memory quantities) public {
        bytes memory packed1 = abi.encodePacked(addresses);
        bytes memory packed2 = abi.encodePacked(quantities);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/createRandomLeaves.js";
        runJsInputs[2] = packed1.toHexString();
        runJsInputs[3] = packed2.toHexString();

        bytes memory result = vm.ffi(runJsInputs);
        uint256 number = abi.decode(result, (uint256));
        assertEq(number, 1);
    }

    function testLogicMerkleProofBadCase1(address[128] memory addresses, uint8[128] memory quantities, uint8 i)
        public
    {
        vm.assume(i < 128);
        bytes memory packed1 = abi.encodePacked(addresses);
        bytes memory packed2 = abi.encodePacked(quantities);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/foundryMerkleBadCase.js";
        runJsInputs[2] = packed1.toHexString();
        runJsInputs[3] = packed2.toHexString();

        bytes memory result = vm.ffi(runJsInputs);
        (bytes32 jsRoot, bytes32[][] memory jsProofs, bytes32[] memory jsLeaves) =
            abi.decode(result, (bytes32, bytes32[][], bytes32[]));

        bool verified = MerkleProof.verify(jsProofs[i], jsRoot, jsLeaves[i]);
        assertEq(verified, true);
    }

    function testLogicMerkleProofBadCaseFixed1(address[128] memory addresses, uint8[128] memory quantities, uint8 i)
        public
    {
        vm.assume(i < 128);
        bytes memory packed1 = abi.encodePacked(addresses);
        bytes memory packed2 = abi.encodePacked(quantities);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/foundryMerkleBadCaseFixed1.js";
        runJsInputs[2] = packed1.toHexString();
        runJsInputs[3] = packed2.toHexString();

        bytes memory result = vm.ffi(runJsInputs);
        (bytes32 jsRoot, bytes32[][] memory jsProofs, bytes32[] memory jsLeaves) =
            abi.decode(result, (bytes32, bytes32[][], bytes32[]));

        bool verified = MerkleProof.verify(jsProofs[i], jsRoot, jsLeaves[i]);
        assertEq(verified, true);
    }

    function testLogicMerkleProofBadCase2(address[128] memory addresses, uint8[128] memory quantities, uint8 i)
        public
    {
        vm.assume(i < 128);
        bytes memory packed1 = abi.encodePacked(addresses);
        bytes memory packed2 = abi.encodePacked(quantities);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/foundryMerkleBadCaseFixed1.js";
        runJsInputs[2] = packed1.toHexString();
        runJsInputs[3] = packed2.toHexString();

        bytes memory result = vm.ffi(runJsInputs);
        (bytes32 jsRoot, bytes32[][] memory jsProofs, bytes32[] memory jsLeaves) =
            abi.decode(result, (bytes32, bytes32[][], bytes32[]));

        bytes32 leaf = keccak256(abi.encodePacked(addresses[i], quantities[i]));
        bool verified = MerkleProof.verify(jsProofs[i], jsRoot, leaf);
        assertEq(verified, true);
    }

    function testLogicMerkleProofBadCaseFiexd2(address[128] memory addresses, uint8[128] memory quantities, uint8 i)
        public
    {
        vm.assume(i < 128);
        bytes memory packed1 = abi.encodePacked(addresses);
        bytes memory packed2 = abi.encodePacked(quantities);

        string[] memory runJsInputs = new string[](4);
        runJsInputs[0] = "node";
        runJsInputs[1] = "ts-src/foundryMerkleBadCaseFixed2.js";
        runJsInputs[2] = packed1.toHexString();
        runJsInputs[3] = packed2.toHexString();

        bytes memory result = vm.ffi(runJsInputs);
        (bytes32 jsRoot, bytes32[][] memory jsProofs, bytes32[] memory jsLeaves) =
            abi.decode(result, (bytes32, bytes32[][], bytes32[]));

        bytes32 leaf = keccak256(abi.encodePacked(addresses[i], quantities[i]));
        bool verified = MerkleProof.verify(jsProofs[i], jsRoot, leaf);
        assertEq(verified, true);
    }
}
