`timescale 1ns / 1ps

// This module removes noise from an external input signal
// uses a state machine to ensure that the output only follows the input if the input has changed "for sure"
// whenever a button is pressed, before it's associated pin goes fully high,there is usually a short period where it bounces high and low

// turn on output if input goes high, then doesn't go low again for the next N clock cycles

// N should be selected to be longer than the expected period of noise on an external pin

// removing this module from the project could lead to "double presses" where when pressing for instance a directional button, 
//  the "cursor" moves by two spaces instead of one, due to the generation of multiple rising edges (see the pulser module for more detail on that)

//see en.wikipedia.org/wiki/Switch#Contact_bounce for more information

module debouncer(
    input clk,
    input rst,
    input I,
    output Y
    );
    parameter N=16'hffff;   // as clock input is undivided from the 100MHz base, N=2^16-1 -> maximum noise period = 655us or 0.6ms
    reg [15:0] C;           // "time" since last input flip
    reg [1:0] ps;           // state machine's present state, 
    // 00 is low, no recent input flip, 01 
    
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            C <= 'b0;
        else if (ps == 2'b01 || ps == 2'b10)
            C <= C + 1'b1; // count only while in a transition state
        else
            C <= 'b0; // reset counter while in stable state, to prepare for transition
    
    always@(posedge clk, posedge rst) // set state machine registers, depending on current state, input, count, and max count
        if (rst == 1'b1)
            ps <= 'b0;
        else case (ps)
            2'b00: ps <= (I) ? 2'b01 : 2'b00;                       // OFF - no recent input flip
            2'b01: ps <= (I) ? (C == N) ? 2'b11 : 2'b01 : 2'b00;    // OFF - counting time, if no second input flip in maximum noise period, transition to ON
            2'b11: ps <= (I) ? 2'b11 : 2'b10;                       // ON - no recent input flip
            2'b10: ps <= (I) ? 2'b11 : (C == N) ? 2'b00 : 2'b10;    // ON - counting time, if no second input flip in maximum noise period, transition to OFF
        endcase
    
    assign Y = ps[1]; // set the output
endmodule
