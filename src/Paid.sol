// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Paid
 * @dev Manage paid content using ERC721 tokens.
 */
contract Paid is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _paidIdCounter;

    struct PaidData {
        uint256 id;
        address memberAddress;
        address creatorAddress;
        string uri;
        string description;
    }

    mapping(uint256 => PaidData) public paids;

    constructor() ERC721("Paid", "PAID") Ownable(msg.sender) {}

    /**
     * @dev Creates a new paid content item.
     * @param memberAddress The address of the member who owns the paid content item.
     * @param creatorAddress The address of the creator of the paid content item.
     * @param url The URI of the paid content item.
     * @param description The description of the paid content item.
     */
    function createPaid(address memberAddress, address creatorAddress, string memory url, string memory description) public onlyOwner {
        _paidIdCounter.increment();
        uint256 newPaidId = _paidIdCounter.current();
        paids[newPaidId] = PaidData(newPaidId, memberAddress, creatorAddress, url, description);
        _mint(memberAddress, newPaidId);
    }

    /**
     * @dev Retrieves the information of a paid content item.
     * @param paidId The ID of the paid content item.
     * @return The ID, member address, creator address, URI, and description of the paid content item.
     */
    function getPaid(uint256 paidId) public view returns (uint256, address, address, string memory, string memory) {
        PaidData memory paid = paids[paidId];
        return (paid.id, paid.memberAddress, paid.creatorAddress, paid.uri, paid.description);
    }
}