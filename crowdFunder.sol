pragma solidity ^0.4.0;

contract CrowdFunder {

    address public creator;
    address public fundRecipient; // creator may be different than recipient
    
    uint public minimumToRaise; // required to tip, else everyone gets refund
    uint public goal;
    string campaignUrl;
    byte constant version = 1;
    
     // Data structures
    enum State {
        Fundraising,
        ExpiredRefund,
        Successful
    }
    
    struct Contribution {
        uint amount;
        address contributor;
    }
    
    // State variables
    State public state = State.Fundraising; // initialize on create
    uint public  totalRaised;
    uint public raiseBy;
    uint public completeAt;
    Contribution[]  contributions;
    
    event LogFundingReceived(address addr, uint amount, uint currentTotal);
    event LogWinnerPaid(address winnerAddress);
    
    modifier inState(State _state) {if (state != _state) throw;_;}

    modifier isCreator() { if (msg.sender != creator) throw; _;}
    
     // Wait 6 months after final contract state before allowing contract destruction
   
    function  CrowdFunder  (
        uint timeInHoursForFundraising,
        string _campaignUrl,
        address _fundRecipient,
        uint _minimumToRaise, 
        uint _goal)
    {
        creator = msg.sender;
        fundRecipient = _fundRecipient;
        campaignUrl = _campaignUrl;
        minimumToRaise = _minimumToRaise;
        goal = _goal;
        raiseBy = now + (timeInHoursForFundraising * 1 hours);
    }
  
  
    function setMinimumToRaise() public payable returns (uint m) {
        if(msg.sender==CrowdFunder.creator){
            CrowdFunder.minimumToRaise=msg.value;
            return msg.value;
        }  
            return 0;
    }
    
   
     function setGoal() public payable returns (uint m) {
        if(msg.sender==CrowdFunder.creator){
            CrowdFunder.goal=msg.value;
            return msg.value;
        }  
            return 0;
    }
    
    function payOut() public payable inState(State.Successful){
        if(!fundRecipient.send(this.balance)) {
            throw;
        }
        LogWinnerPaid(fundRecipient);
    }
    
    /*
    else if ( now > raiseBy )  {
            state = State.ExpiredRefund;
            // backers can now collect refunds by calling getRefund(id)
        }
        completeAt = now;
    */
    
    function checkIfFundingCompleteOrExpired() {
        if (totalRaised > CrowdFunder.goal) {
            state = State.Successful;
            payOut();
        } 
    }

    
    function contribute() public payable inState(State.Fundraising) {
        if(msg.value>=CrowdFunder.minimumToRaise){
            contributions.push(
            Contribution({
                amount: msg.value,
                contributor: msg.sender
            })
        );
        totalRaised += msg.value;

        LogFundingReceived(msg.sender, msg.value, totalRaised);

        checkIfFundingCompleteOrExpired();
        }
        
    }
    
  
     function removeContract() public isCreator()
     {
        selfdestruct(msg.sender);
        // creator gets all money that hasn't be claimed
        }
   
    
}
