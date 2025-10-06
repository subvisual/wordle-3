// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Tokle {
    address public player;
    IERC20 public token;
    string public targetWord;
    uint8 public triesLeft;
    uint256 public costPerTry;

    string[] public guesses;

    constructor(address _player,address _token, string memory _word, uint256 _costPerTry) {
        player = _player;
        token = IERC20(_token);
        targetWord = _word;
        triesLeft = uint8(5);
        costPerTry = _costPerTry;
    }

    function tryGuess(string calldata _guess) public{
        require(triesLeft > 0, "no tries left");
        require(bytes(_guess).length == 5, "must be 5 letters");

        if (keccak256(bytes(_guess)) == keccak256(bytes(targetWord))){
            endGame();
        }
        else{
            registerGuess(_guess);
        }
    }

    function registerGuess(string calldata _guess) public {
        bool ok = token.transferFrom(player, address(this), costPerTry);
        require(ok, "token transfer failed");

        guesses.push(_guess);
        triesLeft--;
    }

    function endGame() public {
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
