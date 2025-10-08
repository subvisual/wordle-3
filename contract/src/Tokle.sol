// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

import {Utility} from "../src/Utility.sol";

contract Tokle {
    IERC20 public token;        // ERC20 token used to play
    bytes32 public targetWord;  // Hashed target word that players are trying to guess
    uint256 public costPerTry;  // Cost (in tokens) per guess attempt

    // Each player has their own remaining tries and list of guesses
    mapping(address => uint8) public triesLeft;
    mapping(address => string[]) private playerGuesses;

    
     // Constructor sets up the token and cost per try.
     // _token Address of the ERC20 token used for payments.
     // _costPerTry Token amount charged per guess attempt.
    constructor(address _token, uint256 _costPerTry) {
        token = IERC20(_token);
        costPerTry = _costPerTry;
    }

    
    // Set the target word for the game.
    // The word is hashed (after being converted to lowercase) to hide the answer on-chain.
    // _word The correct word players must guess.
    function setTargetWord(string calldata _word) public {
        targetWord = keccak256(abi.encode(Utility.toLowerCase(_word)));
    }

    
    // Start a new game for a player.
    // Resets their tries and clears their previous guesses.
    // player Address of the player starting a new game.
    function startGame(address player) public {
        triesLeft[player] = 5; // Give the player 5 tries
        delete playerGuesses[player]; // Clear old guesses
    }

    
    // Player makes a guess attempt.
    // Charges the player one token per try and compares their guess hash to the target.
    // player The address of the player making the guess.
    // _guess The 5-letter word the player is guessing.
    function tryGuess(address player, string calldata _guess) public {
        require(triesLeft[player] > 0, "no tries left");
        require(bytes(_guess).length == 5, "must be 5 letters");

        // Charge the player for one try
        bool ok = token.transferFrom(player, address(this), costPerTry);
        require(ok, "token transfer failed");

        // Compare guess (in lowercase) to the target word
        bytes32 guessHash = keccak256(abi.encode(Utility.toLowerCase(_guess)));

        if (guessHash == targetWord) {
            // If the player guessed correctly, end the game and refund remaining tries
            endGame(player);
        } else {
            // Otherwise, register their guess and reduce tries
            registerGuess(player, _guess);
        }
    }

    
    // Record the player's guess and decrease their remaining tries.
    // If tries reach zero, automatically ends the game.
    // player The address of the player.
    // _guess The guessed word to record.
    function registerGuess(address player, string calldata _guess) internal {
        playerGuesses[player].push(_guess);
        triesLeft[player]--;

        // If player runs out of tries, end the game
        if (triesLeft[player] == 0) {
            endGame(player);
        }
    }

    
    // Ends a player’s game and refunds remaining tries.
    // Refund = (tries left)  cost per try.
    // player The address of the player whose game ends.
    function endGame(address player) internal {
        uint256 refund = uint256(triesLeft[player]) * costPerTry;

        if (refund > 0) {
            bool ok = token.transfer(player, refund);
            require(ok, "token refund failed");
        }

        // Set tries to zero — game is over
        triesLeft[player] = 0;
    }

    
    // Returns all guesses made by a player.
    // player The address of the player to query.
    // An array of the player's guessed words.
    function getGuesses(address player) external view returns (string[] memory) {
        return playerGuesses[player];
    }

    
    // Returns the number of tries remaining for a player.
    // player The address of the player to query.
    // The number of remaining tries.
    function getTries(address player) external view returns (uint8) {
        return triesLeft[player];
    }
}