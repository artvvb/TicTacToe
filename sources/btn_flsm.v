`timescale 1ns / 1ps

// this module handles user input to the Tic-Tac-Toe game
// first converts the button input signals into a useful form
// then uses those inputs to determine how the game is being played

module btn_flsm(
    input clk,
    input rst,
    input btnC, // confirm selection
    input btnR, // move cursor right one cell
    input btnL, // move cursor left one cell
    input btnU, // move cursor up one cell
    input btnD, // move cursor down one cell
    input [1:0] ud,         // "user data", current state of cell at "addr"
    input [9:0] gameover,   // 7:0 shows whether that line is wholly owned by one player (three in a line wins the game), 9 tells whether the game is over, and 8 tells which player has won, if any
    output reg [3:0] addr,  // position of the cursor, highlights this address on screen, and writes to this address when confirm button is pressed
    output reg [1:0] wd,    // code for active player
    output wire wen         // write wd to reg_array[addr]
    );
    wire [4:0] p, db;// center, left, right, up, down
    
    // removes noise from button inputs, to ensure that only a single press is recorded for each actual press of the physical button
    debouncer dbC (clk, rst, btnC, db[0]);//debouncer: (clock, reset, input, output)
    debouncer dbL (clk, rst, btnL, db[1]);
    debouncer dbR (clk, rst, btnR, db[2]);
    debouncer dbU (clk, rst, btnU, db[3]);
    debouncer dbD (clk, rst, btnD, db[4]);
    
    // pulses the output on the rising edge of the input, so that the signal is only high for one clock cycle
    // makes modules using these signals easier to write
    pulser pC (clk, rst, db[0], p[0]);//pulser: (clock, reset, input, output)
    pulser pL (clk, rst, db[1], p[1]);
    pulser pR (clk, rst, db[2], p[2]);
    pulser pU (clk, rst, db[3], p[3]);
    pulser pD (clk, rst, db[4], p[4]);
    
    // the following pieces of code all set the write inputs to the register array,
    //  allowing the player to interact with the Tic-Tac-Toe grid
    
    // write enable for register_array, 
    assign wen = p[0];
    
    // state machine for the cursor X position
    // press btnL, cursor moves left, press btnR, cursor moves right
    // cursor movement wraps around, so that pressing right while at the right edge of the screen will move the cursor to the left edge of the screen
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            addr[1:0] <= 2'b0;
        else if (p[2:1] == 2'b10)//double press will not do anything, this is good
            addr[1:0] <= (addr[1:0] == 2'd2) ? 2'd0 : addr[1:0] + 1'b1;
        else if (p[2:1] == 2'b01)
            addr[1:0] <= (addr[1:0] == 2'd0) ? 2'd2 : addr[1:0] - 1'b1;
        else
            addr[1:0] <= addr[1:0];
    
    // state machine for the cursor Y position, works the same as for X position
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            addr[3:2] <= 2'b0;
        else if (p[4:3] == 2'b10)
            addr[3:2] <= (addr[3:2] == 2'd2) ? 2'd0 : addr[3:2] + 1'b1;
        else if (p[4:3] == 2'b01)
            addr[3:2] <= (addr[3:2] == 2'd0) ? 2'd0 : addr[3:2] - 1'b1;
        else
            addr[3:2] <= addr[3:2];
    
    // state machine to decide which player's turn it is, setting the write data input to the register_array
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            wd <= 2'b01;
        else if (p[0] == 1'b1)
            if (gameover[9])
                wd <= {gameover[8], ~gameover[8]};//loser goes first, need to check if this order is correct, and if this could be covered by 'wd <= ~wd'
            else if (ud == 2'b0)
                wd <= ~wd;
            else
                wd <= wd;
        else
            wd <= wd;
endmodule
