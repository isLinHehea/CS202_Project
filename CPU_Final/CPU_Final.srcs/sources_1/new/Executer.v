
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Executer(input[31:0] read_data_1,
                input[31:0] read_data_2,
                input[31:0] Sign_extend,
                input[5:0] Func_opcode,
                input[5:0] Opcode,
                input[1:0] ALUOp,              // from controller
                input[4:0] Shamt,              // instruction[10:6]
                input ALUSrc,                  // 表明第二个操作数是立即数（beq，bne除外�?
                input I_format,                // 表明是除beq, bne, LW, SW之外的I-类型指令
                input Jr,                      
                input Sftmd,                   // 1 means shift
                output Zero,                   // 1 means result is 0.
                output reg[31:0] ALU_result,
                output[31:0] Addr_result,
                input[31:0] branch_base_addr); // PC+4 for branch
    
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
            ALU_result = (ALU_output_mux[31] == 1)? 1 : 0;
            end
        else if ((ALU_ctl == 3'b101) && (I_format == 1)) begin
            ALU_result = {inputB[15:0], 16'h0000};
        end
            else if (Sftmd == 1) begin
            ALU_result = Shift_result;
            end
        else begin
            ALU_result = ALU_output_mux;
        end
    end
        
    assign Addr_result = branch_base_addr + (Sign_extend << 2);
    assign Zero        = (ALU_output_mux == 32'h0000_0000) ? 1'b1 : 1'b0;
    
endmodule
