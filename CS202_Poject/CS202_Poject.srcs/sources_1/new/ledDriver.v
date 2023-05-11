` timescale 1ns / 1ps

module ledDriver(input clk, rst,
                 input ledCtrl,               // 1 works
                 input ioWrite,               // from memOrIO, 1 works
                 input [15:0] write_data,     // from memOrIO, 16 bits
                 output reg [15:0] led_data); // 16 bits
endmodule
