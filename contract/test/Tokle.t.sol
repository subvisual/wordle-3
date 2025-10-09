// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Tokle} from "../src/Tokle.sol";
import {TestToken} from "../src/TestToken.sol";

contract TokleTest is Test {
    TestToken public token;
    Tokle public tokle;
    address user1 = address(0x123);
    address user2 = address(0x456);

    function setUp() public {
        token = new TestToken("My Test Token", "MTT", 1000e18);
        tokle = new Tokle(address(token), 1e18);

        bytes32 hashWord = keccak256(abi.encodePacked("apple"));
        tokle.setTargetWord(hashWord);

        // Mint and approve tokens
        token.mintToken(user1, 10e18);
        token.mintToken(user2, 10e18);
        token.mintToken(address(tokle), 10e18);

        vm.prank(user1);
        token.approve(address(tokle), 1000e18);

        vm.prank(user2);
        token.approve(address(tokle), 1000e18);

        // Start games
        tokle.startGame(user1);
        tokle.startGame(user2);
    }

    // Test registering a wrong guess
    function testRegisterWrongGuess() public {
        vm.prank(user1);
        bytes32 hashGuess = keccak256(abi.encodePacked("alert"));
        tokle.tryGuess(user1, hashGuess);

        bytes32[] memory guesses = tokle.getGuesses(user1);
        assertEq(guesses.length, 1);
        assertEq(guesses[0], hashGuess);
        assertEq(tokle.getTries(user1), 4);

        // Assert the balance of tokens
        assertEq(token.balanceOf(user1), 9e18);
        assertEq(token.balanceOf(address(tokle)), 11e18);
    }

    // Test winning the game
    function testWinGame() public {
        vm.prank(user1);
        bytes32 hashGuess = keccak256(abi.encodePacked("apple"));
        tokle.tryGuess(user1, hashGuess);

        assertEq(tokle.getTries(user1), 0);
        assertEq(token.balanceOf(user1), 14e18);
    }

    // Test multiple guesses then win
    function testMultipleGuessesThenWin() public {
        vm.startPrank(user1);

        bytes32 hashGuess1 = keccak256(abi.encodePacked("alert"));
        bytes32 hashGuess2 = keccak256(abi.encodePacked("apple"));

        tokle.tryGuess(user1, hashGuess1);
        tokle.tryGuess(user1, hashGuess1);
        vm.stopPrank();

        // Two wrong guesses => tries left = 3
        assertEq(tokle.getTries(user1), 3);

        // User token balance after 2 guesses: 10 - 2 = 8
        assertEq(token.balanceOf(user1), 8e18);

        vm.prank(user1);
        tokle.tryGuess(user1, hashGuess2);

        // Remaining tries = 0
        assertEq(tokle.getTries(user1), 0);

        // Refund = (3 tries left * 1 token) - 1 token of correct try = 2
        // User balance = 8 + 2 = 10
        assertEq(token.balanceOf(user1), 10e18);
    }

    // Test that game cannot accept more guesses after finishing
    function testCannotGuessAfterGameOver() public {
        vm.prank(user1);

        bytes32 hashGuess = keccak256(abi.encodePacked("apple"));
        
        tokle.tryGuess(user1, hashGuess); // win

        vm.prank(user1);
        vm.expectRevert("no tries left");
        tokle.tryGuess(user1, hashGuess);
    }

    // Test losing the game
    function testLoseGame() public {
        vm.startPrank(user1);

        bytes32 hashGuess = keccak256(abi.encodePacked("alert"));

        tokle.tryGuess(user1, hashGuess);
        tokle.tryGuess(user1, hashGuess);
        tokle.tryGuess(user1, hashGuess);
        tokle.tryGuess(user1, hashGuess);
        tokle.tryGuess(user1, hashGuess);
        vm.stopPrank();

        assertEq(tokle.getTries(user1), 0);
        assertEq(token.balanceOf(user1), 5e18);
    }

    // Two players should have independent tries and guesses
    function testMultiplePlayersHaveIndependentTries() public {
        // Player 1 makes one wrong guess
        vm.prank(user1);

        bytes32 hashGuess1 = keccak256(abi.encodePacked("alert"));
        bytes32 hashGuess2 = keccak256(abi.encodePacked("angle"));
        bytes32 hashGuess3 = keccak256(abi.encodePacked("adore"));

        tokle.tryGuess(user1, hashGuess1);

        // Player 2 makes two wrong guesses
        vm.startPrank(user2);
        tokle.tryGuess(user2, hashGuess2);
        tokle.tryGuess(user2, hashGuess3);
        vm.stopPrank();

        // Check independent state
        assertEq(tokle.getTries(user1), 4);
        assertEq(tokle.getTries(user2), 3);

        bytes32[] memory guesses1 = tokle.getGuesses(user1);
        bytes32[] memory guesses2 = tokle.getGuesses(user2);

        assertEq(guesses1.length, 1);
        assertEq(guesses2.length, 2);

        // Verify their guesses differ
        assertEq(guesses1[0], hashGuess1);
        assertEq(guesses2[0], hashGuess2);
        assertEq(guesses2[1], hashGuess3);

        // Token balances reflect correct deductions
        assertEq(token.balanceOf(user1), 9e18); // 1 try spent
        assertEq(token.balanceOf(user2), 8e18); // 2 tries spent
    }
}
