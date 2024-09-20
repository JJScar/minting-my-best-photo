// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "@forge-std/Script.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";
import {DevOpsTools} from "@foundry-devops/DevOpsTools.sol";

contract WhaleNFTInteractions is Script {
    WhaleNFT public whaleNFT;

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("WhaleNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address recentDeployment) public {
        vm.startBroadcast();
        WhaleNFT(recentDeployment).mintNft();
        vm.stopBroadcast();
    }
}
