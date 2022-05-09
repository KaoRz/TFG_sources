// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Guess {

  bytes32 constant public hash = 0xfed86ea1fff561ad70db0b9100188dbb26b4b0c0312c3927aa5bb7eecc37e73f;
  address public winner;
  bool public ongoing;

  constructor() payable {
    ongoing = true;
  }

  function guess(string memory solution) public returns (bool) {
    require(ongoing && keccak256(abi.encodePacked(solution)) == hash);
    (bool ret, ) = msg.sender.call{value: address(this).balance}("");
    require(ret == true);
    winner = msg.sender;
    ongoing = false;
    return ret;
  }

}