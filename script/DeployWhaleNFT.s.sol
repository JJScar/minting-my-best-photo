// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "@forge-std/Script.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";
import {HDRToken} from "../src/HDRToken.sol";

contract DeployWhaleNFT is Script {
    WhaleNFT public whaleNFT;
    HDRToken public token;

    function run(address _token) public returns (WhaleNFT) {
        vm.startBroadcast();
        token = HDRToken(_token);
        whaleNFT = new WhaleNFT(token, msg.sender);
        vm.stopBroadcast();
        return whaleNFT;
    }
}
