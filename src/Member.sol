// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Creator.sol";

/**
 * @title Member
 * @dev Manage member subscriptions using ERC1155 tokens.
 */
contract Member is ERC1155, Ownable {
    uint public memberCounter;
    mapping(uint => uint) public memberExpiry;
    mapping(uint => address) public memberOwners;
    Creator public creatorContract;

    event MemberCreated(uint indexed memberId, address indexed member, uint expiry);

    constructor(address _creatorContract) ERC1155("https://api.memenow.xyz/v1/members/{id}") Ownable(msg.sender) {
        creatorContract = Creator(_creatorContract);
    }

    /**
     * @dev Creates a new member.
     * @param member Address of the member.
     * @param creatorAddress Address of the creator.
     * @param feeIndex Index of the membership fee.
     */
    function createMember(address member, address creatorAddress, uint feeIndex) public payable onlyOwner returns (uint) {
        ( , , uint256[] memory membershipFees) = creatorContract.getCreator(creatorAddress);
        require(feeIndex < membershipFees.length, "Invalid fee index");
        require(msg.value == membershipFees[feeIndex], "Incorrect membership fee");

        memberCounter++;
        uint expiry = block.timestamp + 30 days; // assuming a 30-day membership period
        memberExpiry[memberCounter] = expiry;
        memberOwners[memberCounter] = member;
        _mint(member, memberCounter, 1, "");
        emit MemberCreated(memberCounter, member, expiry);
        return memberCounter;
    }

    /**
     * @dev Checks if a member's subscription has expired.
     * @param memberId ID of the member.
     * @return bool True if the membership is still valid, false otherwise.
     */
    function checkMemberExpiry(uint memberId) public view returns (bool) {
        return block.timestamp <= memberExpiry[memberId];
    }

    /**
     * @dev Renews a member's subscription.
     * @param memberId ID of the member.
     * @param creatorAddress Address of the creator.
     * @param feeIndex Index of the membership fee.
     */
    function renewMember(uint memberId, address creatorAddress, uint feeIndex) public payable {
        require(block.timestamp <= memberExpiry[memberId], "Member has expired");

        ( , , uint256[] memory membershipFees) = creatorContract.getCreator(creatorAddress);
        require(feeIndex < membershipFees.length, "Invalid fee index");
        require(msg.value == membershipFees[feeIndex], "Incorrect membership fee");

        memberExpiry[memberId] += 30 days; // assuming a 30-day membership period
        emit MemberCreated(memberId, memberOwners[memberId], memberExpiry[memberId]);
    }
}