`timescale 1ns / 1ps
module btn_flsm(
    input clk,
    input rst,
    input btnC,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    input [1:0] ud,
    input [9:0] gameover,
    output reg [3:0] addr,
    output reg [1:0] wd,
    output wire wen
    );
    wire [4:0] p, db;
    
    assign wen = p[0];
    
    debouncer dbC (clk, rst, btnC, db[0]);//debouncer: (clock, reset, input, output)
    debouncer dbL (clk, rst, btnL, db[1]);
    debouncer dbR (clk, rst, btnR, db[2]);
    debouncer dbU (clk, rst, btnU, db[3]);
    debouncer dbD (clk, rst, btnD, db[4]);
    
    pulser pC (clk, rst, db[0], p[0]);//pulser: (clock, reset, input, output)
    pulser pL (clk, rst, db[1], p[1]);
    pulser pR (clk, rst, db[2], p[2]);
    pulser pU (clk, rst, db[3], p[3]);
    pulser pD (clk, rst, db[4], p[4]);
    
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            addr[1:0] <= 2'b0;
        else if (p[2:1] == 2'b10)//double press will not do anything, this is good
            addr[1:0] <= (addr[1:0] == 2'd2) ? 2'd0 : addr[1:0] + 1'b1;
        else if (p[2:1] == 2'b01)
            addr[1:0] <= (addr[1:0] == 2'd0) ? 2'd2 : addr[1:0] - 1'b1;
        else
            addr[1:0] <= addr[1:0];
    
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            addr[3:2] <= 2'b0;
        else if (p[4:3] == 2'b10)
            addr[3:2] <= (addr[3:2] == 2'd2) ? 2'd0 : addr[3:2] + 1'b1;
        else if (p[4:3] == 2'b01)
            addr[3:2] <= (addr[3:2] == 2'd0) ? 2'd0 : addr[3:2] - 1'b1;
        else
            addr[3:2] <= addr[3:2];
    
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            wd <= 2'b01;
        else if (p[0] == 1'b1)
            if (gameover[9])
                wd <= {gameover[8], ~gameover[8]};//loser gos first, need to check if this order is correct, and if this could be covered by 'wd <= ~wd'
            else if (ud == 2'b0)
                wd <= ~wd;
            else
                wd <= wd;
        else
            wd <= wd;
endmodule
