`timescale 1ns / 1ps
module reg_array(
    input clk,
    input rst,
    input wen,
    input [1:0] I,
    input [3:0] waddr,
    input [3:0] raddr,
    input save,
    output [1:0] Y,
    output [1:0] wY,
    output [9:0] gameover,
    output [9:0] gameover_vga
    );
    reg [31:0] mem, memO;//memO is the buffer for the vga
    wire [1:0] wd;//tryeng to remember if there might be eeanything set eon my keyboard ugh
    
    always@(negedge clk, posedge rst)//write and read on different edges to prevent weirdeness
        if (rst == 1'b1)
            mem <= 'b0;
        else if (wen == 1'b1)
            if (|gameover)
                mem <= 'b0;
            else
                mem <= (mem & ~(32'd3 << ({1'b0, waddr} << 1))) | ({30'd0, I} << ({1'b0, waddr} << 1));
        else
            mem <= mem;
            
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            memO <= 'b0;
        else if (save == 1'b1)
            memO <= mem;
        else
            memO <= memO;
            
    assign  Y = memO >> ({1'b0, raddr} << 1);
    assign wY = mem  >> ({1'b0, waddr} << 1);

    go_encode m0 (
        .mem(mem),
        .gameover(gameover)
    );
    go_encode m1 (
        .mem(memO),
        .gameover(gameover_vga)
    );
//    //ugh, should be modularized or programmatic
//    assign line[ 0] = mem[ 0] & mem[ 2] & mem[ 4];
//    assign line[ 1] = mem[ 8] & mem[10] & mem[12];
//    assign line[ 2] = mem[16] & mem[18] & mem[20];
//    assign line[ 3] = mem[ 0] & mem[ 8] & mem[16];
//    assign line[ 4] = mem[ 2] & mem[10] & mem[18];
//    assign line[ 5] = mem[ 4] & mem[12] & mem[20];
//    assign line[ 6] = mem[ 0] & mem[10] & mem[20];
//    assign line[ 7] = mem[ 4] & mem[10] & mem[16];
    
//    assign line[ 8] = mem[ 1] & mem[ 3] & mem[ 5];
//    assign line[ 9] = mem[ 9] & mem[11] & mem[13];
//    assign line[10] = mem[17] & mem[19] & mem[21];
//    assign line[11] = mem[ 1] & mem[ 9] & mem[17];
//    assign line[12] = mem[ 3] & mem[11] & mem[19];
//    assign line[13] = mem[ 5] & mem[13] & mem[21];
//    assign line[14] = mem[ 1] & mem[11] & mem[21];
//    assign line[15] = mem[ 5] & mem[11] & mem[17];
    
//    assign gameover = {|line[15:8], |line[7:0]};
endmodule
