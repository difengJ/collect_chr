pragma solidity ^0.4.18;

contract collectFuzi{
    uint public types;
    uint public maxperType;
    address owner;
    mapping (address => mapping(uint => uint))  fuZiof;
    mapping (uint => uint) fuZiRemaining;
    
    function collectFuzi(uint _types,uint _maxperType) payable{
        if(_types != 0){types = _types;}
        if(_maxperType != 0){maxperType = _maxperType;}
        for (uint i = 0; i < _types; i++) {
            fuZiRemaining[i] = _maxperType;
        }
    }
    function clickFuzi(uint index) returns(bool){
        require (index <= types);
        require(fuZiRemaining[index] >= 1);
        fuZiRemaining[index] -= 1;
        fuZiof[msg.sender][index] += 1;
        return (true);
    }
    
    function getFuZiof(address _add,uint index) constant returns(uint){
        return(fuZiof[_add][index]);
    }
    
    function getRemaining(uint index) constant returns(uint){
        return fuZiRemaining[index];
    }
    
    function checkRedeem()  returns(uint){
        uint count = 0;
        for (uint i=0;i <= types;i++){
            if(fuZiof[msg.sender][i]>=1){
                count +=1;
            }
        }
        return(count);
    }
    
    function redeem() returns(bool){
        if (checkRedeem()==types){
            msg.sender.transfer(200);
            return (true);
        }
        else{return (false);}
    }
    
}
