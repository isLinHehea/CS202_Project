`timescale 1ns / 1ps

module decoder(input clk, rst,
               input[31:0] instruction,   // from iFetch
               input[31:0] read_data,     // from DATA RAM or I/O
               input[31:0] ALU_result,    // from Executer
               input Jal,
               input RegWrite,
               input MemtoReg,
               input RegDst,
               input[31:0] opcplus4,      // from iFetch, pc+4 for jal use
               output[31:0] Sign_extend,
               output[31:0] read_data_1,
               output[31:0] read_data_2);
    
endmodule
