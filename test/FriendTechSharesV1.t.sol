// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FriendtechSharesV1} from "../src/FriendtechSharesV1.sol";

contract FriendtechSharesV1Test is Test {
    FriendtechSharesV1 public friendtech;

    function setUp() public {
        friendtech = new FriendtechSharesV1();
    }
}
