`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module switchs(input clk, rst,
               input IORead,
               input SwitchCtrl,
               input [1:0] switchaddr,
               input [15:0] switch,
               output reg [15:0] switchrdata,
               output reg [15:0] io_rdata
               );
    
    always @* begin
        if (rst == 1)
            io_rdata = 16'b0000000000000000;
        else if (IORead == 1) begin
            if (SwitchCtrl == 1)
                io_rdata = switchrdata;
            else io_rdata = io_rdata;
        end
    end
            
    always@(negedge clk or posedge rst) begin
        if (rst) begin
            switchrdata <= 0;
        end
        else if (SwitchCtrl && IORead) begin
        if (switchaddr == 2'b00)
            switchrdata[15:0] <= switch[15:0];
        else if (switchaddr == 2'b10)
            switchrdata[15:0] <= { 8'h00, switch[15:8] };
        else
            switchrdata <= switchrdata;
        end
        else begin
            switchrdata <= switchrdata;
        end
    end
endmodule
