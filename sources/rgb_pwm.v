`timescale 1ns / 1ps
module rgb_pwm(
    input        clk,
    input        rst,
    input  [2:0] color,
    output [2:0] RGB
);
    wire [15:0] C;
    wire        pwm;
    
    counter #(
        .N  (16),     // using a long pwm cycle gives the led time to get less bright before the power comes back on (led requires time to discharge)
        .M  (2**16-1) // however, too long of an led duty cycle would cause notice-able flickering. 2^16*10ns seems a happy medium
    ) m0 (
        .clk    (clk),
        .rst    (rst),
        .E      (1'b1),
        .C      (C),
        .T      ()
    );
    assign pwm = C[15]; // 50% duty cycle, could parameterize this
    assign RGB = {3{pwm}} & color; // when pwm is low (50% of the time) output black, else, output expected color
endmodule
