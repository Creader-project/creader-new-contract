// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
interface ICreaderV2Factory {
    function createCopyright(address author) external returns (address);
}