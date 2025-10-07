// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library Utility {
    //convert string to lowercase
    function toLowerCase(string memory _str) public pure returns (string memory) {
        bytes memory bString = bytes(_str);
        bytes memory bLowerCase = new bytes(bString.length);
        for (uint j = 0; j < bString.length; j++) {
            // Uppercase character...
            if ((uint8(bString[j]) >= 65) && (uint8(bString[j]) <= 90)) {
                // So we add 32 to make it lowercase
                bLowerCase[j] = bytes1(uint8(bString[j]) + 32);
            } else {
                bLowerCase[j] = bString[j];
            }
        }
        return string(bLowerCase);
    }
}