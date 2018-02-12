pragma solidity ^0.4.18;

contract collectFuzi{
    uint public types;
    uint public maxperType;
    address public owner;
    mapping (address => mapping(uint => uint))  fuZiof;
    mapping (uint => uint) fuZiRemaining;
    event recieveFuZi(uint);
    
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    function collectFuzi(uint _types,uint _maxperType) payable{
        owner = msg.sender;
        if(_types != 0){types = _types;}
        if(_maxperType != 0){maxperType = _maxperType;}
        for (uint i = 0; i < _types; i++) {
            fuZiRemaining[i] = _maxperType;
        }
    }
    
    function() payable {
        
    }
    
    function clickFuzi(uint index) returns(bool){
        require (index <= types);
        require(fuZiRemaining[index] >= 1);
        fuZiRemaining[index] -= 1;
        fuZiof[msg.sender][index] += 1;
        recieveFuZi(index);
        return (true);
    }
    
    function getFuZiof(uint index) constant returns(uint){
        return(fuZiof[msg.sender][index]);
    }
    
    function getRemaining(uint index) constant returns(uint){
        return fuZiRemaining[index];
    }
    
    function checkRedeem() private returns(uint){
        uint count = 0;
        for (uint i=0;i <= types;i++){
            if(fuZiof[msg.sender][i]>=1){
                count +=1;
            }
        }
        return(count);
    }
    
    function getBalance() constant public returns(uint){
        return this.balance;
    }
    
    function afterRedeem() private{
        for(uint i =0;i<types;i++){
            fuZiof[msg.sender][i] -= 1;
        }
    }
    
    function redeem() returns(bool){
        if (checkRedeem()==types){
            msg.sender.transfer(0.5 ether);
            afterRedeem();
            return (true);
        }
        else{return (false);}
    }
    
    function withdraw() onlyOwner {
        owner.transfer(this.balance);
    }
    
    
}
