`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 11:02:42
// Design Name: 
// Module Name: CPU
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


module CPU(input fpga_rst,        //Active High
           input fpga_clk,
           input start_pg,        //Active High
           input [15:0]switch2N4,
           output [15:0]led2N4,
           input rx,
           output tx,
           output [7:0] seg_sign,
           output [7:0] seg_en);
    
    wire cpu_clk;
    wire upg_clk, upg_clk_o;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg));
    reg upg_rst;
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    wire rst;
    assign rst = fpga_rst | !upg_rst;
    
    cpu_clk cpu_clk_instance(
    .fpga_clk(fpga_clk),
    .cpu_clk(cpu_clk),
    .upg_clk(upg_clk)
    );
    
    uart_bmpg_0 uart_instance(
    .upg_clk_i(upg_clk),
    .upg_rst_i(upg_rst),
    .upg_rx_i(rx),
    .upg_clk_o(upg_clk_o),
    .upg_wen_o(upg_wen_o),
    .upg_adr_o(upg_adr_o),
    .upg_dat_o(upg_dat_o),
    .upg_done_o(upg_done_o)
    );
    
    wire Branch, nBranch, Jmp, Jal, Jr, Zero;
    wire [31:0] branch_base_addr;
    wire [31:0] Addr_result;
    wire [31:0] read_data_1;
    wire [31:0] link_addr;
    wire [31:0] iInstruction;
    wire [31:0] oInstruction;
    
    IFetch iFetch(
    .clk(cpu_clk),
    .rst(rst),
    .Addr_result(Addr_result),
    .Zero(Zero),
    .read_data_1(read_data_1),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .Jr(Jr),
    .iInstruction(iInstruction),
    .oInstruction(oInstruction),
    .branch_base_addr(branch_base_addr),
    .link_addr(link_addr)
    );
    
    wire [31:0] ALU_result;
    wire [31:0] read_data;
    wire RegWrite, MemorIOtoReg, RegDst;
    wire[31:0] Sign_extend;
    wire [31:0] read_data_2;
    
    Decoder Decoder_inst (
    .clk(cpu_clk),
    .rst(rst),
    .Instruction(oInstruction),
    .read_data(read_data),
    .ALU_result(ALU_result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemorIOtoReg),
    .RegDst(RegDst),
    .link_addr(link_addr),
    .Sign_extend(Sign_extend),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2)
    );
    
    wire MemRead,MemWrite, IORead, IOWrite, ALUSrc, I_format, Sftmd;
    wire[1:0] ALUOp;
    
    Controller controller(
    .Opcode(oInstruction[31:26]),
    .Function_opcode(oInstruction[5:0]),
    .ALU_result_high(ALU_result[31:10]),
    .Jr(Jr),
    .Jmp(Jmp),
    .Jal(Jal),
    .Branch(Branch),
    .nBranch(nBranch),
    .RegDST(RegDST),
    .MemOrIOtoReg(MemOrIOtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .IORead(IORead),
    .IOWrite(IOWrite),
    .ALUSrc(ALUSrc),
    .Sftmd(Sftmd),
    .I_format(I_format),
    .ALUOp(ALUOp)
    );
    
    wire [31:0] addr_out;
    wire[31:0] write_data;
    
    DMemory DMemory_inst (
    .ram_clk_i(cpu_clk),
    .ram_wen_i(MemWrite),
    .ram_adr_i(addr_out[15:2]),
    .ram_dat_i(write_data),
    .ram_dat_o(ram_dat_o),
    .upg_rst_i(upg_rst_i),
    .upg_clk_i(upg_clk_i),
    .upg_wen_i(upg_wen_i),
    .upg_adr_i(upg_adr_i),
    .upg_dat_i(upg_dat_i),
    .upg_done_i(upg_done_i)
    );
    
    Executs Executs_inst (
    .read_data_1(read_data_1),      //the source of Ainput
    .read_data_2(read_data_2),      //one of the sources of Binput
    .Sign_extend(Sign_extend),      // one of the sources of Binput (maybe from register or an immediate)
    .func_opcode(func_opcode),       //instructions[5:0]
    .opcode(opcode),            //instruction[31:26]
    .Shamt(Shamt),             // instruction[10:6], the amount of shift bits
    .PC_plus_4(PC_plus_4),        // pc+4
    .ALUOp(ALUOp),             //{ (R_format || I_format), (Branch || nBranch) }
    .ALUSrc(ALUSrc),                 // 1 means the second operand is immediate number(except beq and bne)
    .I_format(I_format),               // 1 means I-Type instruction except beq, bne, LW, SW
    .Sftmd(Sftmd),                  // 1 means shift
    .Jr(Jr),                     // 1 means this is a jr instruction
    .Zero(Zero),                  // 1 means the ALU_result is 0
    .ALU_result(ALU_result), // the ALU calculation result
    .Addr_result(Addr_result)   // the calculated instruction address
    );
endmodule
