`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds(input clk, rst,
            input IOWrite,
            input LEDCtrl,
            input[1:0] ledaddr,
            input[15:0] ledwdata,
            output reg[15:0] led);
    
    
    always@(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 16'h0000;
        end
        else if (LEDCtrl && IOWrite) begin
        if (ledaddr == 2'b00)
            led[15:0] <= ledwdata[15:0];
        else if (ledaddr == 2'b10)
            led[15:0] <= { ledwdata[7:0], led[7:0] };
        else
            led <= led;
        end
        else begin
        led <= led;
        end
    end
endmodule
