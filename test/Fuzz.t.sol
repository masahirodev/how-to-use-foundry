// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";

contract Safe {
    receive() external payable {}

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract FuzzTest is Test {
    Safe safe;

    // Needed so the test contract itself can receive ether
    // when withdrawing
    receive() external payable {}

    function setUp() public {
        safe = new Safe();
    }

    //Error
    function testWithdraw1(uint256 amount) public {
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

    function testWithdraw2(uint96 amount) public {
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }
}
