`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

    module ioread(reset,ior,switchctrl,ioread_data,ioread_data_switch);
    input reset;	
    input ioRead;              // from controller, 1 means read from input device
    input switchctrl;		
    input[15:0] ioread_data_switch;  // from switch
    output[15:0] ioread_data;	// to memOrIO
    
    reg[15:0] ioread_data;
    
    always @* begin
        if(reset == 1)
            ioread_data = 16'b0000000000000000;
        else if(ior == 1) begin
            if(switchctrl == 1)
                ioread_data = ioread_data_switch;
            else   ioread_data = ioread_data;
        end
    end
endmodule
