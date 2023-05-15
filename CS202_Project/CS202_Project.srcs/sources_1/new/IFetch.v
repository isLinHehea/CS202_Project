`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/12 11:02:42
// Design Name:
// Module Name: IFetch
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


module IFetch(input clk, rst,
              input Zero,                     //1 means the result is 0
              input Branch,                   // 1 means the instruction is beq
              input nBranch,                  // 1 means the instruction is bne
              input Jmp,                      // 1 means the instruction is j
              input Jal,                      // 1 means the instruction is jal
              input Jr,                       // 1 means the instruction is jr
              input [31:0] Addr_result,
              input [31:0] read_data_1,       // used by 'jr'.
              input [31:0] Instruction,       // the instruction fetched from instruction memory
              output [31:0] branch_base_addr, // actually pc+4, to ALU, for branch use
              output reg [31:0] link_addr,    // actually pc+4, to Decoder, for jal use
              output [13:0] fetch_addr);
    
    reg[31:0] PC, Next_PC;
    
    always @* begin
        if (((Branch == 1) && (Zero == 1)) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result;
        else if (Jr == 1)
            Next_PC = read_data_1;
        else
            Next_PC = PC + 4;
    end
    
    
    always @(negedge clk or posedge rst) begin
        if (rst == 1) begin
            PC <= 32'h0000_0000;
        end
        else begin
            if (Jal == 1)
                link_addr <= PC + 4;
            if ((Jmp == 1) || (Jal == 1))
                PC = {PC[31:28], Instruction[25:0], 2'b00};
            else
                PC <= Next_PC;
            end
        end
    assign fetch_addr       = PC[15:2];
    assign branch_base_addr = PC + 4;
    
endmodule
            
