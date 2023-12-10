// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

contract EatFood {
    uint256 constant public SECONDS_IN_FOUR_HOURS = 14400;

    address[] public addressesThatHaveEaten;
    mapping(address => bool) public hasAddressEaten;
    mapping(address => uint256) public totalNumAddressEaten;
    mapping(address => uint256) public lastAddressEaten;

    error CanOnlyEatEvery4Hours();
    
    function getAllAddressesThatHaveEaten() public view returns (address[] memory) {
        return addressesThatHaveEaten;
    }

    function getAllAddressesTotalEaten()
        public
        view
        returns (address[] memory addresses, uint256[] memory totalEats)
    {
        address[] memory addressesMemVar = addressesThatHaveEaten;
        uint256[] memory totalEatenArray = new uint256[](addressesMemVar.length);
        for (uint256 i = 0; i < addressesMemVar.length; i++) {
            totalEatenArray[i] = totalNumAddressEaten[addressesMemVar[i]];
        }
        return (addressesMemVar, totalEatenArray);
    }

    function eatFood() public {
        if (!hasAddressEaten[msg.sender]) {
            lastAddressEaten[msg.sender] = block.timestamp;
            totalNumAddressEaten[msg.sender] = 1;
            addressesThatHaveEaten.push(msg.sender);
            hasAddressEaten[msg.sender] = true;
            return;
        }
        
        uint256 lastEatOfThisAddress = lastAddressEaten[msg.sender];
        if ((block.timestamp - lastEatOfThisAddress) < SECONDS_IN_FOUR_HOURS) {
            revert CanOnlyEatEvery4Hours();
        } else {
            lastAddressEaten[msg.sender] = block.timestamp;
            totalNumAddressEaten[msg.sender]++;
        }
    }
}
