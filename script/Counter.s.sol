// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "contracts/Counter.sol";
import "forge-std/Script.sol";

contract CounterScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        counter = new Counter();
        vm.stopBroadcast();
    }
}
