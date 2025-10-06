// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Tokle} from "../src/Tokle.sol";
import {TestToken} from "../src/TestToken.sol";

contract TokleTest is Test {
    TestToken public token;
    Tokle public tokle;
    address user = address(0x123);

    uint256 costPerTry = 1e18;

    function setUp() public {
        token = new TestToken("My Test Token", "MTT", 1000e18);
        tokle = new Tokle(user, address(token), "apple", costPerTry);

        token.mintToken(user, 10e18);

        vm.prank(user);
        token.approve(address(tokle), 1000e18);

        token.mintToken(address(tokle), 10e18);
    }

    // Test registering a wrong guess
    function testRegisterWrongGuess() public {
        vm.prank(user);
        tokle.tryGuess("alert");

        // Assert the guess register
        string[] memory guesses = tokle.getGuesses();
        assertEq(guesses.length, 1);
        assertEq(guesses[0], "alert");
        assertEq(tokle.getTries(), 4);

        // Assert the balance of tokens
        assertEq(token.balanceOf(user), 9e18);
        assertEq(token.balanceOf(address(tokle)), 11e18);
    }

    // Test winning the game
    function testWinGame() public {
        vm.prank(user);
        tokle.tryGuess("apple");

        assertEq(tokle.getTries(), 0);

        assertEq(token.balanceOf(user), 15e18);
    }

    // Test multiple guesses then win
    function testMultipleGuessesThenWin() public {
        vm.prank(user);
        tokle.tryGuess("alert");

        vm.prank(user);
        tokle.tryGuess("angle");

        // Two wrong guesses => tries left = 3
        assertEq(tokle.getTries(), 3);

        // User token balance after 2 guesses: 10 - 2 = 8
        assertEq(token.balanceOf(user), 8e18);

        vm.prank(user);
        tokle.tryGuess("apple");

        // Remaining tries = 0
        assertEq(tokle.getTries(), 0);

        // Refund = 3 tries left * 1 token = 3
        // User balance = 8 + 3 = 11
        assertEq(token.balanceOf(user), 11e18);
    }

    // Test that game cannot accept more guesses after finishing
    function testCannotGuessAfterGameOver() public {
        vm.prank(user);
        tokle.tryGuess("apple"); // win

        vm.prank(user);
        vm.expectRevert("no tries left");
        tokle.tryGuess("alert");
    }
}
