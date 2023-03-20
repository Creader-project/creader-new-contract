// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./CreaderV2Copyright.sol";

contract AccessRights is ERC1155, Pausable {
    uint256 public constant MINTING_COST = 0.1 ether;
    address public treasuryVault;
    address public admin;
    mapping(uint256 => address) public copyrightMapping;

    constructor(address _treasuryVault)
        ERC1155("https://api.example.com/metadata/{id}.json")
    {
        treasuryVault = _treasuryVault;
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data,
        address copyrightOwner
    ) external payable whenNotPaused {
        require(msg.value >= MINTING_COST, "Insufficient minting cost provided");

        uint256 halfMintingCost = MINTING_COST / 2;

        (bool ownerSuccess, ) = copyrightOwner.call{value: halfMintingCost}("");
        require(ownerSuccess, "Payment to copyright owner failed");

        (bool treasurySuccess, ) = treasuryVault.call{value: halfMintingCost}("");
        require(treasurySuccess, "Payment to treasury vault failed");

        uint256 refund = msg.value - MINTING_COST;
        if (refund > 0) {
            (bool refundSuccess, ) = msg.sender.call{value: refund}("");
            require(refundSuccess, "Refund failed");
        }

        _mint(account, id, amount, data);
        copyrightMapping[id] = copyrightOwner;
    }

    function updateTreasuryVault(address _newTreasuryVault) external onlyAdmin {
        treasuryVault = _newTreasuryVault;
    }

    function pause() external onlyAdmin {
        _pause();
    }

    function unpause() external onlyAdmin {
        _unpause();
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
