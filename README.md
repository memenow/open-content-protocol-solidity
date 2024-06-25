# open-content-protocol-solidity

This project implements the Open Content Protocol (OCP) using Solidity smart contracts. It provides a framework for managing creators, subscribers, members, posts, and paid content on the Ethereum blockchain.

## Overview

The Open Content Protocol Solidity project aims to create a decentralized, censorship-resistant content value network for content providers and individual creators using Ethereum smart contracts.

## Contracts

The project consists of the following main contracts:

1. **Creator**: Manages creator information and associated platform addresses.
2. **Subscriber**: Handles subscriber management using ERC721 tokens.
3. **Member**: Manages member subscriptions using ERC1155 tokens.
4. **Post**: Manages posts using ERC721 tokens.
5. **PostKey**: Handles post keys using ERC1155 tokens.
6. **Paid**: Manages paid content using ERC721 tokens.

## Features

- Creator registration and management
- Subscriber creation and tracking
- Membership system with expiration and renewal
- Post creation and management
- Post key system for content access control
- Paid content management

## Setup

1. Clone the repository:
   ```
   git clone https://github.com/memenow/open-content-protocol-solidity.git
   ```

2. Compile the contracts:
   ```
   npx hardhat compile
   ```

## Usage

Here's a brief overview of how to use the main contracts:

### Creator

```solidity
// Create a new creator
function createCreator(address creatorAddress, address platformAddress) public

// Get creator information
function getCreator(address creatorAddress) public view returns (address, address)
```

### Subscriber

```solidity
// Create a new subscriber
function createSubscriber(address subscriber, address creator, string memory uri) public onlyOwner returns (uint)
```

### Member

```solidity
// Create a new member
function createMember(address member, address creatorAddress, uint feeIndex) public payable onlyOwner returns (uint)

// Renew membership
function renewMember(uint memberId, address creatorAddress, uint feeIndex) public payable
```

### Post

```solidity
// Create a new post
function createPost(address creator, uint postKeyId, string memory uri) public onlyOwner returns (uint)

// Get post data
function getPostData(uint postId) public view returns (PostData memory)
```

### PostKey

```solidity
// Mint a new post key
function mintPostKey(address creator) public onlyOwner
```

### Paid

```solidity
// Create new paid content
function createPaid(address memberAddress, address creatorAddress, string memory url, string memory description) public onlyOwner

// Get paid content information
function getPaid(uint256 paidId) public view returns (uint256, address, address, string memory, string memory)
```

## License

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
