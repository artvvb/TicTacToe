`timescale 1ns / 1ps
module pulser(
    input       clk,
    input       rst,
    input       I,
    output wire Y
    );
    parameter PE=1;
    reg [1:0] ps; // state machine present state register
    always@(posedge clk, posedge rst)
        if (rst == 1'b1)
            ps <= 2'b0;
        else case (ps) // no explicit next state register, implied here
            2'b00: ps <= (I) ? 2'b01 : 2'b00;   // wait until input is high, do nothing
            2'b01: ps <= 2'b11;                 // go to wait high state, output POSEDGE pulse
            2'b10: ps <= 2'b00;                 // go to wait low state, output NEGEDGE pulse
            2'b11: ps <= (I) ? 2'b11 : 2'b10;   // wait until input is low, do nothing
        endcase
        // note: removed input ternary on transition states, so that, for instance, a negedge pulse will be generated when the input pulses high for one clock cycle
    
    assign Y = (ps == (PE ? 2'b01 : 2'b10)) ? 1'b1 : 1'b0;
    // output is high on low to high transition state (2'b01) if PE == 1
    // output is high on high to low transition state (2'b10) if PE == 0
endmodule
