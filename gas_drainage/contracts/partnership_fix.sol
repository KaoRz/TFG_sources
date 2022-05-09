// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Partnership_Fix {

    address payable public partner;
    address payable public owner;
    uint public timeLastWithdrawn;
    uint public gasLimit;
    mapping(address => uint) withdrawPartnerBalances;

    constructor(uint _gasLimit) payable {
        require(_gasLimit > 2300);
        owner = payable(msg.sender);
        gasLimit = _gasLimit;
    }

    function setPartner(address payable _partner) public {
        require(msg.sender == owner);
        partner = _partner;
    }

    function setGasLimit(uint _gasLimit) public {
        require(msg.sender == owner && _gasLimit > 2300);
        gasLimit = _gasLimit;
    }

    function withdraw() public returns (bool) {
        uint amountToSend = address(this).balance / uint(100);
        (bool sent, ) = partner.call{value:amountToSend, gas:gasLimit}("");
        owner.transfer(amountToSend);
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
        return sent;
    }

    receive() external payable {}

}