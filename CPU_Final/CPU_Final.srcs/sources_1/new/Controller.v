`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Controller(input[5:0] Opcode,           //instruction[31..26]
                  input[5:0] Func_opcode,      //r-type instructions[5..0]
                  input[21:0] ALU_result_high, // from executer, Alu_Result[31..10]
                  output MemOrIOtoReg,         // 1 is to read data from memory or I/O, to register
                  output Jr,                   // jr
                  output Jmp,                  // j
                  output Jal,                  // jal
                  output Branch,               // beq
                  output nBranch,              // bnq
                  output RegDST,               // 1 is the destination register is "rd"(R), otherwise it's "rt"(I)
                  output ALUSrc,               // 1 is the second operand is immediate number(except beq and bne)
                  output RegWrite,             // 1 is to write register
                  output mRead,                // 1 is to read from memory
                  output mWrite,
                  output IORead,               // 1 means I/O read
                  output IOWrite,              // 1 means I/O write
                  output I_format,             // 1 means I-type instruction(except beq, bne, lw, sw)
                  output Sftmd,                // 1 is to shift
                  output[1:0] ALUOp);          // if the instruction is R-type or I-format, ALUOp[1] is 1

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
    assign RegWrite = (I_format || lw || Jal  || R_format) && ~Jr;
    assign ALUSrc  = (I_format || lw || sw);
    assign Branch  = (Opcode == 6'b000100)? 1'b1:1'b0;
    assign nBranch = (Opcode == 6'b000101)? 1'b1:1'b0;
    assign Jmp     = (Opcode == 6'b000010)? 1'b1:1'b0;

    assign mWrite       = (sw == 1'b1 && (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign mRead        = (lw == 1'b1&& (ALU_result_high[21:0] != 22'b1111111111111111111111))?1'b1:1'b0;
    assign IORead       = (lw == 1'b1&& (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    assign IOWrite      = (sw == 1'b1&& (ALU_result_high[21:0] == 22'b1111111111111111111111))?1'b1:1'b0;
    assign MemOrIOtoReg = IORead || mRead;

    assign Sftmd = (((Func_opcode == 6'b000000)||(Func_opcode == 6'b000010)||(Func_opcode == 6'b000011)||(Func_opcode == 6'b000100)||(Func_opcode == 6'b000110)||(Func_opcode == 6'b000111))&& R_format)? 1'b1:1'b0;
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};

endmodule
