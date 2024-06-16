// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Subscriber
 * @dev Manage subscribers using ERC721 tokens.
 */
contract Subscriber is ERC721URIStorage, Ownable {
    uint public subscriberCounter;
    mapping(uint => address) public subscriberCreators;

    event SubscriberCreated(uint indexed subscriberId, address indexed subscriber, address indexed creator);

    /**
     * @dev Constructor function that initializes the ERC721 token with the name "OpenContentProtocolSubscriber"
     *      and the symbol "OCPS". It also sets the contract deployer as the initial owner.
     */
    constructor() ERC721("OpenContentProtocolSubscriber", "OCPS") Ownable(msg.sender) {}

    /**
     * @dev Creates a new subscriber with the given subscriber address, creator address, and URI.
     *      Only the contract owner can call this function.
     * @param subscriber The address of the subscriber.
     * @param creator The address of the creator.
     * @param uri The URI for the subscriber's metadata.
     * @return The ID of the newly created subscriber.
     */
    function createSubscriber(address subscriber, address creator, string memory uri) public onlyOwner returns (uint) {
        subscriberCounter++;
        _safeMint(subscriber, subscriberCounter);
        _setTokenURI(subscriberCounter, uri);
        subscriberCreators[subscriberCounter] = creator;
        emit SubscriberCreated(subscriberCounter, subscriber, creator);
        return subscriberCounter;
    }
}