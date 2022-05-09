// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Hill_Fix {

  address payable public king;
  uint public prize;
  address payable public owner;

  modifier SenderIsOrigin() {
    require(msg.sender == tx.origin);
    _;
  }

  constructor() payable {
    owner = payable(msg.sender);  
    king = payable(msg.sender);
    prize = msg.value;
  }

  receive() external payable SenderIsOrigin() {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = payable(msg.sender);
    prize = msg.value;
  }
}