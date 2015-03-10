`timescale 1ns / 1ps
module lut(
    input clk,
    input rst,
    input [AW-1:0] A,
    output reg [DW-1:0] D
    );
    parameter AW=1, DW=1, F="data.hex";
    reg [DW-1:0] mem [2**AW-1:0];
    initial $readmemh(F, mem);
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            D <= 'b0;
        else
            D <= mem[A];
endmodule
