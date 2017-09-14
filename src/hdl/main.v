`timescale 1ns / 1ps
module main(
    //EXTERNAL EVENT TRIGGERS FOR FPGA REGISTERS
    input clk,
    input btnCpuReset,
    //USER INPUT
    input btnC,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    //USER OUTPUT
    //  VGA PINS
    output HS,
    output VS,
    output [3:0] vgaR,
    output [3:0] vgaG,
    output [3:0] vgaB,
    //  RGB LED PINS
    output RGB1_Red,
    output RGB1_Green,
    output RGB1_Blue,
    //  Pmod ports for debugging
    output [7:0] JA,
    output [7:0] JB
    );
    //internal buses
    wire [9:0] gameover, gameover_vga;
    wire [3:0] uaddr, vgaaddr;
    wire [1:0] wd, rd, ud;
    wire wen, rst, save;
    
    assign rst = ~btnCpuReset; // Nexys4 cpu reset button is ACTIVE LOW, meaning when the button is held down, the signal goes low. I prefer posedge rst for coding style, so inverted the signal
    
    assign JA[7:4] = vgaR;
    assign JA[3:0] = vgaG;
    assign JB[7:4] = vgaB;
    assign JB[3] = HS;
    assign JB[2] = VS;
    assign JB[1:0] = gameover[1:0];
    
    //handles user inputs, edit if needed
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
    
    // stores game state, do not remove
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
    
    // controls the vga output of the board (main way of viewing game state, remove only with extreme caution)
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
    
    // remove this module to port to a board without RGB leds
    // color the RGB led red if P2 has won, blue if P1 has won
    // Pulse width modulation (PWM) is used to reduce the brightness of the led
    rgb_pwm m3 (
        clk,
        rst,
        {gameover[1], 1'b0, gameover[0]},
        {RGB1_Red, RGB1_Green, RGB1_Blue}
    );
    
endmodule
