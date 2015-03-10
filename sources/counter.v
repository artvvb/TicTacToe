`timescale 1ns / 1ps
module counter(
    input clk,
    input rst,
    input E,
    output reg [N-1:0] C,
    output T
    );
    parameter N=1, M=1;
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            C <= 'b0;
        else if (E == 1'b1)
            if (T == 1'b1)
                C <= 'b0;
            else
                C <= C + 1'b1;
        else
            C <= C;
    assign T = (C == M) ? 1'b1 : 1'b0;
endmodule
