// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
interface ICreaderV2Factory {
    function createContract(string memory _name, address _owner) external;
    function updateContract(address _contract, string memory _name) external;
}