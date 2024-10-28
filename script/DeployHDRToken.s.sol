// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "@forge-std/Script.sol";
import {HDRToken} from "../src/HDRToken.sol";

contract DeployToken is Script {
    HDRToken public token;

    function run() public returns (HDRToken) {
        vm.startBroadcast();
        token = new HDRToken();
        vm.stopBroadcast();
        return token;
    }
}
