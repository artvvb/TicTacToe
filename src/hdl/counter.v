`timescale 1ns / 1ps
module counter(
    input clk,
    input rst,
    input E,                // enable
    output reg [N-1:0] C,   // count
    output T                // count at terminal count, next increment will roll the counter over
);
    parameter   N=1,        // count width
                M=2**N-1;   // count maximum, normally allow every possible combination of bits
    always@(posedge clk, posedge rst)
        if (rst == 1'b1) // asynchronous reset
            C <= 'b0;
        else if (E == 1'b1)
            if (T == 1'b1)
                C <= 'b0; // count at terminal value, roll over
            else
                C <= C + 1'b1; // count not at terminal value, increment by one
        else
            C <= C; // not enabled, hold value
    assign T = (C == M) ? 1'b1 : 1'b0; // count at terminal value?
endmodule
