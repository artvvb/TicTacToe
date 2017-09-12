`timescale 1ns / 1ps
module go_decode(
    input [9:0] gameover,
    input [3:0] addr,
    output reg [11:0] color
    );
    //output black if not gameover or not on winning line
    //output green if gameover and on winning line
    always@(gameover, addr)
        if (~gameover[9])
            color = 12'h000;
        else case (addr) // see go_encode for descriptions of indices
            4'h0: color = (gameover[0] | gameover[3] | gameover[6]              ) ? 12'h0f0 : 12'h000;//0F0 == green
            4'h1: color = (gameover[0] | gameover[4]                            ) ? 12'h0f0 : 12'h000;
            4'h2: color = (gameover[0] | gameover[5] | gameover[7]              ) ? 12'h0f0 : 12'h000;
            4'h4: color = (gameover[1] | gameover[3]                            ) ? 12'h0f0 : 12'h000;
            4'h5: color = (gameover[1] | gameover[4] | gameover[6] | gameover[7]) ? 12'h0f0 : 12'h000;
            4'h6: color = (gameover[1] | gameover[5]                            ) ? 12'h0f0 : 12'h000;
            4'h8: color = (gameover[2] | gameover[3] | gameover[7]              ) ? 12'h0f0 : 12'h000;
            4'h9: color = (gameover[2] | gameover[4]                            ) ? 12'h0f0 : 12'h000;
            4'ha: color = (gameover[2] | gameover[5] | gameover[6]              ) ? 12'h0f0 : 12'h000;
            default: color = 12'h000;
        endcase
endmodule
