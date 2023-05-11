`timescale 1ns / 1ps

module Dmemory(input ram_clk_i,         // from CPU top
               input ram_wen_i,         // from Controller
               input [31:0] ram_adr_i,  // from alu_result of ALU
               input [31:0] ram_dat_i,  // from read_data_2 of Decoder
               output [31:0] ram_dat_o, // the data read from data-ram
               // UART Programmer Pinouts
               input upg_rst_i,         // UPG reset (Active High)
               input upg_clk_i,         // UPG ram_clk_i (10MHz)
               input upg_wen_i,         // UPG write enable
               input [13:0] upg_adr_i,  // UPG write address
               input [31:0] upg_dat_i,  // UPG write data
               input upg_done_i);       // 1 if programming is finished
endmodule
