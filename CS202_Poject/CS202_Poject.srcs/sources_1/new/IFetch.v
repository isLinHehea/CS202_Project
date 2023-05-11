
`timescale 1ns/1ps


module iFetch(input clk, rst,
              input [31:0] addr_result,       //
              input zero,                     //1 means the result is 0
              input [31:0] read_data_1,       // used by 'jr'.
              input branch,                   // 1 means the instruction is beq
              input nBranch,                  // 1 means the instruction is bne
              input jmp,                      // 1 means the instruction is j
              input jal,                      // 1 means the instruction is jal
              input jr,                       // 1 means the instruction is jr
              input [31:0] iInstruction,      // the instruction fetched from instruction memory
              output [31:0] oInstruction,     // the instruction fetched from instruction memory
              output [31:0] branch_base_addr, // actually pc+4, to ALU, for branch use
              output [31:0] link_address,     // actually pc+4, to Decoder, for jal use
              output reg[31:0] pc);
    
    
    reg [31:0] next_pc;
    
    // combinational logic: next_pc
    always @(*) begin
        if (((branch == 1) && (zero == 1)) || ((nBranch == 1) && (zero == 0))) // beq, bne
            next_pc = addr_result; // branch
        else if (jr == 1)
            next_pc = read_data_1; // the value of $31 register
        else if ((jmp == 1) || (jal == 1)) // j, jal
            next_pc = {pc[31:28], iInstruction[25:0],2'b00}; // the address to jump to
        else
            next_pc = pc+4; // pc+4
    end
    
    
    always @(negedge clk) begin
        if ((jmp == 1) || (jal == 1))
            link_addr < = (pc+4);
        else 
            link_addr <= link_addr;
        end
        
        always @(negedge clk) begin
            if (rst == 1) pc  = 32'h0000_0000;
            else pc <= next_pc;
        end
endmodule
