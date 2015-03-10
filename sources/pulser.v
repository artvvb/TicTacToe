`timescale 1ns / 1ps
module pulser(
    input clk,
    input rst,
    input I,
    output Y
    );
    reg [1:0] ps;
    always@(negedge clk, posedge rst)
        if (rst == 1'b1)
            ps <= 2'b0;
        else case (ps)
            2'b00: ps <= (I) ? 2'b01 : 2'b00;
            2'b01: ps <= (I) ? 2'b11 : 2'b00;
            2'b10: ps <= (I) ? 2'b11 : 2'b00;
            2'b11: ps <= (I) ? 2'b11 : 2'b10;
        endcase
    
    assign Y = ~ps[1] & ps[0];
endmodule
