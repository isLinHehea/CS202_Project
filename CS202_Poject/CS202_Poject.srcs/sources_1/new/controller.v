
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module controller(input [5:0] opcode,           // from iFetch, instruction[31..26]
                  input [5:0] func_opcode,      // from iFetch, r-type instructions[5..0]
                  input [21:0] alu_result_high, // from Executer, alu_result[31..10]
                  output jr,                    // 1 means the instruction is jr
                  output jmp,                   // 1 means the instruction is j
                  output jal,                   // 1 means the instruction is jal
                  output branch,                // 1 means the instruction is beq
                  output nBranch,               // 1 means the instruction is bne
                  output regDst,                // 1 means the destination register is "rd"(R), otherwise it's "rt"(I)
                  output memOrIOtoReg,          // 1 means the data is from memory or I/O, to register(i.e. reading is needed)
                  output regWrite,              // 1 means needs to write register
                  output memRead,               // 1 means reading from memory
                  output memWrite,              // 1 means writing to memory
                  output ioRead,                // 1 means I/O read
                  output ioWrite,               // 1 means I/O write
                  output aluSrc,                // 1 means the second operand is immediate number(except beq and bne)
                  output sftmd,                 // 1 means shift
                  output I_format,              // 1 means I-type(except beq, bne, lw, sw)
                  output [1:0] aluOp);          //if the instruction is R-type or I-format, ALUOp[1] is 1, 
wire lw, sw, R_format;

assign lw           = (opcode == 6'b100011)? 1'b1:1'b0;
assign sw           = (opcode == 6'b101011)? 1'b1:1'b0;
assign regWrite     = (R_format || lw || jal || I_format) && ~(jr); // Write memory or write IO
assign memRead      = (lw == 1'b1 && (alu_result_high[21:0] != 22'h3FFFFF))? 1'b1:1'b0; // Read memory
assign memWrite     = (sw == 1'b1 && (alu_result_high[21:0] != 22'h3FFFFF))? 1'b1:1'b0; // Write memory
assign ioRead       = (lw == 1'b1 && (alu_result_high[21:0] == 22'h3FFFFF))? 1'b1:1'b0; // Read IO
assign ioWrite      = (sw == 1'b1 && (alu_result_high[21:0] == 22'h3FFFFF))? 1'b1:1'b0; // Write IO
assign memOrIOtoReg = ioRead || memRead;

assign jal     = (opcode == 6'b000011)? 1'b1:1'b0;
assign jr      = (opcode == 6'b000000 && func_opcode == 6'b001000)? 1'b1:1'b0;
assign jmp     = (opcode == 6'b000010)? 1'b1:1'b0;
assign branch  = (opcode == 6'b000100)? 1'b1:1'b0;
assign nBranch = (opcode == 6'b000101)? 1'b1:1'b0;

assign I_format = (opcode[5:3] == 3'b001)? 1'b1:1'b0;
assign R_format = (opcode == 6'b000000)? 1'b1:1'b0;
assign regDst = R_format

assign aluSrc = I_format || (opcode == 6'b100011) || (opcode == 6'b101011);
assign aluOp  = {(R_format || I_format),(branch || nBranch)};

assign sftmd = (((func_opcode == 6'b000000)||(func_opcode == 6'b000010)
||(func_opcode == 6'b000011)||(func_opcode == 6'b000100)
||(func_opcode == 6'b000110)||(func_opcode == 6'b000111))
&& R_format)? 1'b1:1'b0;

endmodule
