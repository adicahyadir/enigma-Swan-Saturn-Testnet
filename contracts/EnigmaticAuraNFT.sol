// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EnigmaticAuraNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Event emitted when a new NFT is minted
    event Minted(address indexed owner, uint256 tokenId);

    // NFT name and symbol
    string private _name = "ENIGMATIC AURA";
    string private _symbol = "EA";

    // Maximum supply of NFTs
    uint256 private _maxSupply = 6666;

    // Base URI for metadata
    string private _baseTokenURI;

    // Mapping to track whether a token ID has been minted
    mapping(uint256 => bool) private _mintedTokens;

    // Additional owners
    mapping(address => bool) private _additionalOwners;

    modifier onlyAdditionalOwners() {
        require(_additionalOwners[msg.sender] || msg.sender == owner(), "Not an additional owner");
        _;
    }

    constructor(string memory baseTokenURI, address initialOwner) ERC721(_name, _symbol) Ownable(initialOwner) {
        _baseTokenURI = baseTokenURI;
        _addAdditionalOwner(0x6dB77318c4EB74A296E41179A22700F84658fA86);
    }

    // Mint new NFT
    function mint() external onlyAdditionalOwners {
        require(_tokenIdCounter.current() < _maxSupply, "Maximum supply reached");
        uint256 tokenId = _tokenIdCounter.current() + 1;
        _safeMint(msg.sender, tokenId);
        _mintedTokens[tokenId] = true;
        _tokenIdCounter.increment();
        emit Minted(msg.sender, tokenId);
    }

    // Check if a token has been minted
    function isTokenMinted(uint256 tokenId) external view returns (bool) {
        return _mintedTokens[tokenId];
    }

    // Set the base URI for metadata
    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    // Add additional owner
    function addOwner(address newOwner) external onlyOwner {
        _addAdditionalOwner(newOwner);
    }

    // Internal function to add additional owner
    function _addAdditionalOwner(address newOwner) internal {
        require(newOwner != address(0), "Invalid address");
        _additionalOwners[newOwner] = true;
    }

    // Function to remove additional owner (only callable by the contract owner)
    function removeOwner(address ownerToRemove) external onlyOwner {
        require(ownerToRemove != owner(), "Cannot remove contract owner");
        _additionalOwners[ownerToRemove] = false;
    }

    // Function to check if an address is an additional owner
    function isAdditionalOwner(address account) external view returns (bool) {
        return _additionalOwners[account];
    }

    // Override _baseURI() to return the base URI
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    // Function to withdraw Ether from the contract
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
