// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

import {FriendtechSharesV1} from "../../src/FriendtechSharesV1.sol";

contract FriendTechHandler is CommonBase, StdCheats, StdUtils {
    FriendtechSharesV1 private friendtech;

    // keep track of the share subjects and the share holders
    address[] public sharesSubjects;
    mapping(address => bool) shareSubjectsMapping;
    mapping(address => address[]) public shareSubjectToShareHolderMapping;
    
    constructor(FriendtechSharesV1 _friendtech) {
        friendtech = _friendtech;
        vm.deal(address(this), 10000 ether);
    }

    function buyShares(address sharesSubject, uint8 amount) public {
        if(friendtech.sharesSupply(sharesSubject) == 0) {
            // hoax the sharesSubject as a new account and initialize the first share   
            hoax(sharesSubject, 1 ether);
            friendtech.buyShares{value: 0}(sharesSubject, 1);
            
            addShare(sharesSubject, sharesSubject);
        }
        
        uint256 price = friendtech.getBuyPrice(sharesSubject, amount);
        hoax(msg.sender, price);
        friendtech.buyShares{value: price}(sharesSubject, amount);

        addShare(sharesSubject, msg.sender);
    }



    // @todo implement to complete the test!
    // function sellShares(uint256 sharesIndex, uint8 amount) public {
    //     if(sharesSubjects.length > 0 ){
    //         sharesIndex= bound(sharesIndex, 0, sharesSubjects.length-1);
    //         address sharesSubject = sharesSubjects[sharesIndex];
    //         // address sharesHolders = shareHolders[sharesIndex];
    //         address shareHolder = shareSubjectToShareHolderMapping[sharesSubject];
    //         // shareHolderIndex = bound(shareHolderIndex, 0, shareHoldersForSubject.length -1);
    //         // address shareHolder = shareHoldersForSubject[shareHolderIndex];
    //         // console2.log("No. of share holders: ", shareHoldersForSubject.length);
    //         // console2.log("The chosen share holder is: ", shareHolder);
    //         console2.log("Own shares?: ", friendtech.sharesBalance(sharesSubject, shareHolder));

    //         // for(uint256 i; i< shareHoldersForSubject.length;) {
    //             // console2.log("shareHolders: ", shareHoldersForSubject[i]);
    //             // ++i;
    //         // }

    //         // console2.log("Selling index: ", sharesIndex);
    //         console2.log("Selling shares: ", sharesSubject, amount);
    //         // vm.prank(msg.sender);
    //         // console2.log("Own shares?: ", shareSubjectsMapping[sharesSubject]);
    //         // vm.prank(msg.sender);
    //         // friendtech.sellShares(sharesSubject, amount);
    //     }
    // }

    // Helpers //

    function addShare(address sharesSubject, address shareHolder) private {
        shareSubjectToShareHolderMapping[sharesSubject].push(shareHolder);

        if (!shareSubjectsMapping[sharesSubject]) {
            sharesSubjects.push(sharesSubject);
            shareSubjectsMapping[sharesSubject] = true;
        }
    }
    function sharesSubjectsLength() public view returns(uint) {
        return sharesSubjects.length;
    }

    function shareHoldersLength(address sharesSubject) public view returns(uint) {
        return shareSubjectToShareHolderMapping[sharesSubject].length;
    }

}