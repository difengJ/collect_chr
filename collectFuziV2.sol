pragma solidity ^0.4.18;

contract collectFuzi{
    
    /*
     * The start and end dates respectively convert to the following
     * timestamps:
     *  START_DATE  => 03/01/2018 @ 12:00am (UTC)
     *  END_DATE    => 03/15/2018 @ 12:00am (UTC)
     */
    uint256 constant START_DATE = 1519862400;
    uint256 constant END_DATE = 1522454400;
    /*
     * The amount of seconds within a single game.
     *
     * hours per game:
     *        60 x 60 = 3600
     */
    uint16 constant GAME_DURATION_IN_SECONDS = 43200;
    uint8 timeSlotCount = uint8((END_DATE - START_DATE) / GAME_DURATION_IN_SECONDS);
    uint public types;
    uint public maxperType;
    address public owner;
    struct epoch_data {
        mapping (address => mapping(uint => uint))  fuZiof;
        mapping (uint => uint) fuZiRemaining;
    }
    
    epoch_data [720] epoch_data_all;
    
    event recieveFuZi(uint);
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    function collectFuzi(uint _types,uint _maxperType) payable{
        owner = msg.sender;
        if(_types != 0){types = _types;}
        if(_maxperType != 0){maxperType = _maxperType;}
        for (uint j = 0; j < timeSlotCount; j++){
            for (uint i = 0; i < _types; i++) {
                    epoch_data_all[j].fuZiRemaining[i] = _maxperType;
                }
            }
        }
    
    function getTimeGame(uint256 _timestamp) private pure returns (uint8) {
        uint256 secondsSinceGiveawayStart = _timestamp - START_DATE;
        return uint8(secondsSinceGiveawayStart / GAME_DURATION_IN_SECONDS);
    }
    
    function() payable {
        
    }
    
    function clickFuzi(uint index) returns(bool){
        uint8 currentTimeSlot = getTimeGame(now);
        require (index <= types);
        require(epoch_data_all[currentTimeSlot].fuZiRemaining[index] >= 1);
        epoch_data_all[currentTimeSlot].fuZiRemaining[index] -= 1;
        epoch_data_all[currentTimeSlot].fuZiof[msg.sender][index] += 1;
        recieveFuZi(index);
        return (true);
    }
    
    function getFuZiof(uint index) constant returns(uint){
        uint8 currentTimeSlot = getTimeGame(now);
        return(epoch_data_all[currentTimeSlot].fuZiof[msg.sender][index]);
    }
    
    function getRemaining(uint index) constant returns(uint){
        uint8 currentTimeSlot = getTimeGame(now);
        return epoch_data_all[currentTimeSlot].fuZiRemaining[index];
    }
    
    function checkRedeem() private returns(uint){
        uint count = 0;
        uint8 currentTimeSlot = getTimeGame(now);
        for (uint i=0;i <= types;i++){
            if(epoch_data_all[currentTimeSlot].fuZiof[msg.sender][i]>=1){
                count +=1;
            }
        }
        return(count);
    }
    
    function getBalance() constant public returns(uint){
        return this.balance;
    }
    
    function afterRedeem() private{
        uint8 currentTimeSlot = getTimeGame(now);
        for(uint i =0;i<types;i++){
            epoch_data_all[currentTimeSlot].fuZiof[msg.sender][i] -= 1;
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
