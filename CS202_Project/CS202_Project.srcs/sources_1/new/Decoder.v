`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/12 11:02:42
// Design Name:
// Module Name: Decoder
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


module Decoder(input clk, rst,
               input[31:0] Instruction, // from iFetch
               input[31:0] mem_data,     // from DATA RAM or I/O
               input[31:0] ALU_result,    // from Executer
               input Jal,
               input RegWrite,
               input MemOrIOtoReg,
               input RegDST,
               input[31:0] link_addr,     // from iFetch, pc + 4 for jal use
               output[31:0] Sign_extend,
               output[31:0] read_data_1,
               output[31:0] read_data_2);
    
    wire[5:0] opcode     = Instruction[31:26];
    wire[4:0] rs         = Instruction[25:21];
    wire[4:0] rt         = Instruction[20:16];
    wire[4:0] rd         = Instruction[15:11];
    wire[15:0] immediate = Instruction[15:0];
    reg[31:0] register[0:31];
    wire[4:0] write_reg = (6'b000011 == opcode & Jal)?5'b11111:(RegDST)?rd:rt;
    
    integer i;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            for(i = 0; i<= 31; i = i+1)
                register[i] <= 32'b0;
        end
        else begin
            if ((RegWrite || Jal) && write_reg != 0) begin
                register[write_reg] <= ((6'b000011 == opcode && 1'b1 == Jal)?link_addr:(MemOrIOtoReg?mem_data:ALU_result));
            end
        end
    end
    
    assign Sign_extend = (6'b001100 == opcode || 6'b001101 == opcode || 6'b001110 == opcode|| 6'b001011 == opcode)?{{16{1'b0}},immediate}:{{16{immediate[15]}},immediate};
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];
    
endmodule
