`timescale 1ns / 1ps
module shift_divider(
    input [2**DW-1:0] I,
    input [DW-1:0] S,
    output [2**DW-1:0] Q,//"quotient"
    output [2**DW-1:0] R//"remainder"
    );
    parameter DW=4;//divisor width
    assign Q = (I >> S);// I / 2^S
    assign R = ~( {2**DW{1'b1}} << S) & I;// I % 2^S
endmodule
