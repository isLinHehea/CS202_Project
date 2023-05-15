module executs32(Read_data_1,
                 Read_data_2,
                 Sign_extend,
                 Function_opcode,
                 Exe_opcode,
                 ALUOp,
                 Shamt,
                 ALUSrc,
                 I_format,
                 Zero,
                 Jr,
                 Sftmd,
                 ALU_Result,
                 Addr_Result,
                 PC_plus_4);
    input[31:0]  Read_data_1;		// 从译码单元的Read_data_1中来
    input[31:0]  Read_data_2;		// 从译码单元的Read_data_2中来
    input[31:0]  Sign_extend;		// 从译码单元来的扩展后的立即数
    input[5:0]   Function_opcode;  	// 取指单元来的r-类型指令功能�??,r-form instructions[5:0]
    input[5:0]   Exe_opcode;  		// 取指单元来的操作�??
    input[1:0]   ALUOp;             // 来自控制单元的运算指令控制编�??
    input[4:0]   Shamt;             // 来自取指单元的instruction[10:6]，指定移位次�??
    input  		 Sftmd;            // 来自控制单元的，表明是移位指�??
    input        ALUSrc;            // 来自控制单元，表明第二个操作数是立即数（beq，bne除外�??
    input        I_format;          // 来自控制单元，表明是除beq, bne, LW, SW之外的I-类型指令
    input        Jr;               // 来自控制单元，表明是JR指令
    output       Zero;              // �??1表明计算值为0
    output [31:0] ALU_Result;        // 计算的数据结�??
    output[31:0] Addr_Result;		// 计算的地�??结果
    input[31:0]  PC_plus_4;         // 来自取指单元的PC+4
    
    wire[31:0] inputA ,inputB;
    wire[5:0] Exe_code;
    wire[2:0] ALU_ctl;
    wire[2:0] Sftm;
    reg[31:0] ALU_o_mux;
    reg[31:0] Shift_Result;
    reg[31:0] ALU_result;
    
    assign inputA     = Read_data_1;
    assign inputB     = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
    assign Exe_code   = (I_format == 0) ? Function_opcode : { 3'b000 , Exe_opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Sftm       = Function_opcode[2:0];
    
    always @ (ALU_ctl or inputA  or inputB)
        begin case (ALU_ctl)
        3'b000:ALU_o_mux  = inputA  & inputB;
        3'b001:ALU_o_mux  = inputA  | inputB;
        3'b010:ALU_o_mux  = $signed (inputA) + $signed(inputB);
        3'b011:ALU_o_mux  = inputA  + inputB;
        3'b100:ALU_o_mux  = inputA  ^ inputB;
        3'b101:ALU_o_mux  = ~ inputA  | inputB;
        3'b110:ALU_o_mux  = $signed (inputA) - $signed(inputB);
        3'b111:ALU_o_mux  = inputA  - inputB;
        default:ALU_o_mux = 32'h00000000;
        endcase
    end
    
    always @* begin
        if (Sftmd)
            case(Sftm[2:0])
                3'b000:Shift_Result  = inputB << Shamt;
                3'b010:Shift_Result  = inputB >> Shamt;
                3'b100:Shift_Result  = inputB << inputA ;
                3'b110:Shift_Result  = inputB >> inputA ;
                3'b011:Shift_Result  = $signed(inputB) >>> Shamt;
                3'b111:Shift_Result  = $signed(inputB) >>> inputA ;
                default:Shift_Result = inputB;
            endcase
            else Shift_Result = inputB;
            end
        
    always @* begin
        if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1))||((ALU_ctl[2:1] == 2'b11) && (I_format == 1)))
            ALU_result <= ALU_o_mux[31] == 1 ? 1:0;
        else if ((ALU_ctl == 3'b101) && (I_format == 1))
            ALU_result[31:0] = {inputB[15:0],{16{1'b0}}};
        else if (Sftmd == 1)
            ALU_result = Shift_Result;
        else
            ALU_result = ALU_o_mux[31:0];
    end

    assign Zero        = (ALU_o_mux == 32'b0) ? 1'b1 : 1'b0;
    assign ALU_Result = ALU_result;
    assign Addr_Result = PC_plus_4[31:2] + Sign_extend;
endmodule
