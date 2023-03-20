// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
contract CreaderV2Copyright is ERC721 {

    uint256 public nextTokenId;
    address public owner;
    address public admin;

    struct CopyrightData {
        uint256 id;
        string title;
        string description;
        string status;
        address owner;
    }

    mapping(uint256 => CopyrightData) public copyrightData;

    constructor(address _author, address _admin)
        ERC721("Copyright Token", "CPT")
    {
        owner = _author;
        admin = _admin;
        mint("test", "test");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    function mint(string memory _title, string memory _description)
        public
        returns (bool)
    {
        uint256 newItemId = nextTokenId;
        _safeMint(owner, newItemId);
        copyrightData[newItemId] = CopyrightData(
            newItemId,
            _title,
            _description,
            "pending",
            owner
        );
        nextTokenId++;
        console.log("newItemId: %s", newItemId);
        console.log("minted");
        return true;
    }
}
