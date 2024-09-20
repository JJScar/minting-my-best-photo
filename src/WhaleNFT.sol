//                                               .=+*####*+=:.
//                                             .*##############:
//                                           .*####-      .=*##-
//                                         .:*##*:.
//                                         .*###.
//                      .....             .+###
//                     .=####*=:.         :###:
//                     .-*#######+.      .###=.
//                           .=####+     -###-
//                             .-###+.  .+##+.
//                               :###*. .+##+
//                                .%##= :*##+
//                                 .*+. .-*+.
//                          ..:--======--::.
//                     .-+*##################**=:
//                 .:*########*+=------=+*#########=..
//              .:+#####*+-:::::::::::::::::::=+*#####=.                                   ....
//            .=#####+-::::::::::::::::::::::::::-=*####*:.                            .=*######*=.
//          .=####+::::::::::::::::::::::::::::::::::=#####:                         .*############*:
//        .-####+-:::::::::::::::::::::::::::::::::::::-*###*..                     :*###=::::::=*###-.
//       .*###+::::::::::::::::::::::::::::::::::::::::::=####-.                   .=###-:::::::::*###.
//     .:###*-:::::::::::::::::::::::::::::::::::::::::::::=###*.           .-+****=###+:::::::-==+###+
//     -###*::::::::::::::::::::::::::::::::::::::::::::::::=###+..      .-############=::::=##########
//    -###+::::::::::::::::::::::::::::::::::::::::::::::::::-###*.    .:*###*=---=+*##=:::*###*=----=.
//   -###+::::::::::::::::::::::::::::::::::-+**=:::::::::::::-###*.   .###*-::::::::-::::+###:
//  :*##*-:::::::::::::::::::::::::::::::::-#####*-::::::::::::-###=   *###:::::::::::::::*##*.
// .=###-::::::::::::::::::::::::::::::::::-#####*-:::::::::::::=###:  ###+::::-=+***+-:::-###-
// .*##+::::::::::::::::::::::::::::::::::::-*##+-::::::::::::::-*##+. *###::=*#########=::+##*
// -###-:::::::::::::::::::::::::::::::::::::::::::::::::::::::::+##*. .####=###*:...+###=:-###:
// +##*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=###-. :*#####+      *##+:-*##=
// *##+::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-###-.  .-*###.      *##+--*##+
// ###=:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::###=.    ..:.      :###+:-+##*
// ###+:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*##=.            ..*##*-:-*##+
// +##*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=###=.          :=###*-::-*##=
// :###+:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=####**+====+*#####=::::=###:
// .=###=:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-+#############*=::::::###+
//  .=###+-::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--====--::::::::-###*.
//  .-###################################*-:::::::::::::::::::::::::::::::::::::::::::::+###+.
// .#####################################*-::::::::::::::::::::::::::::::::::::::::::-+####=.
// +###::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--+#####+.
// *##+:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-=+*######+-.
// +###-::::::::::::::::::::::::::::::::::::::::::::::::::::::::::--=++**#########*-:.
// .*########################################################################+-.
//  .-**#####################################################*****++==-:.

// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract WhaleNFT is ERC721, ReentrancyGuard {
    /*//////////
    // Errors //
    //////////*/

    error WhaleNFT__LimitReached();
    error WhaleNFT__TokenUriNotFound();

    /*//////////
    // Events //
    //////////*/

    event WhaleNFT__WhaleNFTMinted(uint256 indexed tokenId);

    /*///////////////////
    // State Variables //
    ///////////////////*/

    // The mapping that will store owner of that token ID
    mapping(address owner => uint256 tokenID) private s_ownersToTokenID;
    uint256 public s_tokenCounter = 100;

    /*//////////////////////
    // Constant Variables //
    //////////////////////*/

    /**
     * @notice As per the docs, we want to have a limit for a 100 NFTs.
     */
    modifier isOverLimit() {
        if (s_tokenCounter > 100) {
            revert WhaleNFT__LimitReached();
        }
        _;
    }

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     * @dev Setting the token counter to 1, meaning the first token ID will be 1.
     */
    constructor() ERC721("WhaleNFT", "WHT") {
        s_tokenCounter = 1;
    }

    // Minting this NFT should be possible using the HDR Token

    /**
     * @dev Uses the OpenZeppelin ERC721 `safeMint` function to mint an NFT.
     * @dev Uses the token minted counter as the token ID.
     */
    function mintNft() public isOverLimit nonReentrant {
        _safeMint(msg.sender, s_tokenCounter);
        s_ownersToTokenID[msg.sender] = s_tokenCounter;
        s_tokenCounter = s_tokenCounter + 1;

        emit WhaleNFT__WhaleNFTMinted(s_tokenCounter - 1);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/Qmbhzm4DE3pthwrHAcpZD7hNd5UhkctFMvLqTtGGnkLdkT?filename=NFTStats.json";
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getTokenIDForOwner(address _owner) public view returns (uint256) {
        return s_ownersToTokenID[_owner];
    }

    function getTokenURI() public pure returns (string memory) {
        string memory uri = _baseURI();
        return uri;
    }
}
