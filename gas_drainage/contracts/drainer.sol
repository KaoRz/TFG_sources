// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Drainer {

    receive() external payable {
        while(true) {}
    }

}