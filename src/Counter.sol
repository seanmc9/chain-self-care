// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.13;

contract DrinkWater {
    uint256 constant SECONDS_IN_EIGHT_HOURS = 28800;

    address[] public addressesThatHaveDrank;
    mapping(address => bool) public hasAddressDrank;
    mapping(address => uint256) public totalNumAddressDrinks;
    mapping(address => uint256) public lastAddressDrink;

    error CanOnlyDrinkEvery8Hours();

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
