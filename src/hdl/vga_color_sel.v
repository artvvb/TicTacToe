`timescale 1ns / 1ps
module vga_color_sel(
    input clk,
    input rst,
    input [9:0] HC,
    input [9:0] VC,
    input [5:0] FC,
    input [3:0] uaddr,
    input [1:0] sprite,
    input [9:0] gameover,
    output [11:0] vga_color,
    output [3:0] saddr
    );
    parameter LEdge = 10'd144, REdge = 10'd784, UEdge = 10'd35, DEdge = 10'd515, ImgSize=10'd128;
    parameter HMin = LEdge + 10'd127, HMax = HMin + 3*ImgSize - 10'd1, VMin = UEdge + 10'd47, VMax = VMin + 3*ImgSize - 10'd1;
    wire [11:0] color, go_color;
    wire [1:0] u, d;
    wire [9:0] uoffset, doffset;
    wire in_range, on_screen, grid;
    
    go_decode m1 (
        .gameover(gameover),
        .addr(saddr),
        .color(go_color)
    );
    
    assign on_screen = (HC > LEdge && HC <= REdge && VC > UEdge && VC <= DEdge) ? 1'b1 : 1'b0;
    assign in_range =  (HC >= HMin  && HC <= HMax  && VC >= VMin  && VC <= VMax ) ? 1'b1 : 1'b0;
    assign grid = (HC == HMin || doffset == 10'd127 || VC == VMin || uoffset == 10'd127) ? 1'b1 : 1'b0;
    assign vga_color = (on_screen) ? (in_range) ? (grid) ? 12'h000 : (uaddr == saddr && FC < 6'd25 && ~gameover[9]) ? 12'hfff : (color == 12'h000) ? go_color : color : 12'hfff : 12'h000;
    assign saddr = {u, d};
    
    lut #(
        .AW(16), // address width
        .DW(12), // data width
        .F("sprites.hex") // this file needs to be included in the project, using vivado, I added it as source, then changed the file type to a "Memory Initialization File"
    ) m0 (
        .clk(clk),
        .rst(rst),
        .A({sprite, uoffset[6:0], doffset[6:0]}),//I am using 128x128 sized sprites, 2**7 = 128
        .D(color)
    );
    
    // determines which row of cells the vga is looking at, and where in that row the pixel is located
    shift_divider #(
        .DW(4)
    ) sdV (
        .I(VC - VMin),
        .S(4'd7),
        .Q(u),
        .R(uoffset)
    );
    
    // determines which column of cells the vga is looking at, and where in that column the pixel is located
    shift_divider #(
        .DW(4)
    ) sdH (
        .I(HC - HMin),
        .S(4'd7),//image sizes are 128*128, thus, 2**7
        .Q(d),
        .R(doffset)
    );
endmodule
