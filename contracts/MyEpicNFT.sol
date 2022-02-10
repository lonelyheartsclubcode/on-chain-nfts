// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Importing some handy openzeppelin contracts for compliance purposes.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
  // Counters helps keep track of tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // baseSvg variable that all of our NFTs will use. We simply change the words that fill it.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinyMin meet' viewbox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; } </style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Goofy", "Quirky", "Ostentatious", "Absurd", "Gregarious", "Dubious"];
  string[] secondWords = ["Juggernaut", "Tabletop", "Cougar", "Quentin", "Booger", "Server"];
  string[] thirdWords =["Fluid", "Solid", "Gas", "Bohemia", "Fantasy", "Hulud"];

  constructor() ERC721 ("PhunPhrases", "PHUN") {
    console.log("Welcome to the matrix.");
  }

  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // Actually mint the NFT
    _safeMint(msg.sender, newItemId);

    // Set metadata for token
    _setTokenURI(newItemId, "https://jsonkeeper.com/b/EVI7");
    console.log("An NFT with ID %s was minted to %s", newItemId, msg.sender);

    // Increment counter when NFT is minted so we have different identifiers for each NFT
    _tokenIds.increment();
  }
}