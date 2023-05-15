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


module CPU(input fpga_rst,        //Active High 正常模式
           input fpga_clk,
           input start_pg,        //Active High 通信模式
           input [15:0] switch,
           output [15:0] led,
           input rx,
           output tx,
           output [7:0] seg_sign,
           output [7:0] seg_en);
    
    //  Reset
    wire cpu_clk, upg_clk_i, upg_clk_o;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    reg upg_rst;
    wire rst;
    
    BUFG U1(.I(start_pg), .O(spg_bufg));
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
    assign rst = fpga_rst | !upg_rst;
    
    //  Clock
    cpu_clk cpu_clk_inst(
    .fpga_clk(fpga_clk),
    .cpu_clk(cpu_clk),
    .upg_clk(upg_clk_i)
    );
    
    //  Uart
    uart_bmpg_0 uart_inst(
    .upg_clk_i(upg_clk_i),
    .upg_rst_i(upg_rst),
    .upg_rx_i(rx),
    .upg_clk_o(upg_clk_o),
    .upg_wen_o(upg_wen_o),
    .upg_adr_o(upg_adr_o),
    .upg_dat_o(upg_dat_o),
    .upg_done_o(upg_done_o)
    );
    
    wire RegDst, Branch, nBranch, RegWrite, ALUSrc, MemWrite, MemorIOtoReg;
    wire[1:0] ALUOp;
    wire Jmp, Jal, Jr, Zero, MemRead, IORead, IOWrite, I_format, Sftmd;
    wire LEDCtrl, SwitchCtrl, TubeCtrl, PianoCtrl, UartCtrl;
    wire [31:0] read_data;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] Instruction_i;
    wire [31:0] Instruction_o;
    wire [31:0] link_addr;
    wire [31:0] branch_base_addr;
    wire [31:0] Addr_result;
    wire [31:0] ALU_result;
    wire[31:0] Sign_extend;
    wire [13:0] rom_adr_o;
    wire [31:0] addr_out;
    wire[31:0] write_data;
    wire [31:0] ram_dat_o;
    wire [15:0] io_rdata;
    
    
    //  Instruction Fetch
    IFetch IFetch_inst(
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
    .Instruction_i(Instruction_i),
    .Instruction_o(Instruction_o),
    .branch_base_addr(branch_base_addr),
    .link_addr(link_addr),
    .fetch_addr(rom_adr_o)
    );
    
    //  Instruction Memory
    ProgramROM ProgramROM_inst (
    .rom_clk_i(cpu_clk),
    .rom_adr_i(rom_adr_o),
    .Instruction_o(Instruction_i),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    //  Decoder
    Decoder Decoder_inst (
    .clk(cpu_clk),
    .rst(rst),
    .Instruction_i(Instruction_o),
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
    
    // Controller
    Controller Controller_inst (
    .Opcode(Instruction_o[31:26]),
    .Func_opcode(Instruction_o[5:0]),
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
    
    // Data Memory
    DMemory DMemory_inst (
    .ram_clk_i(cpu_clk),
    .ram_wen_i(MemWrite),
    .ram_adr_i(addr_out[15:2]),
    .ram_dat_i(write_data),
    .ram_dat_o(ram_dat_o),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & upg_adr_o[14]),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    // MemOrIO
    MemOrIO  MemOrIO_inst(
    .mRead(MemRead),
    .mWrite(MemWrite),
    .ioRead(IORead),
    .ioWrite(IOWrite),
    .addr_in(ALU_result),
    .addr_out(addr_out),
    .m_rdata(ram_dat_o),
    .io_rdata(io_rdata),
    .r_wdata(read_data),
    .r_rdata(read_data_2),
    .write_data(write_data),
    .LEDCtrl(LEDCtrl),
    .SwitchCtrl(SwitchCtrl),
    .TubeCtrl(TubeCtrl),
    .PianoCtrl(PianoCtrl),
    .UartCtrl(UartCtrl)
    );
    
    //  Executer
    Executer Executer_inst (
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .Sign_extend(Sign_extend),
    .Func_opcode(Instruction_o[5:0]),
    .Opcode(Instruction_o[31:26]),
    .Shamt(Instruction_o[10:6]),
    .branch_base_addr(branch_base_addr),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .Jr(Jr),
    .Zero(Zero),
    .ALU_result(ALU_result),
    .Addr_result(Addr_result)
    );
    
endmodule
