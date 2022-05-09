// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Partnership {

    address payable public partner;
    address payable public owner;
    uint public timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function setPartner(address payable _partner) public {
        partner = _partner;
    }

    function withdraw() public returns (bool) {
        uint amountToSend = address(this).balance / uint(100);
        (bool sent, ) = partner.call{value:amountToSend}("");
        owner.transfer(amountToSend);
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
        return sent;
    }

    receive() external payable {}

}