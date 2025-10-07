// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Tokle {
    IERC20 public token;
    bytes32 public targetWord;
    uint8 public triesLeft;
    uint256 public costPerTry;

    string[] public guesses;

    constructor(address _token, uint256 _costPerTry) {
        token = IERC20(_token);
        triesLeft = uint8(5);
        costPerTry = _costPerTry;
    }

    function setTargetWord(string calldata _word) public{
        targetWord = keccak256(abi.encode(_word));
    }

    function tryGuess(address player, string calldata _guess) public{
        require(triesLeft > 0, "no tries left");
        require(bytes(_guess).length == 5, "must be 5 letters");

        bool ok = token.transferFrom(player, address(this), costPerTry);
        require(ok, "token transfer failed");

        bytes32 guessHash = keccak256(abi.encode(_guess));

        if ( guessHash == targetWord){
            endGame(player);
        }
        else{
            registerGuess(player, _guess);
        }
    }

    function registerGuess(address player, string calldata _guess) public {
        guesses.push(_guess);
        triesLeft--;
        if (triesLeft == 0) endGame(player);
    }

    function endGame(address player) public {
        uint256 refund = uint256(triesLeft) * costPerTry;
        bool ok = token.transfer(player, refund);
        require(ok, "token transfer failed");
        triesLeft = 0;
    }

    function getGuesses() external view returns (string[] memory) {
        return guesses;
    }

    function getTries() external view returns (uint8) {
        return triesLeft;
    }
}
