// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "@forge-std/Script.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";

contract DeployWhaleNFT is Script {
    WhaleNFT public whaleNFT;

    function run() public returns (WhaleNFT) {
        vm.startBroadcast();
        whaleNFT = new WhaleNFT();
        vm.stopBroadcast();
        return whaleNFT;
    }
}
