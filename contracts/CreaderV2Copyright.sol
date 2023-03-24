// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";


contract CreaderV2Copyright is ERC721, ERC721Enumerable, ERC721URIStorage {

    uint64 private _currentTokenId = 0;


    struct Novel {
        uint256 id;
        string title;
        string description;
        NovelStatus status;
        address owner;
    }

    enum NovelStatus {
        Draft,
        Published,
        Deleted
    }

    mapping(uint256 => Novel) public novelData;

    constructor()
        ERC721("Copyright Token", "CPT")
    {
    }


    function _baseURI() internal pure override returns (string memory) {
        return "https://test.test";
    }


    function mint(string memory _tokenURI)
        public
        returns (uint256)
    {
        uint64 newItemId = _currentTokenId;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        Novel memory novel = Novel({
            id: newItemId,
            title: "test",
            description: "test",
            status: NovelStatus.Draft,
            owner: msg.sender
        });

        novelData[newItemId] = novel;

        console.log('minted');
        _currentTokenId++;
        return newItemId;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}