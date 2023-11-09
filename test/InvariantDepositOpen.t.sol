// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Deposit} from "../src/Deposit.sol";

contract InvariantDepositOpen is Test {
    Deposit deposit;

    function setUp() external {
        deposit = new Deposit();
        vm.deal(address(deposit), 100 ether);
    }

    // note this invariant passess because in open 
    // invariant testing the msg.value is always zero
    function invariant_alwaysHas100Eth() external {
        if(address(deposit).balance > 0) {
            assertEq(address(deposit).balance, 100 ether);
        }
    }
  
    /// forge-config: default.invariant.runs = 500
    /// forge-config: default.invariant.depth = 100
    function invariant_alwaysWithdrawable() external payable {
        deposit.deposit{value: 1 ether}();
        uint256 balanceBefore = deposit.balance(address(this));
        assertEq(balanceBefore, 1 ether);
        deposit.withdraw();
        uint256 balanceAfter = deposit.balance(address(this));
        assertGt(balanceBefore, balanceAfter);
    }

    // function test_Sanity() public {
    //     console2.log("My Balance b4: ", payable(address(this)).balance);
    //     assertEq(address(deposit).balance, 100 ether);
    //     deposit.deposit{value: 0 ether}();
    //     assertEq(address(deposit).balance, 100 ether);
    //     console2.log("My Balance after: ", payable(address(this)).balance);
    //     deposit.withdraw();
    //     assertEq(address(deposit).balance, 100 ether);
    //     console2.log("My Balance after 1 withdraw: ", payable(address(this)).balance);
    //     deposit.withdraw();
    //     deposit.withdraw();
    //     deposit.withdraw();
    //     deposit.withdraw();
    //     console2.log("My Balance after several withdraw: ", payable(address(this)).balance);
    // }

    receive() external payable {}
}