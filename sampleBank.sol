// First, a simple Bank contract
// Allows deposits, withdrawals, and balance checks

pragma solidity ^0.4.11;


/// @title SimpleBank

/*
// NATSPEC COMMENTS
// used for documentation, commenting, and external UIs

// Contract natspec - always above contract definition
/// @title Contract title
/// @author Author name

// Function natspec
/// @notice information about what function does; shown when function to execute
/// @dev Function documentation for developer

// Function parameter/return value natspec
/// @param someParam Some description of what the param does
/// @return Description of the return value
*/


/* 'contract' has similarities to 'class' in other languages (class variables,
inheritance, etc.) */

contract SimpleBank {
    // Declare state variables outside function, persist through life of contract
    // dictionary that maps addresses to balances
    // "private" means that other contracts can't directly query balances
    // but data is still viewable to other parties on blockchain
    mapping (address => uint) private balances;
    
    // 'public' makes externally readable (not writeable) by users or contracts
    address public owner;
    
    // Events - publicize actions to external listeners
    event LogDepositMade(address accountAddress, uint amount);

    // Constructor, can receive one or many variables here;
    // only one allowed
    function SimpleBank() public  {
        // msg provides details about the message that's sent to the contract
        // msg.sender is contract caller (address of contract creator)
        owner = msg.sender;
    }
    
    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        // no "this." or "self." required with state variable
        // all values set to data type's initial value by default

        LogDepositMade(msg.sender, msg.value); // fire event

        return balances[msg.sender];
    }
    
     /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public payable returns (uint remainingBal) {
        if(balances[msg.sender] >= withdrawAmount) {
            // Note the way we deduct the balance right away, before sending - due to
            // the risk of a recursive call that allows the caller to request an amount greater
            // than their balance
            balances[msg.sender] -= withdrawAmount;
            
            if (!msg.sender.send(withdrawAmount)) {
                // increment back only on fail, as may be sending to contract that
                // has overridden 'send' on the receipt end
                balances[msg.sender] += withdrawAmount;
            }
            
        }
        
        return balances[msg.sender];
    }
    
    /// @notice Get balance
    /// @return The balance of the user
    // 'constant' prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function balance() public constant returns (uint) {
        return balances[msg.sender];
    }
    
    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    

    
}


