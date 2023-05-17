`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/16 00:04:15
// Design Name:
// Module Name: Light
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module LED(clk,
           rst,
           LED,
           LEDWrite,
           LEDCtrl,
           LEDAddr,
           LEDWdata
           );
    input clk;
    input rst;
    output[15:0] LED;
    input LEDWrite;
    input LEDCtrl;
    input[1:0] LEDAddr;
    input[15:0] LEDWdata;
    
    reg [15:0] LED;
    
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            LED <= 24'h000000;
        end
        else if (LEDCtrl && LEDWrite) begin
            if (LEDAddr == 2'b00)
                LED[15:0] <= LEDWdata[15:0];
            // else if (LEDAddr == 2'b10)
            //     LED[15:0] <= { LEDWdata[7:0], LED[7:0] };
            else
                LED <= LED;
        end
        else begin
            LED <= LED;
        end
    end
endmodule
