pragma solidity ^0.4.19;

contract CoffeeContract{

    address public owner = msg.sender;
    uint deposit = 0;
    uint public price;
    address lastCustomer;
    address pendingAmount;
    mapping (address => uint) statsCustomer;
    mapping (address => uint) statsCoffee;
    mapping (address => uint) pendingWithdrawals;

    function CoffeeContract(uint _price) onlyOwner{
        require(msg.sender == owner);
        price = _price;
    }

    function orderCoffee(uint product) payable{
        require(msg.value >= price);
        stats[msg.sender] += msg.value;
        statsCoffee[product] += 1;
        deposit += msg.value;
        pendingAmount = msg.value;
        lastCustomer = msg.sender;
    }

    function refund() onlyOwner{
        require(msg.sender == owner);
        pendingWithdrawals[lastCustomer] = pendingAmount;
        deposit -= pendingAmount;
    }

    function withdraw(){
        require(deposit > 0);
        uint amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        pendingAmount = 0;
        lastCustomer = address(0);
        msg.sender.transfer(amount);
    }

    function close() onlyOwner{
        require(msg.sender == owner);
        owner.send(deposit);
        deposit = 0;
    }
}
