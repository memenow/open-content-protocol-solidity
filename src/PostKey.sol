// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PostKey
 * @dev Manage post keys using ERC1155 tokens.
 */
contract PostKey is ERC1155, Ownable {
    uint public postKeyCounter;

    event PostKeyCreated(uint indexed postKeyId, address indexed creator);

    /**
     * @dev Constructor function that initializes the ERC1155 token with a base URI.
     * @param baseURI The base URI for the token metadata.
     * @param owner The address of the contract owner.
     */
    constructor(string memory baseURI, address owner) ERC1155(baseURI) Ownable(owner) {}

    /**
     * @dev Internal function to create a new PostKey and mint it to the specified creator.
     * @param creator The address of the creator who will receive the minted PostKey.
     * @return The ID of the newly created PostKey.
     */
    function createPostKey(address creator) private returns (uint) {
        postKeyCounter++;
        _mint(creator, postKeyCounter, 1, "");
        emit PostKeyCreated(postKeyCounter, creator);
        return postKeyCounter;
    }

    /**
     * @dev Public function to mint a new PostKey to the specified creator.
     * Only the contract owner can call this function.
     * @param creator The address of the creator who will receive the minted PostKey.
     */
    function mintPostKey(address creator) public onlyOwner {
        createPostKey(creator);
    }
}