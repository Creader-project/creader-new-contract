pragma solidity ^0.5.0;

contract CreaderCoin {
    string public name = "Creader Coin";
    string public symbol = "CC";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000;

    mapping(address => uint256) public balances;

    constructor() public {
        balances[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance.");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}
