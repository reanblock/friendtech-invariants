pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DepositHandler} from "./DepositHandler.t.sol";
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
}