
`timescale 1ns/1ps


module IFetch(input clk, rst,
              input [31:0] Addr_result,
              input Zero,                     //1 means the result is 0
              input [31:0] read_data_1,       // used by 'jr'.
              input Branch,                   // 1 means the instruction is beq
              input nBranch,                  // 1 means the instruction is bne
              input Jmp,                      // 1 means the instruction is j
              input Jal,                      // 1 means the instruction is jal
              input Jr,                       // 1 means the instruction is jr
              input [31:0] iInstruction,      // the instruction fetched from instruction memory
              output [31:0] oInstruction,     // the instruction fetched from instruction memory
              output [31:0] branch_base_addr, // actually pc+4, to ALU, for branch use
              output [31:0] link_addr);       // actually pc+4, to Decoder, for jal use
endmodule
