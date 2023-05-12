`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 11:02:42
// Design Name: 
// Module Name: Executer
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


module Executs(input[31:0] read_data_1,      //the source of inputA 
               input[31:0] read_data_2,      //one of the sources of inputB
               input[31:0] Sign_extend,      // one of the sources of inputB (maybe from register or an immediate)
               input[5:0] Function_opcode,       //instructions[5:0]
               input[5:0] Opcode,            //instruction[31:26]
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
               
    wire[31:0] inputA ,inputB; 
    wire[5:0] Exe_code; 
    wire[2:0] ALU_ctl; 
    wire[2:0] Sftm; 
    reg[31:0] ALU_output_mux; 
    reg[31:0] Shift_Result; 
    wire[32:0] Branch_Addr; 

    assign inputA  = read_data_1; 
    assign inputB = (ALUSrc == 0) ? read_data_2 : Sign_extend[31:0];
    assign Exe_code = (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1]; 
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1])); 
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Sftm = Function_opcode[2:0];

    always @ (ALU_ctl or inputA  or inputB)
    begin case (ALU_ctl)
        3'b000:ALU_output_mux = inputA  & inputB;
        3'b001:ALU_output_mux = inputA  | inputB;
        3'b010:ALU_output_mux = $signed (inputA ) + $signed(inputB);
        3'b011:ALU_output_mux = inputA  + inputB;
        3'b100:ALU_output_mux = inputA  ^ inputB;
        3'b101:ALU_output_mux = ~ inputA  | inputB;
        3'b110:ALU_output_mux = $signed (inputA ) - $signed(inputB);
        3'b111:ALU_output_mux = inputA  - inputB;
        default:ALU_output_mux = 32'h00000000; 
    endcase 
    end

    always @* begin 
        if(Sftmd) 
            case(Sftm[2:0]) 
                3'b000:Shift_Result = inputB << Shamt; //Sll rd,rt,shamt 00000 
                3'b010:Shift_Result = inputB >> Shamt; //Srl rd,rt,shamt 00010 
                3'b100:Shift_Result = inputB << inputA ; //Sllv rd,rt,rs 000100 
                3'b110:Shift_Result = inputB >> inputA ; //Srlv rd,rt,rs 000110 
                3'b011:Shift_Result = $signed(inputB) >>> Shamt; //Sra rd,rt,shamt 00011 
                3'b111:Shift_Result = $signed(inputB) >>> inputA ; //Srav rd,rt,rs 00111 
                default:Shift_Result = inputB; 
            endcase 
        else Shift_Result = inputB; 
    end

    always @* begin 
    //set type operation (slt, slti, sltu, sltiu) 
    if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) ALU_result = ALU_output_mux[31]==1 ? 1:0; 
    //lui operation 
    else if((ALU_ctl==3'b101) && (I_format==1)) ALU_result[31:0]={inputB[15:0],{16{1'b0}}}; 
    //shift operation 
    else if(Sftmd==1) ALU_result = Shift_Result ; 
    //other types of operation in ALU (arithmatic or logic calculation) 
    else ALU_result = ALU_output_mux[31:0]; 
    end

    assign Zero = (ALU_output_mux == 32'b0) ? 1'b1 : 1'b0;
    assign Branch_Addr = PC_plus_4[31:2] + Sign_extend;
    assign Addr_Result = Branch_Addr[31:0];
endmodule
