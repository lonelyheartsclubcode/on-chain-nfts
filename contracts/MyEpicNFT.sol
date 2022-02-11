// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Importing some handy openzeppelin contracts for compliance purposes.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  // Counters helps keep track of tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // baseSvg variable that all of our NFTs will use. We simply change the words that fill it.
  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Goofy", "Quirky", "Ostentatious", "Absurd", "Gregarious", "Dubious", "Googly", "Noogly", "Woogly", "Sugary", "Handsomely", "Incredulous", "Fanatical", "Superbly"];
  string[] secondWords = ["Juggernaut", "Tabletop", "Cougar", "Quentin", "Booger", "Server", "Change", "Goodness", "Grace", "Impossibility", "Certainty", "God", "Wonder"];
  string[] thirdWords =["Fluid", "Solid", "Gas", "Bohemia", "Fantasy", "Hulud", "Shai", "Rookie", "Cookie", "HTTPS", "Steph", "Curry", "Klay", "Ray", "Boot"];
  string[] colors = ['red', 'blue', 'orange', 'yellow', 'green', 'black', 'white', 'purple', '#32A189', '#EBC2CB', '#FF6347', '#40E0D0', '#000080'];

  event NewEpicNFTMinted (address sender, uint256 tokenId);

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

  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory randomColor = pickRandomColor(newItemId);

    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
      bytes(
          string(
              abi.encodePacked(
                  '{"name": "',
                  // We set the title of our NFT as the generated word.
                  combinedWord,
                  '", "description": "100% on-chain, dynamically generated three word combinations with pretty backgrounds.", "image": "data:image/svg+xml;base64,',
                  // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                  Base64.encode(bytes(finalSvg)),
                  '"}'
              )
          )
      )
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    require (
      newItemId + 1 <= 50, "We have a max supply of 50 NFTs!");

    // Actually mint the NFT
    _safeMint(msg.sender, newItemId);

    // Set metadata for token
    _setTokenURI(newItemId, finalTokenUri);

    // Increment counter when NFT is minted so we have different identifiers for each NFT
    _tokenIds.increment();
    console.log("An NFT with ID %s was minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}