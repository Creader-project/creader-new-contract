// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//openzeppelin access control
import "./interface/ICreaderV2Factory.sol";
import "./CreaderV2Copyright.sol";
import "hardhat/console.sol";

contract CreaderV2factory {

    address public owner;
    uint public total;

    mapping(address => mapping(uint => address)) public copyrightInfo;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    // function createCopyright(
    //     address author
    // ) external returns (address){
    //     CreaderV2Copyright newCopyright = new CreaderV2Copyright(author, owner);
    //     address newAddress = address(newCopyright);
    //     copyrightInfo[author][total] = newAddress;
    //     console.log("newCopyright address: %s", newAddress);
    //     total++;
    //     return newAddress;
    // }
}
