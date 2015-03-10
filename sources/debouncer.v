`timescale 1ns / 1ps
module debouncer(
    input clk,
    input rst,
    input I,
    output Y
    );
    parameter N=16'hffff;
    reg [15:0] C;
    reg [1:0] ps;
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            C <= 'b0;
        else if (^ps)
            C <= C + 1'b1;
        else
            C <= 'b0;
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            ps <= 'b0;
        else case (ps)
            2'b00: ps <= (I) ? 2'b01 : 2'b00;
            2'b01: ps <= (I) ? (C == N) ? 2'b11 : 2'b01 : 2'b00;
            2'b11: ps <= (I) ? 2'b11 : 2'b10;
            2'b10: ps <= (I) ? 2'b11 : (C == N) ? 2'b00 : 2'b10;
        endcase
    assign Y = ps[1];
endmodule
