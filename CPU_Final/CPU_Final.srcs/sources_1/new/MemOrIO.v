`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module MemOrIO(input mRead,
               input mWrite,
               input IORead,
               input IOWrite,
               input[31:0] m_rdata,
               input[15:0] io_rdata,
               input[31:0] r_rdata,
               output[31:0] r_wdata,
               output reg [31:0] write_data, // data to memory or I/O
               input[31:0] addr_in,          // from alu_result
               output[31:0] addr_out,        // address to data memory
               output LEDCtrl,
               output SEGCtrl,
               output VGACtrl,
               output SwitchCtrl);
    
    assign addr_out = addr_in;
    assign r_wdata  = (IORead == 1)?{16'h0000,io_rdata}:m_rdata;
    // may from memory or I/O, if from I/O, it is rdata's lower 16bit
    assign LEDCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0110)?1'b1:1'b0; // ledCtrl, 1 is effective;
    assign SEGCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0101)?1'b1:1'b0; //segCtrl, 1 is effective
    assign VGACtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b1001)?1'b1:1'b0; //vgaCtrl, 1 is effective
    assign SwitchCtrl = (IORead == 1'b1 && addr_in[7:4] == 4'b0111)?1'b1:1'b0; //switchCtrl, 1 is effective
    
    always @*begin
        if ((mWrite == 1'b1)||(IOWrite == 1'b1)) begin
            write_data = ((mWrite == 1'b1)?r_rdata:{16'h0000,r_rdata[15:0]});
            end
        else begin
            write_data = 32'hZZZZ_ZZZZ;
        end
    end
endmodule
