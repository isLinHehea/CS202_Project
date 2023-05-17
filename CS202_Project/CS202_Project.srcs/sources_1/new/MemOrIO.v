`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/12 11:40:39
// Design Name:
// Module Name: MemOrIO
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


module MemOrIO(input mRead,                 // read memory, from Controller
               input mWrite,                // write memory, from Controller
               input IORead,                // read IO, from Controller
               input IOWrite,               // write IO, from Controller
               input[31:0] addr_in,         // from alu_result in ALU
               output[31:0] addr_out,       // address to Data-Memory
               input[31:0] m_rdata,         // data read from Data-Memory
               input[15:0] io_rdata,        // data read from IO, 16 bits
               output[31:0] r_wdata,        // data to Decoder(register file)
               input[31:0] r_rdata,         // data read from Decoder(register file)
               output reg[31:0] write_data, // data to memory or I/O£¨m_wdata, io_wdata£©
               output LEDCtrl,              // LED Chip Select
               output SwitchCtrl,           // Switch Chip Select
               output TubeCtrl);
    
    assign addr_out   = addr_in;
    assign r_wdata    = (mRead == 1)? m_rdata:{{16{io_rdata[15]}},io_rdata};
    assign SwitchCtrl = (IORead == 1'b1 && addr_in[7:4] == 4'h7) ? 1'b1 : 1'b0;
    assign LEDCtrl    = (IOWrite == 1'b1 && addr_in[7:4] == 4'b0110) ? 1'b1 : 1'b0;
    assign TubeCtrl   = (IOWrite == 1'b1 && addr_in[7:4] == 4'b1000) ? 1'b1 : 1'b0;
    
    always @* begin
        if ((mWrite == 1)||(IOWrite == 1))
            write_data = r_rdata;
        else
            write_data = 32'hZZZZZZZZ;
    end
endmodule
