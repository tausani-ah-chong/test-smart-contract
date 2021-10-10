// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Lottery{
    
    address payable[] public players;
    address payable public admin;
    
    constructor(){
        admin = payable(msg.sender);
    }
    
    receive() external payable{
        require(msg.sender != admin, "Admin can't participate!" );
        
        players.push(payable(msg.sender));
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function currentPlayers() public view returns(uint){
        return players.length;
    }
    
    function pickWinner() public {
        require( admin == msg.sender, "Only admin can pick a winner" );
        require( players.length >= 3, "Must have at least 3 players" );
        
        address payable winner;
        
        winner = players[random() % players.length];
        
        winner.transfer(getBalance());
        
        players = new address payable[](0);
    }
    
} 