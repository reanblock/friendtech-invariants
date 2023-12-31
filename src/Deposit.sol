// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";

contract Deposit {
    address public seller = msg.sender;
    mapping(address => uint256) public balance;

    function deposit() external payable {
        console2.log("Depoist msg.value: ", msg.value);
        balance[msg.sender] += msg.value;
        // console2.log(payable(address(this)).balance);
    }

    function withdraw() external {
        uint256 amount = balance[msg.sender];
        balance[msg.sender] = 0;
        (bool s, ) = msg.sender.call{value: amount}("");
        require(s, "failed to send");
    }

    /*  
        Uncomment to introduce a vulnerability
        here changeBalance allows anyone to update the balance
        of any depositor in the balance mapping!

        This will cause the invariant_alwaysWithdrawable to fail!
    */
    // function changeBalance(address depositor, uint amount) public {
    //     balance[depositor] = amount;
    // }
}