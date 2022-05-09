// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./ReentrancyGuard.sol";

contract Sale_Fix is ReentrancyGuard {

    uint256 public constant PRICE = 0.01 ether;
    mapping(address => uint256) private tickets;

    function buyTickets(uint256 n_tickets) external payable {
        require(msg.value >= n_tickets * PRICE);
        tickets[msg.sender] += n_tickets;
    }

// ...

    function getRefund() external payable {
        require(tickets[msg.sender] > 0);
        uint tmp_tickets = tickets[msg.sender];
        tickets[msg.sender] = 0;
        (bool ret, ) = msg.sender.call{value: tmp_tickets * PRICE}("");
        require(ret, "Ticket refund failed");
    }

// ...

    receive() external payable {}
}