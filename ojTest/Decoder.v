module decode32(read_data_1,
                read_data_2,
                Instruction,
                mem_data,
                ALU_result,
                Jal,
                RegWrite,
                MemtoReg,
                RegDst,
                Sign_extend,
                clock,
                reset,
                opcplus4);
    output[31:0] read_data_1;               // 输出的第�?操作�?
    output[31:0] read_data_2;               // 输出的第二操作数
    input[31:0]  Instruction;               // 取指单元来的指令
    input[31:0]  mem_data;   				//  从DATA RAM or I/O port取出的数�?
    input[31:0]  ALU_result;   				// 从执行单元来的运算的结果
    input        Jal;                       //  来自控制单元，说明是JAL指令
    input        RegWrite;                  // 来自控制单元
    input        MemtoReg;              // 来自控制单元
    input        RegDst;
    output[31:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock,reset;                // 时钟和复�?
    input[31:0]  opcplus4;                 // 来自取指单元，JAL中用
    
    wire[5:0] opcode     = Instruction[31:26];
    wire[4:0] rs         = Instruction[25:21];
    wire[4:0] rt         = Instruction[20:16];
    wire[4:0] rd         = Instruction[15:11];
    wire[15:0] immediate = Instruction[15:0];
    reg[31:0] register[0:31];
    wire[4:0] write_reg = (6'b000011 == opcode & Jal)?5'b11111:(RegDst)?rd:rt;
    
    integer i;
    always @(posedge clock, posedge reset) begin
        if (reset) begin
            for(i = 0; i<= 31; i = i+1)
                register[i] <= 32'b0;
        end
        else begin
            if ((RegWrite || Jal) && write_reg != 0) begin
                register[write_reg] <= ((6'b000011 == opcode && 1'b1 == Jal)?opcplus4:(MemtoReg?mem_data:ALU_result));
            end
        end
    end
    
    assign Sign_extend = (6'b001100 == opcode || 6'b001101 == opcode || 6'b001110 == opcode|| 6'b001011 == opcode)?{{16{1'b0}},immediate}:{{16{immediate[15]}},immediate};
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];
    
endmodule
