// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

contract DrinkWater {
    uint256 constant public SECONDS_IN_EIGHT_HOURS = 28800;

    address[] public addressesThatHaveDrank;
    mapping(address => bool) public hasAddressDrank;
    mapping(address => uint256) public totalNumAddressDrinks;
    mapping(address => uint256) public lastAddressDrink;

    error CanOnlyDrinkEvery8Hours();
    
    function getAllAddressesThatHaveDrank() public view returns (address[] memory) {
        return addressesThatHaveDrank;
    }

    function getAllAddressesTotalDrinks()
        public
        view
        returns (address[] memory addresses, uint256[] memory totalDrinks)
    {
        address[] memory addressesMemVar = addressesThatHaveDrank;
        uint256[] memory totalDrinksArray = new uint256[](addressesMemVar.length);
        for (uint256 i = 0; i < addressesMemVar.length; i++) {
            totalDrinksArray[i] = totalNumAddressDrinks[addressesMemVar[i]];
        }
        return (addressesMemVar, totalDrinksArray);
    }

    function drinkWater() public {
        if (!hasAddressDrank[msg.sender]) {
            lastAddressDrink[msg.sender] = block.timestamp;
            totalNumAddressDrinks[msg.sender] = 1;
            addressesThatHaveDrank.push(msg.sender);
            hasAddressDrank[msg.sender] = true;
            return;
        }
        
        uint256 lastDrinkOfThisAddress = lastAddressDrink[msg.sender];
        if ((block.timestamp - lastDrinkOfThisAddress) < SECONDS_IN_EIGHT_HOURS) {
            revert CanOnlyDrinkEvery8Hours();
        } else {
            lastAddressDrink[msg.sender] = block.timestamp;
            totalNumAddressDrinks[msg.sender]++;
        }
    }
}
