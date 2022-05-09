// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

contract Gateway {

  mapping(address => uint) public balances;
  uint public totalSupply;

  constructor() payable {
    balances[msg.sender] = totalSupply = msg.value;
  }

  function send(address to, uint value) public returns (bool) {
    require(balances[msg.sender] - value >= 0);
    balances[msg.sender] -= value;
    balances[to] += value;
    return true;
  }

  function deposit() public payable returns (bool) {
    balances[msg.sender] += msg.value;
    totalSupply += msg.value;
    return true;
  }

  function withdraw() public returns (bool) {
    require(balances[msg.sender] > 0);
    bool ret = payable(msg.sender).send(balances[msg.sender]);
    totalSupply -= balances[msg.sender];
    balances[msg.sender] = 0;
    return ret;
  }

}