pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract CreaderCoinSwap {
    using SafeMath for uint256;

    ERC20 public usdc;
    ERC20 public usdt;
    CreaderCoin public cc;

    constructor(
        address _usdc,
        address _usdt,
        address _cc
    ) public {
        usdc = ERC20(_usdc);
        usdt = ERC20(_usdt);
        cc = CreaderCoin(_cc);
    }

    function swapUSDCForCC(uint256 _amount) public {
        require(usdc.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        cc.transfer(msg.sender, _amount.mul(1 ether));
    }

    function swapUSDTForCC(uint256 _amount) public {
        require(usdt.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        cc.transfer(msg.sender, _amount.mul(1 ether));
    }

    function swapCCForUSDC(uint256 _amount) public {
        require(cc.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        usdc.transfer(msg.sender, _amount.div(1 ether));
    }

    function swapCCForUSDT(uint256 _amount) public {
        require(cc.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        usdt.transfer(msg.sender, _amount.div(1 ether));
    }
}

