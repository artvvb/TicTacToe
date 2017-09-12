`timescale 1ns / 1ps

// this module divides the input I by two to the power of the shift input S

module shift_divider(
    input [2**DW-1:0] I,
    input [DW-1:0] S,
    output [2**DW-1:0] Q, // quotient
    output [2**DW-1:0] R  // remainder
    );
    parameter DW=4; // divisor/data width
    assign Q = (I >> S);                   // I / 2^S
    assign R = ~( {2**DW{1'b1}} << S) & I; // I % 2^S
    // the formula for R is a little wonky to read
    // in short, it masks all but the bottom S bits of I
    // this: ~( {2**DW{1'b1}} << S) creates a field two to the power of the data width wide, full of ones, 
    //  and shifts it left by S, placing that many zeroes at the bottom of the field. 
    //  it then inverts the field, so that you have ones in the bottom S bits, and zeroes above that.
    //  by and-ing something like 00000011 with I, you get only the bottom 2 bits of I
    
    // While outright implied division works (Q / S), I trust this module to always implement the same thing, which is significantly faster and/or smaller than the worst case scenarios of implied division
endmodule
