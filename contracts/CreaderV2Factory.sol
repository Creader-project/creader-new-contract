// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//openzeppelin access control
import "./interface/ICreaderV2Factory.sol";
import "./CreaderV2Copyright.sol";

contract CreaderV2factory is ICreaderV2Factory,  {

    address public _owners;

    mapping(address => mapping(address => address)) public copyrightInfo;

    constructor() {
        _owners = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owners, "Ownable: caller is not the owner");
        _;
    }

    function setOwner(address _owner) public onlyOwner {
        _owners = _owner;
    }

    function createCopyright(
        address author
    ) external return (address) {
        address newCopyright = new CreaderV2Copyright(author);
        return newCopyright;
    }

}
