// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Tokle} from "../src/Tokle.sol";
import {TestToken} from "../src/TestToken.sol";

contract TokleScript is Script {
    Tokle public tokle;
    TestToken public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        token = new TestToken("Tokle Token", "TOK", 1000e18);

        tokle = new Tokle(address(token),1e18);

        bool ok = token.transfer(address(tokle),500e18);
        require(ok, "token transfer failed");

        vm.stopBroadcast();
    }
}