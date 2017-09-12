`timescale 1ns / 1ps

// read only implied block ram, used to store sprites.hex, a processed raw version of an image containing the X and the O.
// I should probably include that image and the C code I used to turn it into the .hex, rather than the .hex

module lut(
    input clk,
    input rst,
    input [AW-1:0] A,
    output reg [DW-1:0] D
    );
    parameter AW=1, DW=1, F="data.hex";
    reg [DW-1:0] mem [2**AW-1:0];   // implied block ram
    initial $readmemh(F, mem);      // load data into memory from file
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            D <= 'b0;
        else
            D <= mem[A]; // data is a buffer register for the contents of the wanted memory address
endmodule
