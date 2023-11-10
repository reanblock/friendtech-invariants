// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

import {FriendtechSharesV1} from "../../src/FriendtechSharesV1.sol";

contract FriendTechHandler is CommonBase, StdCheats, StdUtils {
    FriendtechSharesV1 private friendtech;

    // keep track of the distinct share subjects and share holders
    address[] public sharesSubjects;
    address[] public shareHolders;

    mapping(address => bool) shareSubjectsMapping;
    mapping(address => bool) shareHoldersMapping;
    
    constructor(FriendtechSharesV1 _friendtech) {
        friendtech = _friendtech;
        vm.deal(address(this), 10000 ether);
    }

    function buyShares(address sharesSubject, uint8 amount) public {
        if(friendtech.sharesSupply(sharesSubject) == 0) {
            // hoax the sharesSubject as a new account and initialize the first share   
            hoax(sharesSubject, 1 ether);
            friendtech.buyShares{value: 0}(sharesSubject, 1);
            // add the sharesSubject to the sharesHolder list since they
            // will always own the first share
            addShareHolder(sharesSubject);
        }
        uint256 price = friendtech.getBuyPrice(sharesSubject, amount);
        hoax(msg.sender, price);
        friendtech.buyShares{value: price}(sharesSubject, amount);

        addSharesSubject(sharesSubject);
        addShareHolder(msg.sender);
    }

    // @todo implement to complete the test!
    // function sellShares() public {

    // }

    // Helpers //
    function sharesSubjectsLength() public view returns(uint) {
        return sharesSubjects.length;
    }
    function shareHoldersLength() public view returns(uint) {
        return shareHolders.length;
    }

    function addShareHolder(address shareHolder) private {
        if (!shareHoldersMapping[shareHolder]) {
            shareHolders.push(shareHolder);
        }
        shareHoldersMapping[shareHolder] = true;
    }

    function addSharesSubject(address sharesSubject) private {
        if (!shareSubjectsMapping[sharesSubject]) {
            sharesSubjects.push(sharesSubject);
        }
        shareSubjectsMapping[sharesSubject] = true;
    }
}