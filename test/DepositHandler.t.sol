// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

import {Deposit} from "../src/Deposit.sol";

contract DepositHandler is CommonBase, StdCheats, StdUtils {
    Deposit private deposit;
    constructor(Deposit _deposit) {
        deposit = _deposit;
        vm.deal(address(this), 100 ether);
    }

    function depositAmount(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        deposit.deposit{value: amount}();
    }

    function withdraw() public {
        deposit.withdraw();
    }
}