`timescale 1ns / 1ps

// This module controls the board 14-pin VGA output

module vga(
    input clk,
    input rst,
    input [1:0] sprite,         // which sprite to use, the contents of the cell being looked at by the vga
    input [3:0] uaddr,          // user-address, the position of the "cursor", shown by highlighting the cell in red
    input [9:0] gameover,       // as seen elsewhere, the state of the game, with respect to whether it is over, and if so, how
    output reg HS,              // horizontal sync
    output reg VS,              // vertical sync
    output reg [11:0] vgaRGB,   // twelve bit color output
    output wire [3:0] saddr,    // sprite address, memory address to fetch sprite from
    output wire save            // frame update, save game state to prevent tearing
    );
    wire [11:0] color;
    wire [9:0] HC, VC;  // horizontal pixel count, vertical pixel count
    wire [5:0] FC;      // frame count
    wire [1:0] CC;
    wire CT, HT, VT;
    
    assign save = VT;//used to fix tearing, flag to copy register data into buffer
    
    counter #( 2,   3) cc (clk, rst, 1'b1        , CC, CT);//counter: #(size, max) (clock, reset, enable, count, count at max flag)
    counter #(10, 799) hc (clk, rst, CT          , HC, HT);
    counter #(10, 524) vc (clk, rst, CT & HT     , VC, VT);// 1 frame / 1.68 ms
    counter #( 6,  50) fc (clk, rst, CT & HT & VT, FC,   );
    
    // acquires color from sprite Look-Up-Table combined with cursor position and vga pixel location
    // display an X if P1 controls the cell
    // display an O if P2 controls the cell
    // color everything in the cell that would be black red if cursor is on the cell and game not over
    // color everything in the cell that would be black green if game is over and cell is in the winning line
    vga_color_sel m0 (
        .clk(clk),
        .rst(rst),
        .HC(HC),
        .VC(VC),
        .FC(FC),                // blinks the cursor at 1.19Hz
        .uaddr(uaddr),
        .sprite(sprite),
        .gameover(gameover),
        .vga_color(color),
        .saddr(saddr)
    );
    
    //see VGA specs for 640x480 for description of Horizontal and Vertical Sync pins
    always@(posedge clk) begin
        //if (CT == 1'b0) begin//not required for data validation?
        vgaRGB <= color;
        HS <= (HC <= 96) ? 1'b1 : 1'b0;
        VS <= (VC <=  2) ? 1'b1 : 1'b0;
    end
endmodule
