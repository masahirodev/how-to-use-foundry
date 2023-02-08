// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";

contract StoreContract {
    uint256 private number1 = 123;
    uint256 private number2 = 456;
    uint256 private number3 = 789;

    mapping(address => uint256) public balanceOf;

    function balanceUp(address user, uint256 amount) external {
        balanceOf[user] += amount;
    }
}

contract StoreTest is Test {
    StoreContract public storeContract;
    address addr1 = vm.addr(1);

    function setUp() public {
        storeContract = new StoreContract();
    }

    function testGetStore1() public {
        bytes32 data = vm.load(address(storeContract), bytes32(uint256(10)));
        assertEq(uint256(data), 123);
    }

    function testGetStore2() public {
        bytes32 data = vm.load(address(storeContract), bytes32(uint256(20)));
        assertEq(uint256(data), 456);
    }

    function testGetStore3() public {
        bytes32 data = vm.load(address(storeContract), bytes32(uint256(30)));
        assertEq(uint256(data), 789);
    }

    function testSetAndGetStore(uint256 number) public {
        vm.store(address(storeContract), bytes32(uint256(0)), bytes32(uint256(number)));
        bytes32 data = vm.load(address(storeContract), bytes32(uint256(0)));
        assertEq(uint256(data), number);
    }

    function testCheckStore(address addr, uint256 amount) public {
        storeContract.balanceUp(addr, amount);
        bytes32 balanceSlot = keccak256(abi.encodePacked(uint256(uint160(addr)), uint256(3)));
        uint256 balance = uint256(vm.load(address(storeContract), balanceSlot));
        assertEq(balance, storeContract.balanceOf(addr));
    }
}
