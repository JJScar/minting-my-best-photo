// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "@forge-std/Test.sol";
import {WhaleNFT} from "../src/WhaleNFT.sol";
import {HDRToken} from "../src/HDRToken.sol";
import {DeployWhaleNFT} from "../script/DeployWhaleNFT.s.sol";
import {MintNFT} from "../script/Interactions.s.sol";
import {DeployToken} from "../script/DeployHDRToken.s.sol";
import {MintHDR} from "../script/Interactions.s.sol";

contract WhaleNFTTest is Test {
    // The erros from the WhaleNFT contract to test they work
    error WhaleNFT__LimitReached();

    WhaleNFT public whaleNFT;
    HDRToken public token;
    DeployWhaleNFT public nftDeployer;
    MintNFT public mintNftDeployer;
    DeployToken public tokenDeployer;
    MintHDR public mintHDRDeployer;

    address public USER = makeAddr("USER");
    address public DeafultUSER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
    string public constant NFT_NAME = "WhaleNFT";
    string public constant NFT_SYMBOL = "WHT";
    string public constant TOKEN_URI =
        "https://ipfs.io/ipfs/Qmbhzm4DE3pthwrHAcpZD7hNd5UhkctFMvLqTtGGnkLdkT?filename=NFTStats.json";
    uint256 public constant AMOUNT_FOR_USER = 5e18;

    function setUp() public {
        tokenDeployer = new DeployToken();
        token = tokenDeployer.run();
        nftDeployer = new DeployWhaleNFT();
        whaleNFT = nftDeployer.run(address(token));

        token.approve(USER, AMOUNT_FOR_USER);
        token.mint(USER, AMOUNT_FOR_USER);
    }

    ///////////////
    // Modifiers //
    ///////////////

    modifier prankAndDeal() {
        vm.startPrank(USER);
        token.approve(address(whaleNFT), AMOUNT_FOR_USER);
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

    function test_mint_and_balance() public prankAndDeal {
        whaleNFT.mintNft();

        assertEq(whaleNFT.balanceOf(USER), 1);
        console.log("NFT owner address: ", whaleNFT.i_owner());
    }

    function test_cant_mint_above_limit() public prankAndDeal {
        for (uint256 i = 0; i < 100; i++) {
            // First mint in the setup so minus 1
            whaleNFT.mintNft();
        }
        vm.expectRevert(WhaleNFT__LimitReached.selector);
        whaleNFT.mintNft();
    }

    function test_cant_find_token_uri() public prankAndDeal {
        // It is 2 because the first should be 1!
        vm.expectRevert(); // Not using a custom error because the ERC721 contract from OpenZeppelin automatically uses they're own!
        whaleNFT.tokenURI(2);
    }

    function test_get_counter() public prankAndDeal {
        whaleNFT.mintNft();
        assertEq(whaleNFT.getTokenCounter(), 2);
    }

    function test_get_token_id_for_owner() public prankAndDeal {
        whaleNFT.mintNft();
        assertEq(whaleNFT.getTokenIDForOwner(USER), 1);
    }

    function test_base_uri() public view {
        assertEq(keccak256(abi.encodePacked(TOKEN_URI)), keccak256(abi.encodePacked(whaleNFT.getTokenURI())));
    }

    function test_user_with_not_enough_tokens() public {
        address poorUser = makeAddr("poorUser");
        uint256 badAmount = 1e14;
        token.mint(poorUser, badAmount);
        vm.startPrank(poorUser);
        vm.expectRevert();
        whaleNFT.mintNft();
        vm.stopPrank();
    }

    ////////////////////////
    // HDRToken.sol Tests //
    ////////////////////////

    function test_minting_of_HDRToken() public view {
        assertEq(token.balanceOf(USER), AMOUNT_FOR_USER);
    }
}
