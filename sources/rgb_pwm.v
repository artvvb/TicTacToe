`timescale 1ns / 1ps
module rgb_pwm(
    input clk,
    input rst,
    input [2:0] color,
    output [2:0] RGB
    );
    wire [15:0] C;
    wire pwm;
    counter #(
        .N(16),
        .M(2**16-1)
    ) m0 (
        .clk(clk),
        .rst(rst),
        .E(1'b1),
        .C(C),
        .T()
    );
    assign pwm = C[15];//50%
    assign RGB = {3{pwm}} & color;
endmodule
