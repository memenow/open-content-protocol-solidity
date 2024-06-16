// SPDX-License-Identifier: Apache-2.0

/**
 * @title Creator
 * @dev Manage creators and their associated platform addresses.
 */
pragma solidity >=0.7.0 <0.9.0;

contract Creator {
    struct CreatorData {
        address creatorAddress;
        address platformAddress;
    }

    mapping(address => CreatorData) public creators;

    /**
     * @dev Creates a new creator.
     * @param creatorAddress Address of the creator.
     * @param platformAddress Address of the associated platform.
     */
    function createCreator(address creatorAddress, address platformAddress) public {
        require(creators[creatorAddress].creatorAddress == address(0), "Creator already exists");
        creators[creatorAddress] = CreatorData(creatorAddress, platformAddress);
    }

    /**
     * @dev Retrieves creator information.
     * @param creatorAddress Address of the creator.
     * @return (creatorAddress, platformAddress) Tuple of creator address and platform address.
     */
    function getCreator(address creatorAddress) public view returns (address, address) {
        CreatorData memory creator = creators[creatorAddress];
        return (creator.creatorAddress, creator.platformAddress);
    }
}