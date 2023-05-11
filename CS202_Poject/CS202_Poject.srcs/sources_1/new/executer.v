`timescale 1ns / 1ps

module Executs(input[31:0] read_data_1,      //the source of Ainput
               input[31:0] read_data_2,      //one of the sources of Binput
               input[31:0] sign_extend,      // one of the sources of Binput (maybe from register or an immediate)
               input[5:0] func_opcode,       //instructions[5:0]
               input[5:0] opcode,            //instruction[31:26]
               input[4:0] Shamt,             // instruction[10:6], the amount of shift bits
               input[31:0] PC_plus_4,        // pc+4
               input[1:0] ALUOp,             //{ (R_format || I_format), (Branch || nBranch) }
               input ALUSrc,                 // 1 means the second operand is immediate number(except beq and bne)
               input I_format,               // 1 means I-Type instruction except beq, bne, LW, SW
               input Sftmd,                  // 1 means shift
               input Jr,                     // 1 means this is a jr instruction
               output Zero,                  // 1 means the ALU_result is 0
               output reg [31:0] ALU_result, // the ALU calculation result
               output [31:0] Addr_result);   // the calculated instruction address
endmodule
