// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract EnigmaticAuraBondToken is ERC721Enumerable, Ownable(msg.sender){
    using SafeMath for uint256;

    uint256 public constant MAX_SUPPLY = 6666;
    uint256 public constant MAX_MINT_PER_TRANSACTION = 10;
    uint256 public constant PRICE = 0.01 ether;

    // Base URI for metadata
    string private _baseTokenURI;

    // Sale status
    bool public saleActive;

    constructor(string memory baseTokenURI) ERC721("EnigmaticAuraBondToken", "EABT") {
        _baseTokenURI = baseTokenURI;
        saleActive = false;
    }

    function mint(uint256 numberOfTokens) external payable {
        require(saleActive, "Sale is not active");
        require(numberOfTokens > 0 && numberOfTokens <= MAX_MINT_PER_TRANSACTION, "Invalid number of tokens");
        require(totalSupply().add(numberOfTokens) <= MAX_SUPPLY, "Exceeds maximum supply");
        require(msg.value == PRICE.mul(numberOfTokens), "Incorrect Ether value");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            uint256 tokenId = totalSupply() + 1;
            _safeMint(msg.sender, tokenId);
        }
    }

    function toggleSaleStatus() external onlyOwner {
        saleActive = !saleActive;
    }

    function setBaseURI(string memory baseTokenURI) external onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }
}
