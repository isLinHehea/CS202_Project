` timescale 1ns / 1ps

module switchDriver(
    input clk,rst;
    input switchCtrl; // 1 works
    input ioRead; // from memOrIO, 1 works
    input [15:0] board_data; // from memOrIO, 16 bits
    
    output reg [15:0] switch_data; // 16 bits
    
);
endmodule