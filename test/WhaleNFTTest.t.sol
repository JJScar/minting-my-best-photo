// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "@forge-std/Test.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";
import {HDRToken} from "../src/HDRToken.sol";
import {DeployWhaleNFT} from "../script/DeployWhaleNFT.s.sol";
import {WhaleNFTInteractions} from "../script/WhaleNFTInteractions.s.sol";

contract WhaleNFTTest is Test {
    // The erros from the WhaleNFT contract to test they work
    error WhaleNFT__LimitReached();

    WhaleNFT public whaleNFT;
    HDRToken public token;
    DeployWhaleNFT public deployWhaleNFT;
    WhaleNFTInteractions public interactions;

    address public USER = makeAddr("USER");
    string public constant NFT_NAME = "WhaleNFT";
    string public constant NFT_SYMBOL = "WHT";
    string public constant TOKEN_URI =
        "https://ipfs.io/ipfs/Qmbhzm4DE3pthwrHAcpZD7hNd5UhkctFMvLqTtGGnkLdkT?filename=NFTStats.json";
    uint256 public constant AMOUNT_FOR_USER = 1e18;

    function setUp() public {
        deployWhaleNFT = new DeployWhaleNFT();
        whaleNFT = deployWhaleNFT.run();
        token = new HDRToken();
        interactions = new WhaleNFTInteractions();
    }

    ///////////////
    // Modifiers //
    ///////////////

    modifier pranks() {
        vm.startPrank(USER);
        _;
        vm.stopPrank();
    }

    ////////////////////////
    // WhaleNFT.sol Tests //
    ////////////////////////

    function test_name_is_correct() public view {
        string memory name = whaleNFT.name();
        string memory expectedName = NFT_NAME;
        assertEq(
            keccak256(abi.encodePacked(name)), keccak256(abi.encodePacked(expectedName)), "WhaleNFT name is incorrect"
        );
    }

    function test_symbol_is_correct() public view {
        string memory symbol = whaleNFT.symbol();
        string memory expectedSymbol = NFT_SYMBOL;
        assertEq(
            keccak256(abi.encodePacked(symbol)),
            keccak256(abi.encodePacked(expectedSymbol)),
            "WhaleNFT symbol is incorrect"
        );
    }

    function test_mint_and_balance() public pranks {
        whaleNFT.mintNft();

        assertEq(whaleNFT.balanceOf(USER), 1);
    }

    function test_cant_mint_above_limit() public pranks {
        for (uint256 i = 0; i < 100; i++) {
            whaleNFT.mintNft();
        }
        vm.expectRevert(WhaleNFT__LimitReached.selector);
        whaleNFT.mintNft();
    }

    function test_cant_find_token_uri() public pranks {
        // It is 2 because the first should be 1!
        vm.expectRevert(); // Not using a custom error because the ERC721 contract from OpenZeppelin automatically uses they're own!
        whaleNFT.tokenURI(2);
    }

    function test_get_counter() public pranks {
        whaleNFT.mintNft();

        // Counter starts at 1 so now shoulw be 2
        assertEq(whaleNFT.getTokenCounter(), 2);
    }

    function test_get_token_id_for_owner() public pranks {
        whaleNFT.mintNft();
        assertEq(whaleNFT.getTokenIDForOwner(USER), 1);
    }

    function test_base_uri() public view {
        assertEq(keccak256(abi.encodePacked(TOKEN_URI)), keccak256(abi.encodePacked(whaleNFT.getTokenURI())));
    }

    ////////////////////////
    // HDRToken.sol Tests //
    ////////////////////////

    function test_minting_of_HDRToken() public {
        vm.startPrank(address(this));
        token.approve(USER, AMOUNT_FOR_USER);
        token.mint(USER, AMOUNT_FOR_USER);
        vm.stopPrank();
        assertEq(token.balanceOf(USER), AMOUNT_FOR_USER);
    }

    ////////////////////////////
    // Interactions.sol Tests //
    ////////////////////////////

    function test_mint_with_interactions_script() public {
        interactions.mintNFTOnContract(address(whaleNFT));

        assertEq(whaleNFT.getTokenCounter(), 2);
        assertEq(whaleNFT.getTokenIDForOwner(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38), 1); // still need to figure out who this is
    }
}
