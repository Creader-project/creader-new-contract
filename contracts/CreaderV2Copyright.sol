// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreaderV2Copyright {

    address public author;
    address public owner;

    constructor(address _author) {
        author = _author;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function setAuthor(address _author) public onlyOwner {
        author = _author;
    }
    
}