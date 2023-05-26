`timescale 1ns / 1ps

module cpu(input fpga_clk,         // FPGA EGO1 Clock
           input fpga_rst,         // FPGA EGO1 Reset
           input start_pg,         // Uart Start
           input rx,               // Receive
           output tx,              // Transmit
           input[15:0] switch,     // Switch
           output wire [15:0] led, // LED
           // SEG
           output[7:0] an,         // Bit selective signal
           output[7:0] seg0,       // Segment-selected signal
           output[7:0] seg1,
           // VGA
           output [11:0] rgb,      // Red, green and blue color signals
           output hsync,           // Line synchronization signal
           output vsync);          // Field synchronization signal
    
    // UART Programmer Pinouts
    wire cpu_clk, upg_clk_i, upg_clk_o;
    wire upg_wen_o;   // Uart write out enable
    wire upg_done_o;  // Uart rx data have done
    wire [14:0] upg_adr_o;  // Data to which memory unit of program_rom/dmemory32
    wire [31:0] upg_dat_o;  // Data to program_rom or dmemory32
    wire spg_bufg, fpga_rst_o;
    reg upg_rst;
    wire rst;
    wire kickOff = upg_rst | (~upg_rst & upg_done_o);
    
    BUFG U1(.I(start_pg), .O(spg_bufg));
    BUFG U2(.I(fpga_rst), .O(fpga_rst_o));
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst    = 0;
        if (!fpga_rst_o) upg_rst = 1;
    end
    assign rst = !fpga_rst_o | !upg_rst;  //Reset
    
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
    .upg_done_o(upg_done_o),
    .upg_tx_o(tx)
    );
    
    wire Branch, nBranch, Jmp, Jal, Jr, Zero;
    wire RegWrite, RegDST;
    wire ALUSrc;
    wire MemOrIOtoReg;
    wire mRead;
    wire mWrite;
    wire IORead;
    wire IOWrite;
    wire I_format;
    wire Sftmd;
    
    wire [31:0] Instruction;
    wire [31:0] branch_base_addr;
    wire [31:0] Addr_Result;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    wire [31:0] link_addr;
    wire [31:0] mem_data;
    wire [31:0] Sign_extend;
    wire [1:0] ALUOp;
    wire [31:0] ALU_result;
    wire [31:0] ram_dat_o;
    wire [31:0] addr_out;
    wire [31:0] write_data;
    wire [15:0] switchrdata;
    wire [13:0] fetch_addr;
    wire SwitchCtrl, LEDCtrl, SEGCtrl, VGACtrl;
    
    //  Instruction Memory
    ProgramROM ProgramROM_inst(
    .rom_clk_i(cpu_clk),
    .rom_adr_i(fetch_addr),
    .Instruction_o(Instruction),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    //  Instruction Fetch
    IFetch ifetch(
    .clk(cpu_clk),
    .rst(rst),
    .Addr_result(Addr_Result),
    .read_data_1(read_data_1),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .Jr(Jr),
    .Zero(Zero),
    .Instruction(Instruction),
    .branch_base_addr(branch_base_addr),
    .link_addr(link_addr),
    .fetch_addr(fetch_addr)
    );
    
    //  Decoder
    Decoder decoder(
    .clk(cpu_clk),
    .rst(rst),
    .Instruction(Instruction),
    .mem_data(mem_data),
    .ALU_result(ALU_result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemOrIOtoReg),
    .RegDST(RegDST),
    .link_addr(link_addr),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .Sign_extend(Sign_extend)
    );
    
    //  Controller
    Controller control(
    .Opcode(Instruction[31:26]),
    .Func_opcode(Instruction[5:0]),
    .ALU_result_high(ALU_result[31:10]),
    .Jr(Jr),
    .Jmp(Jmp),
    .Jal(Jal),
    .Branch(Branch),
    .nBranch(nBranch),
    .RegDST(RegDST),
    .ALUSrc(ALUSrc),
    .MemOrIOtoReg(MemOrIOtoReg),
    .RegWrite(RegWrite),
    .mRead(mRead),
    .mWrite(mWrite),
    .IORead(IORead),
    .IOWrite(IOWrite),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .ALUOp(ALUOp)
    );
    
    //  Executer
    Executer executer(
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .Sign_extend(Sign_extend),
    .Func_opcode(Instruction[5:0]),
    .Opcode(Instruction[31:26]),
    .ALUOp(ALUOp),
    .Shamt(Instruction[10:6]),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Zero(Zero),
    .Sftmd(Sftmd),
    .ALU_result(ALU_result),
    .Addr_result(Addr_Result),
    .branch_base_addr(branch_base_addr)
    );
    
    //  Data Memory
    DMemory dmemory(
    .ram_clk_i(cpu_clk),
    .ram_wen_i(mWrite),
    .ram_adr_i(addr_out),
    .ram_dat_i(write_data),
    .ram_dat_o(ram_dat_o),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & upg_adr_o[14]),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    //  Memory Or IO
    MemOrIO memorio(
    .addr_in(ALU_result),
    .mRead(mRead),
    .mWrite(mWrite),
    .IORead(IORead),
    .IOWrite(IOWrite),
    .m_rdata(ram_dat_o),
    .io_rdata(switchrdata),
    .r_rdata(read_data_2),
    .r_wdata(mem_data),
    .write_data(write_data),
    .addr_out(addr_out),
    .LEDCtrl(LEDCtrl),
    .SEGCtrl(SEGCtrl),
    .VGACtrl(VGACtrl),
    .SwitchCtrl(SwitchCtrl)
    );
    
    //  Switch
    switchs switchs_inst(
    .clk(cpu_clk),
    .rst(rst),
    .IORead(IORead),
    .SwitchCtrl(SwitchCtrl),
    .switchaddr(addr_out[1:0]),
    .switchrdata(switchrdata),
    .switch(switch)
    );
    
    //  LED
    leds leds_inst(
    .clk(cpu_clk),
    .rst(rst),
    .IOWrite(IOWrite),
    .LEDCtrl(LEDCtrl),
    .ledaddr(addr_out[1:0]),
    .ledwdata(write_data[15:0]),
    .led(led)
    );
    
    //  SEG
    segs segs_inst(
    .clk(cpu_clk),
    .rst(rst),
    .kickOff(kickOff),
    .IOWrite(IOWrite),
    .SEGCtrl(SEGCtrl),
    .segaddr(addr_out[1:0]),
    .segwdata(write_data[15:0]),
    .an(an),
    .seg0(seg0),
    .seg1(seg1)
    );
    
    //  VGA
    vgas vgas_inst(
    .clk(fpga_clk),
    .rst(rst),
    .kickOff(kickOff),
    .IOWrite(IOWrite),
    .VGACtrl(VGACtrl),
    .vgaaddr(addr_out[1:0]),
    .vgawdata(write_data[15:0]),
    .rgb(rgb),
    .hsync(hsync),
    .vsync(vsync)
    );
    
endmodule
