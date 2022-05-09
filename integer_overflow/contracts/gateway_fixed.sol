// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

import "./SafeMath.sol";

contract Gateway_Fix {

  using SafeMath for uint;

  mapping(address => uint) public balances;
  uint public totalSupply;

  constructor() payable {
    balances[msg.sender] = totalSupply = msg.value;
  }

  function send(address to, uint value) public returns (bool) {
    require(balances[msg.sender].sub(value) >= 0);
    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);
    return true;
  }

  function deposit() public payable returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(msg.value);
    totalSupply = totalSupply.add(msg.value);
    return true;
  }

  function withdraw() public returns (bool) {
    require(balances[msg.sender] > 0);
    bool ret = payable(msg.sender).send(balances[msg.sender]);
    totalSupply = totalSupply.sub(balances[msg.sender]);
    balances[msg.sender] = 0;
    return ret;
  }

}