`timescale 1ns / 1ps
module vga(
    input clk,
    input rst,
    input [1:0] sprite,
    input [3:0] uaddr,
    input [9:0] gameover,
    output reg HS,
    output reg VS,
    output reg [11:0] vgaRGB,
    output wire [3:0] saddr,
    output wire save
    );
    wire [11:0] color;
    wire [9:0] HC, VC;
    wire [5:0] FC;
    wire [1:0] CC;
    wire CT, HT, VT;
    
    assign save = VT;//used to fix tearing, flag to copy register data into buffer
    
    counter #( 2,   3) cc (clk, rst, 1'b1        , CC, CT);//counter: #(size, max) (clock, reset, enable, count, count at max flag)
    counter #(10, 799) hc (clk, rst, CT          , HC, HT);
    counter #(10, 524) vc (clk, rst, CT & HT     , VC, VT);
    counter #( 6,  50) fc (clk, rst, CT & HT & VT, FC,   );
    
    vga_color_sel m0 (
        .clk(clk),
        .rst(rst),
        .HC(HC),
        .VC(VC),
        .FC(FC),
        .uaddr(uaddr),
        .sprite(sprite),
        .gameover(gameover),
        .vga_color(color),
        .saddr(saddr)
    );
    
    always@(posedge clk) begin
        //if (CT == 1'b0) begin//not required for data validation?
        vgaRGB <= color;
        HS <= (HC <= 96) ? 1'b1 : 1'b0;
        VS <= (VC <=  2) ? 1'b1 : 1'b0;
    end
endmodule
