// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library Utility {
    // Convert string to lowercase
    // If a character is Uppercase we add 32 to reach it's lowercase version (ASCII)
    function toLowerCase(string memory _str) public pure returns (string memory) {
        bytes memory bString = bytes(_str);
        bytes memory bLowerCase = new bytes(bString.length);
        for (uint j = 0; j < bString.length; j++) {
            if ((bString[j] >= "A") && (bString[j] <= "Z")) {
                bLowerCase[j] = bytes1(uint8(bString[j]) + 32);
            } else {
                bLowerCase[j] = bString[j];
            }
        }
        return string(bLowerCase);
    }
}