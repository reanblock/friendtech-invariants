// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FriendTechHandler} from "./handlers/FriendTechHandler.t.sol";
import {FriendtechSharesV1} from "../src/FriendtechSharesV1.sol";

contract FriendtechSharesV1Test is Test {
    FriendtechSharesV1 public friendtech;
    FriendTechHandler public handler;

    function setUp() public {
        friendtech = new FriendtechSharesV1();
        vm.deal(address(this), 100 ether);

        handler = new FriendTechHandler(friendtech);
        targetContract(address(handler));

        // ititiate the shares supply
        friendtech.buyShares{value: 0}(address(this), 1);
        assertEq(friendtech.sharesSupply(address(this)), 1);
    }

    function test_canBuyShares() public {
        // price for 100 shares is 21.146875
        friendtech.buyShares{value: 22 ether}(address(this), 100); 
        // should be 101 shares 
        assertEq(friendtech.sharesSupply(address(this)), 101);

        // console2.log(friendtech.sharesBalance(address(this), address(this)));
    }

    function test_canSellShares() public {
        // need to buy some shares first (100)
        friendtech.buyShares{value: 22 ether}(address(this), 100);
        // now sell 10 of these shares
        friendtech.sellShares(address(this), 10);
        // should be 91 remaining
        assertEq(friendtech.sharesSupply(address(this)), 91);
    }

    function test_sharesSupplyAlwaysEqTotalSharesBalance() public {
        friendtech.buyShares{value: 22 ether}(address(this), 100); // test contract buys 100
        // console2.log(friendtech.getBuyPrice(address(this), 50));
        hoax(address(0xaa), 100 ether);
        friendtech.buyShares{value: 50 ether}(address(this), 50); // Alice buys 50
        uint256 sharesBalanceOfTestContract = friendtech.sharesBalance(address(this), address(this));
        uint256 sharesBalanceOfAlice = friendtech.sharesBalance(address(this), address(0xaa));
        uint256 totalSharesSupplyOfSubject = friendtech.sharesSupply(address(this));
        // console2.log("sharesBalanceOfTestContract: ", sharesBalanceOfTestContract);
        // console2.log("sharesBalanceOfAlice: ", sharesBalanceOfAlice);
        // console2.log("totalSharesSupplyOfSubject: ", totalSharesSupplyOfSubject);

        assertEq(sharesBalanceOfTestContract + sharesBalanceOfAlice, totalSharesSupplyOfSubject);
    }

    /// forge-config: default.invariant.runs = 10
    /// forge-config: default.invariant.depth = 5
    function invariant_totalSharesSupplyAlwaysEqTotalSharesBalance()  public {
        // the total subject shares supply should always eq 
        // the sum of the total of shares balance for each holder
        uint256 sharesSubjectsLength = handler.sharesSubjectsLength();
        uint256 totalSharesSupply;
        uint256 shareHolderSupply;

        for(uint i; i<sharesSubjectsLength; ++i) {
            address shareSubject = handler.sharesSubjects(i);
            totalSharesSupply += friendtech.sharesSupply(shareSubject);
            
            uint256 shareHoldersLength = handler.shareHoldersLength(shareSubject);
            console2.log("share holders length: ", shareHoldersLength);

            for(uint j; j<shareHoldersLength; ++j) {
                address shareHolder = handler.shareSubjectToShareHolderMapping(shareSubject, j);
                shareHolderSupply += friendtech.sharesBalance(shareSubject, shareHolder); 
            }
            // shareHolderSupply = shareHolderSupply + 1; // + 1 for the initial share!
        }

        console2.log("Total Shares Supply: ", totalSharesSupply);
        console2.log("Total Share Holders Supply: ", shareHolderSupply);

        assertEq(totalSharesSupply, shareHolderSupply); 
    }

    receive() external payable {}
}
