pragma solidity ^0.4.9;

contract TheDivine{

    /* Randomness chain */
    mapping (uint => bytes32) public Immotal;

    /* Address nonce */
    mapping (address => uint) public Nonce;

    /* Total number of randomness in the chain */
    uint public Total;
       
    /**
    * Construct function
    */
    function TheDivine(){
        Immotal[Total++] = sha3(this);
        Immotal[Total++] = sha3(Immotal[0]);
    }
    

    /**
    * Get result from PNG
    */
    function GetPower() public returns(bytes32){
        uint Previous = uint(sha3(Immotal[Total-1]));
        uint PickUp = Previous >> 128 ^ Previous << 128;
        uint ThePast = uint(Immotal[PickUp % Total]);
        uint Shift = PickUp % 256;

        // Swing previous value by shift operator
        Previous = (Previous >> Shift) | (Previous << (256 - Shift));

        // Swing ThePast value by shift operator
        ThePast = (ThePast >> (256 - Shift)) | (ThePast << Shift);
        
        // Append number to the chain
        Immotal[Total++] = sha3(
                                Previous,                   // Previous
                                ThePast,                    // Random pickup value from the chain
                                Previous - ThePast,         // Distance
                                Total,                      // Total number of randomness in the chain
                                Nonce[msg.sender]++         // Sender nonce
                            );

        // Return last number of the chain
        return Immotal[Total-1];
    }

    /**
    * No Ethereum will be trapped
    */
    function (){
        throw;
    }

}