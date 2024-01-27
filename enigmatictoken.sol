// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EnigmaticAuraToken is ERC20, Ownable(msg.sender) {
    // Total supply of the token
    uint256 private constant TOTAL_SUPPLY = 10000000 * 10**18; // 10 million EAT

    /**
     * @dev Constructor that gives msg.sender all of the existing tokens.
     */
    constructor() ERC20("EnigmaticAuraToken", "EAT") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    /**
     * @dev Function to mint additional tokens.
     * Can only be called by the owner of the contract.
     * @param account The account to mint tokens for.
     * @param amount The amount of tokens to mint.
     */
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}
