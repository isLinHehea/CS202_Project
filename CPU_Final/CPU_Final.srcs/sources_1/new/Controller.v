`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Controller(input[5:0] Opcode,           // Instruction[31:26]
                  input[5:0] Func_opcode,      // Instructions[5:0]
                  input[21:0] ALU_result_high, // From executer, Alu_Result[31:10]
                  output Jr,                   // Jr
                  output Jmp,                  // J
                  output Jal,                  // Jal
                  output Branch,               // beq
                  output nBranch,              // bne
                  output RegDST,               // 1 indicate destination register is "rd"(R),otherwise it's "rt"(I)
                  output MemOrIOtoReg,         // 1 indicate read data from memory or IO and write it into register
                  output ALUSrc,               // 1 indicate the 2nd data is immidiate (except "beq","bne")
                  output RegWrite,             // 1 indicate write register(R,I(lw)), otherwise it's not
                  output mRead,                // 1 is to read from memory
                  output mWrite,               // 1 is to write into memory
                  output IORead,               // 1 means I/O read
                  output IOWrite,              // 1 means I/O write
                  output Sftmd,                // 1 indicate the instruction is shift instruction
                  output I_format,             // I_format is 1 bit width port
                  /* 1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW" */
                  output[1:0] ALUOp);          // ALUOp is multi bit width port
                  /* if the instruction is R-type or I_format, ALUOp is 2'b10;
                  if the instruction is "beq" or "bne", ALUOp is 2'b01;
                  if the instruction is "lw" or "sw", ALUOp is 2'b00;*/

    wire R_format;
    wire lw;
    wire sw;

    assign R_format = (Opcode == 6'b000000)? 1'b1:1'b0;
    assign I_format = (Opcode[5:3] == 3'b001) ? 1'b1:1'b0;

    assign RegDST   = R_format;

    assign lw       = (Opcode == 6'b100011)? 1'b1:1'b0;
    assign sw       = (Opcode == 6'b101011)? 1'b1:1'b0;

    assign Jal      = (Opcode == 6'b000011)? 1'b1:1'b0;
    assign Jr       = (Opcode == 6'b000000 && Func_opcode == 6'b001000)? 1'b1:1'b0;
    assign RegWrite = (I_format || lw || Jal || R_format) && ~Jr;
    assign ALUSrc  = (I_format || lw || sw);
    assign Branch  = (Opcode == 6'b000100)? 1'b1:1'b0;
    assign nBranch = (Opcode == 6'b000101)? 1'b1:1'b0;
    assign Jmp     = (Opcode == 6'b000010)? 1'b1:1'b0;

    assign mWrite       = (sw == 1'b1 && (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign mRead        = (lw == 1'b1 && (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign IORead       = (lw == 1'b1 && (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    assign IOWrite      = (sw == 1'b1 && (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    assign MemOrIOtoReg = IORead || mRead;

    assign Sftmd = (((Func_opcode == 6'b000000)||(Func_opcode == 6'b000010)||(Func_opcode == 6'b000011)||(Func_opcode == 6'b000100)||(Func_opcode == 6'b000110)||(Func_opcode == 6'b000111))&& R_format)? 1'b1:1'b0;
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};

endmodule
