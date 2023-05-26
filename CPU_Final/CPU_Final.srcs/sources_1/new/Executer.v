
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Executer(input[31:0] read_data_1,       // the source of inputA
                input[31:0] read_data_2,       // one of the sources of Binput
                input[31:0] Sign_extend,       // one of the sources of Binp
                input[5:0] Func_opcode,        // Instructions[5:0]
                input[5:0] Opcode,             // Instruction[31:26]
                input[1:0] ALUOp,              // { (R_format || I_format), (Branch ||nBranch) }
                input[4:0] Shamt,              // Instruction[10:6], the amount of shift bits
                input ALUSrc,                  // 1 means the 2nd operand is an immediate (except beq, bne)
                input I_format,                // 1 means I-Type instruction except beq, bne, LW, SW
                input Sftmd,                   // 1 means this is a shift instruction
                output Zero,                   // 1 means the ALU_reslut is zero, 0 otherwise
                output reg[31:0] ALU_result,   // the ALU calculation result
                output[31:0] Addr_result,      // the calculated instruction address
                input[31:0] branch_base_addr); // pc+4

    wire[31:0] inputA, inputB;
    reg[31:0] Shift_result;
    reg[31:0] ALU_output_mux;
    wire[2:0] ALU_ctl;
    wire[5:0] Exe_code;
    wire[2:0] Sftm;

    assign inputA     = read_data_1;
    assign inputB     = (ALUSrc == 0) ? read_data_2 : Sign_extend[31:0];
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Exe_code   = (I_format == 0) ? Func_opcode : {3'b000, Opcode[2:0]};
    assign Sftm       = Func_opcode[2:0];

    always @(ALU_ctl or inputA or inputB) begin
        case (ALU_ctl)
            3'b000:ALU_output_mux   = inputA & inputB;//and andi
            3'b001:ALU_output_mux   = inputA | inputB;//or ori
            3'b010:ALU_output_mux   = $signed(inputA) + $signed(inputB);//add addi lw sw
            3'b011:ALU_output_mux   = inputA + inputB;//addu addiu
            3'b100:ALU_output_mux   = inputA ^ inputB;//xor xori
            3'b101:ALU_output_mux   = ~(inputA | inputB);//nor lui
            3'b110:ALU_output_mux   = $signed(inputA) - $signed(inputB);//sub slt slti beq bne
            3'b111:ALU_output_mux   = inputA - inputB;//subu sltiu sltiu sltu
            default: ALU_output_mux = 32'h0000_0000;
        endcase
    end

    always @* begin
        if (Sftmd) begin
            case(Sftm[2:0])
                3'b000:Shift_result  = inputB << Shamt;        //Sll rd,rt,shamt 00000
                3'b010:Shift_result  = inputB >> Shamt;        //Srl rd,rt,shamt 00010
                3'b100:Shift_result  = inputB << inputA;       //Sllv rd,rt,rs 00010
                3'b110:Shift_result  = inputB >> inputA;       //Srlv rd,rt,rs 00110
                3'b011:Shift_result  = $signed(inputB) >>> Shamt;//Sra rd,rt,shamt 00011
                3'b111:Shift_result  = $signed(inputB) >>> inputA;//Srav rd,rt,rs 00111
                default:Shift_result = inputB;
            endcase
        end
        else begin
            Shift_result = inputB;
        end
    end

    always @* begin
        if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1'b1)) ||((ALU_ctl == 3'b110) && (Opcode == 6'b001010))|| ((ALU_ctl == 3'b111) && (Opcode == 6'b001011))) begin
            ALU_result = (ALU_output_mux[31] == 1'b1) ? 1'b1 : 1'b0; // slt, slti, sltu, sltiu
        end
        else if ((ALU_ctl == 3'b101) && (I_format == 1'b1)) begin
            ALU_result = {inputB[15:0], 16'h0000}; // lui
        end
        else if (Sftmd == 1'b1) begin
            ALU_result = Shift_result; //shift
        end
        else begin
            ALU_result = ALU_output_mux;
        end
    end

    assign Addr_result = branch_base_addr + (Sign_extend << 2);
    assign Zero        = (ALU_output_mux == 32'h0000_0000) ? 1'b1 : 1'b0;

endmodule
