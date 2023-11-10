// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

import {FriendtechSharesV1} from "../../src/FriendtechSharesV1.sol";

contract FriendTechHandler is CommonBase, StdCheats, StdUtils {
    FriendtechSharesV1 private friendtech;
    constructor(FriendtechSharesV1 _friendtech) {
        friendtech = _friendtech;
        vm.deal(address(this), 10000 ether);
    }

    function buyShares(address sharesSubject, uint8 amount) public {
        if(friendtech.sharesSupply(sharesSubject) == 0) {
            // hoax the sharesSubject as a new account and initialize the first share   
            hoax(sharesSubject, 10000 ether);
            friendtech.buyShares{value: 0}(sharesSubject, 1);
        }
        uint256 price = friendtech.getBuyPrice(sharesSubject, amount);
        friendtech.buyShares{value: price}(sharesSubject, amount);
    }

    receive() external payable {}

    // function sellShares() public {

    // }

    // function depositAmount(uint256 amount) public {
    //     amount = bound(amount, 0, address(this).balance);
    //     deposit.deposit{value: amount}();
    // }

    // function withdraw() public {
    //     deposit.withdraw();
    // }
}