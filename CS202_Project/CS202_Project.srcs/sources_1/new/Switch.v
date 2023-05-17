`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/16 00:04:15
// Design Name:
// Module Name: Switch
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


module Switch(clk,
              rst,
              Switch,
              SwitchRead,
              SwitchCtrl,
              SwitchAddr,
              SwitchRdata);
    input clk;
    input rst;
    input [15:0] Switch;
    input SwitchRead;
    input SwitchCtrl;
    input[1:0] SwitchAddr;
    output [15:0] SwitchRdata;

    reg [15:0] SwitchRdata;
    
    always@(negedge clk or posedge rst) begin
        if (rst) begin
            SwitchRdata <= 0;
        end
        else if (SwitchCtrl && SwitchRead) begin
            if (SwitchAddr == 2'b00)
                SwitchRdata[15:0] <= Switch[15:0];
            // else if (SwitchAddr == 2'b10)
            //     SwitchRdata[15:0] <= 16'H00FF;
            else
                SwitchRdata <= SwitchRdata;
        end
        else begin
            SwitchRdata <= SwitchRdata;
        end
    end
endmodule
