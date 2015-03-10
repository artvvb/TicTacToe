`timescale 1ns / 1ps
module main(
    input clk,
    input btnCpuReset,
    input btnC,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    output HS,
    output VS,
    output [3:0] vgaR,
    output [3:0] vgaG,
    output [3:0] vgaB,
    output RGB1_Red,
    output RGB1_Green,
    output RGB1_Blue
    );
    wire [9:0] gameover, gameover_vga;
    wire [3:0] uaddr, vgaaddr;
    wire [1:0] wd, rd, ud;
    wire wen, rst, save;
    
    assign rst = ~btnCpuReset;
    
    btn_flsm m0 (
        clk,
        rst,
        btnC,
        btnR,
        btnL,
        btnU,
        btnD,
        ud,
        gameover,
        uaddr,
        wd,
        wen
    );
    
    reg_array m1 (
        clk,
        rst,
        wen,
        wd,
        uaddr,
        vgaaddr,
        save,
        rd,
        ud,
        gameover,
        gameover_vga
    );
    
    vga m2 (
        clk,
        rst,
        rd,
        uaddr,
        gameover_vga,
        HS,
        VS,
        {vgaR, vgaG, vgaB},
        vgaaddr,
        save
    );
    
    rgb_pwm m3 (
        clk,
        rst,
        {gameover[1], 1'b0, gameover[0]},
        {RGB1_Red, RGB1_Green, RGB1_Blue}
    );
    
endmodule
