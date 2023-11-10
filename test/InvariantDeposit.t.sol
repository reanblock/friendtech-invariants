pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DepositHandler} from "./handlers/DepositHandler.t.sol";
import {Deposit} from "../src/Deposit.sol";

contract InvariantDepositHandler is Test {
    Deposit public deposit;
    DepositHandler public handler;

    function setUp() public {
        deposit = new Deposit();
        vm.deal(address(deposit), 100 ether);
        handler = new DepositHandler(deposit);

        targetContract(address(handler));
    }

    // This invariant will NOT pass because the DepositHandler
    // is able to send value to the deposit function now!
    // function invariant_alwaysHas100Eth() external {
    //     assertEq(address(deposit).balance, 100 ether);
    // }

    function invariant_alwaysWithdrawable() external payable {
        deposit.deposit{value: 1 ether}();
        uint256 balanceBefore = deposit.balance(address(this));
        assertEq(balanceBefore, 1 ether);
        deposit.withdraw();
        uint256 balanceAfter = deposit.balance(address(this));
        assertGt(balanceBefore, balanceAfter);
    }

    receive() external payable {}
}