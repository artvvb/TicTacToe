`timescale 1ns / 1ps

// this module stores the current state of the game,
// saves the state of the game for the vga to prevent "tearing",
// and encodes each of these game states to determine whether the game has ended and if so, how
// this is a fairly weird implementation, specifically used so that data in different cells can be read from and written to in the same cycle.
// ideally this module would contain a memory controller and imply a piece of block ram (reg [1:0] mem [15:0])
// the memory controller would have to deal with reads and writes separately, and the save operation would take 16 clock cycles instead of 1
// The tradeoff made apparent here is that this module is fast but not scalable. A RAM controller would be slower (by about 2x) but would be significantly more scalable.
// AFAIK, this works similarly to how the CPU registers in a processor work, rather than how the RAM works.

module reg_array(
    input clk,
    input rst,
    input wen,          // whether I is to be written into the cell at waddr this clock cycle
    input [1:0] I,      // the data to be written in the cell at waddr when wen is high
    input [3:0] waddr,  // the address of the cell to be written into from I when wen is high. also the address of the cell to be read into wY
    input [3:0] raddr,  // the address of the cell to be read into Y (from vga)
    input save,         // whether mem should be written into memO, comes from vga
    output [1:0] Y,     // output data bus sent to vga
    output [1:0] wY,    // output data bus sent to btn_flsm
    output [9:0] gameover,      //gameover state, which way the game was won, whether it has been won, 
    output [9:0] gameover_vga   //gameover state as seen by fpga, processed from memO
    );
    //WARNING: THIS MODULE SHOULD NOT BE USED FOR MEMORY SIZES LARGER THAN 32bit
    reg [31:0] mem, memO;//memO is the buffer for the vga, a copy of mem at the last time that the frame entire screen was updated
    
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            mem <= 'b0;
        else if (wen == 1'b1)
            if (|gameover)
                mem <= 'b0; // reset the board when the game is done
            else
                mem <= (mem & ~(32'd3 << ({1'b0, waddr} << 1))) | ({30'd0, I} << ({1'b0, waddr} << 1));
                //clear memory at waddr (&= 11..110011..11)
                //then set memory at waddr (|= 00..00{I}00..00)
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
    assign wY = mem  >> ({1'b0, waddr} << 1); // set output to the bottom two bits of the register shifted right by address times two (two being the cell width)

    //gets the state of the game, with respect to whether it is over, and if so how it has ended, code could be in this file, but it's pretty large
    go_encode m0 (
        .mem(mem),
        .gameover(gameover)
    );
    go_encode m1 (
        .mem(memO),
        .gameover(gameover_vga)
    );
endmodule
