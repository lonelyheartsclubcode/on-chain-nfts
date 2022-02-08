// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// Importing some handy openzeppelin contracts for compliance purposes.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage {
  // Counters helps keep track of tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721 ("LarvaLabL", "FPUNK") {
    console.log("Welcome to the matrix.");
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