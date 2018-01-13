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

contract SolidityBasics {
    uint x;
    uint y;
    /// non pue essere cambiata 
    int constant a = 8;
    int256 constant b = 8;
    bool bo = true;
    string s = "hello";
    //tuple
    
    // Arrays
    bytes32[5] nicknames; // array statico
    bytes32[] names; // array dinamico
    
    
    //dichiarazione di un evento
    event LogFunc(uint amount);


    function SolidityBasics() public  {
        //copa di una funzione in una variabile
        var vf = f;
        //avvia la funzione con argomento 22
        vf(22);
        //assegnamento multiplo
        (x, y) = (6, 7);
        
        uint newLength = names.push("John");
    }
    ///@notice restituisce il valore di x
    ///@dev 
    //@return output del valore
    function getX() public returns (uint)  {
        return x;
    }
    ///@notice funzione per leggere il valore della variabile constant
    ///@dev questo tipo di variabile non puo essere odificato dopo l init
    ///@return valore della variabile 
    function getConstantA() public returns (int)  {
        return a;
    }
    ///@notice funzione per leggere il valore della variabile constant 256
    ///@dev questo tipo di variabile non puo essere odificato dopo l init
    ///@return valore della variabile a 256
    function getConstantB256() public returns (int)  {
        return b;
    }
    
    ///@notice funzione per leggere il valore booleano
    function getBoo() public returns (bool)  {
        return bo;
    }
    
    function getString() public returns (string)  {
        return s;
    }
    
    function setX(uint value) public  {
        x=value;
    }
    ///@notice dato una variabie in input effettua la moltiplicazione per 2
    ///@dev privata quindi non richimabile dall esterno, avvia l evento
    ///@return valore moltiplicato per 2
    function f(uint x) private returns (uint) {
        ///avvio dell evento che scrive nel log
        LogFunc( x*2 );
        return x * 2;
    }
     ///@notice lettura dell array dinamico
    ///@return array dinamico 
    function getArray() public returns (bytes32[])  {
        return names;
    }
    
    
}


