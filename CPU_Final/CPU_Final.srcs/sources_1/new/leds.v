`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds(input clk,             // 20MHz CPU clk
            input rst,             // Reset
            input IOWrite,         // IO sign
            input LEDCtrl,         // LED ctrl
            input[1:0] ledaddr,    // LED address
            input[15:0] ledwdata,  // LED write data
            output reg[15:0] led); // LED
    
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 16'h0000;
        end
        else if (LEDCtrl && IOWrite) begin
            if (ledaddr == 2'b00)
                led[15:0] <= ledwdata[15:0];
            else if (ledaddr == 2'b10)
                led[15:0] <= { 8'h00, ledwdata[15:0] };
            else
                led <= led;
        end
        else begin
            led <= led;
        end
    end
endmodule
