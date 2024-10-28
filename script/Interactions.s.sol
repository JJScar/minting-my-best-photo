// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "@forge-std/Script.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";
import {DevOpsTools} from "@foundry-devops/DevOpsTools.sol";
import {HDRToken} from "../src/HDRToken.sol";

contract MintNFT is Script {
    address public mostRecentlyDeployed;

    function run() public {
        mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("WhaleNFT", block.chainid);
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address recentDeployment) public {
        vm.broadcast();
        WhaleNFT(recentDeployment).mintNft();
    }
}

contract MintHDR is Script {
    address public mostRecentlyDeployed;
    uint256 public constant MINT_AMOUNT = 5e18;

    function run() public {
        mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("HDRToken", block.chainid);
        mintTokenOnContract(mostRecentlyDeployed);
    }

    function mintTokenOnContract(address recentDeployment) public {
        vm.broadcast();
        HDRToken(recentDeployment).mint(msg.sender, MINT_AMOUNT);
    }
}
