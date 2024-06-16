// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PostKey.sol";

/**
 * @title Post
 * @dev Manage posts using ERC721 tokens.
 */
contract Post is ERC721URIStorage, Ownable {
    uint public postCounter;
    PostKey public postKeyContract;

    mapping(uint => address) public postCreators;
    mapping(uint => uint) public postKeyIds;

    struct PostData {
        uint postId;
        address creator;
        uint postKeyId;
        string uri;
    }

    event PostCreated(uint indexed postId, address indexed creator, uint indexed postKeyId);

    /**
     * @dev Initializes the Post contract.
     * @param postKeyContractAddress The address of the PostKey contract.
     */
    constructor(address postKeyContractAddress) ERC721("OpenContentProtocolPost", "OCPP") Ownable(msg.sender) {
        postKeyContract = PostKey(postKeyContractAddress);
    }

    /**
     * @dev Creates a new Post.
     * @param creator The address of the post creator.
     * @param postKeyId The ID of the post key associated with the post.
     * @param uri The URI of the post content.
     * @return The ID of the created post.
     */
    function createPost(address creator, uint postKeyId, string memory uri) public onlyOwner returns (uint) {
        require(postKeyId > 0, "Invalid postKeyId");
        require(postKeyContract.balanceOf(creator, postKeyId) > 0, "Creator does not own the specified postKey");

        postCounter++;
        postCreators[postCounter] = creator;
        postKeyIds[postCounter] = postKeyId;
        _safeMint(creator, postCounter);
        _setTokenURI(postCounter, uri);
        emit PostCreated(postCounter, creator, postKeyId);
        return postCounter;
    }

    /**
     * @dev Checks if a post exists.
     * @param postId The ID of the post to check.
     * @return A boolean indicating whether the post exists or not.
     */
    function postExists(uint256 postId) public view returns (bool) {
        return ownerOf(postId) != address(0);
    }

    /**
     * @dev Retrieves the data of a post.
     * @param postId The ID of the post to retrieve data for.
     * @return The PostData struct containing the post information.
     */
    function getPostData(uint postId) public view returns (PostData memory) {
        require(postExists(postId), "Post does not exist");
        return PostData(postId, postCreators[postId], postKeyIds[postId], tokenURI(postId));
    }
}