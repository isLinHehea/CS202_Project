`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 11:02:42
// Design Name: 
// Module Name: Controller
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


module Controller(input [5:0] Opcode,           // from iFetch, instruction[31..26]
                  input [5:0] Func_opcode,      // from iFetch, r-type instructions[5..0]
                  input [21:0] ALU_result_high, // from Executer, alu_result[31..10]
                  output Jr,                    // 1 means the instruction is Jr
                  output Jmp,                   // 1 means the instruction is j
                  output Jal,                   // 1 means the instruction is Jal
                  output Branch,                // 1 means the instruction is beq
                  output nBranch,               // 1 means the instruction is bne
                  output RegDST,                // 1 means the destination register is "rd"(R), otherwise it's "rt"(I)
                  output MemOrIOtoReg,          // 1 means the data is from memory or I/O, to register(i.e. reading is needed)
                  output RegWrite,              // 1 means needs to write register
                  output MemRead,               // 1 means reading from memory
                  output MemWrite,              // 1 means writing to memory
                  output IORead,                // 1 means I/O read
                  output IOWrite,               // 1 means I/O write
                  output ALUSrc,                // 1 means the second operand is immediate number(except beq and bne)
                  output Sftmd,                 // 1 means shift
                  output I_format,              // 1 means I-type(except beq, bne, lw, sw)
                  output [1:0] ALUOp);          //if the instruction is R-type or I-format, ALUOp[1] is 1

wire lw, sw, R_format;
assign lw           = (Opcode == 6'b100011)? 1'b1:1'b0;
assign sw           = (Opcode == 6'b101011)? 1'b1:1'b0;
assign RegWrite     = (R_format || lw || Jal || I_format) && ~(Jr); // Write memory or write IO
assign MemRead      = (lw == 1'b1 && (ALU_result_high[21:0] != 22'h3FFFFF))? 1'b1:1'b0; // Read memory
assign MemWrite     = (sw == 1'b1 && (ALU_result_high[21:0] != 22'h3FFFFF))? 1'b1:1'b0; // Write memory
assign IORead       = (lw == 1'b1 && (ALU_result_high[21:0] == 22'h3FFFFF))? 1'b1:1'b0; // Read IO
assign IOWrite      = (sw == 1'b1 && (ALU_result_high[21:0] == 22'h3FFFFF))? 1'b1:1'b0; // Write IO
assign MemOrIOtoReg = IORead || MemRead;

assign Jal     = (Opcode == 6'b000011)? 1'b1:1'b0;
assign Jr      = (Opcode == 6'b000000 && Func_opcode == 6'b001000)? 1'b1:1'b0;
assign Jmp     = (Opcode == 6'b000010)? 1'b1:1'b0;
assign Branch  = (Opcode == 6'b000100)? 1'b1:1'b0;
assign nBranch = (Opcode == 6'b000101)? 1'b1:1'b0;

assign I_format = (Opcode[5:3] == 3'b001)? 1'b1:1'b0;
assign R_format = (Opcode == 6'b000000)? 1'b1:1'b0;
assign RegDST = R_format;

assign ALUSrc = I_format || (Opcode == 6'b100011) || (Opcode == 6'b101011);
assign ALUOp  = {(R_format || I_format),(Branch || nBranch)};

assign Sftmd = (((Func_opcode == 6'b000000)||(Func_opcode == 6'b000010)
||(Func_opcode == 6'b000011)||(Func_opcode == 6'b000100)
||(Func_opcode == 6'b000110)||(Func_opcode == 6'b000111))
&& R_format)? 1'b1:1'b0;

endmodule

