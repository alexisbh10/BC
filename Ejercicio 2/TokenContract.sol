// SPDX-License-Identifier: Unlicenced
pragma solidity ^0.8.10;
contract TokenContract {
 
    address public owner;
    struct Receivers { 
    string name;
    uint256 tokens;
    }
    mapping(address => Receivers) public users;
    
    modifier onlyOwner(){
    require(msg.sender == owner);
        _;
    }
    
    constructor(){
    owner = msg.sender;
    users[owner].tokens = 100; 
    }
    
    function double(uint _value) public pure returns (uint){
    return _value*2;
    }
    
    function register(string memory _name) public{
    users[msg.sender].name = _name;
    }
    
    function giveToken(address _receiver, uint256 _amount) onlyOwner public{
    require(users[owner].tokens >= _amount);
    users[owner].tokens -= _amount;
    users[_receiver].tokens += _amount;
    }

    function buyToken(address _receiver,uint _amount) public payable {
        uint tokenPrice = 5 ether;
        uint amountToBuy = _amount / tokenPrice;

        require(amountToBuy > 0, "Ether insuficiente.");
        require(users[owner].tokens>=amountToBuy, "El propietario no tiene suficientes tokens para realizar la compra.");

        giveToken(_receiver, _amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance; // Return the balance in wei
    }

    // Function to withdraw Ether from the contract (only owner)
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Fallback function to allow contract to receive Ether
    receive() external payable {}
}