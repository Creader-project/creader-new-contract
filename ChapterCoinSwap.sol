pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract CreaderCoinChapterStore {
    using SafeMath for uint256;

    struct Chapter {
        string name;
        uint256 price;
    }

    CreaderCoin public cc;
    mapping(uint256 => Chapter) public chapters;
    mapping(address => mapping(uint256 => bool)) public purchasedChapters;

    constructor(address _cc) public {
        cc = CreaderCoin(_cc);
        // add some chapters for sale
        chapters[1] = Chapter("Chapter 1", 100);
        chapters[2] = Chapter("Chapter 2", 150);
        chapters[3] = Chapter("Chapter 3", 200);
    }

    function purchaseChapter(uint256 _chapterId) public {
        Chapter storage chapter = chapters[_chapterId];
        require(chapter.price > 0, "Chapter not found.");
        require(cc.transferFrom(msg.sender, address(this), chapter.price), "Transfer failed.");
        purchasedChapters[msg.sender][_chapterId] = true;
    }

    function getChapter(uint256 _chapterId) public view returns (string memory name, uint256 price, bool purchased) {
        Chapter storage chapter = chapters[_chapterId];
        name = chapter.name;
        price = chapter.price;
        purchased = purchasedChapters[msg.sender][_chapterId];
    }
}
