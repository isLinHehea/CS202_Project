Part of the code concerning `UART` in `TOP` module:

```verilog
///////////// UART Programmer Pinouts ///////////// 
    wire upg_clk, upg_clk_o;
    wire upg_wen_o; //Uart write out enable
    wire upg_done_o; //Uart iFpgaUartFromPc data have done
    //data to which memory unit of program_rom/dmemory32
    wire [14:0] upg_adr_o;
    //data to program_rom or dmemory32
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(iStartReceiveCoe), .O(spg_bufg)); // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge iFpgaClk) begin
    if (spg_bufg) upg_rst = 0;
    if (iFpgaRst) upg_rst = 1;
    end
    //used for other modules which don't relate to UART
    wire rst;
    assign rst = iFpgaRst | !upg_rst;

    /* if kickOff is 1 means CPU work on normal mode, otherwise CPU work on Uart communication mode */
    wire kickOff = upg_rst | (~upg_rst & upg_done_o );

    uart_bmpg_0 uart_instance(
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(iFpgaUartFromPc),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o)
    );

```

Here are codes related to `UART` in `Dmemory`, `programROM` (`instruction memory`)and `IFetch`:

### `Dmemory`

```verilog
module DataMemory (
    input ram_clk_i, // from CPU top
    input ram_wen_i, // from Controller
    input [13:0] ram_adr_i, // from alu_result of ALU
    input [31:0] ram_dat_i, // from read_data_2 of Decoder
    output [31:0] ram_dat_o, // the data read from data-ram
    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG ram_clk_i (10MHz)
    input upg_wen_i, // UPG write enable
    input [13:0] upg_adr_i, // UPG write address
    input [31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if programming is finished
);
    wire ram_clk = !ram_clk_i;
    /* CPU work on normal mode when kickOff is 1. CPU work on Uart communicate mode when kickOff is 0.*/
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    RAM ram (
        .clka (kickOff ? ram_clk : upg_clk_i),
        .wea (kickOff ? ram_wen_i : upg_wen_i),
        .addra (kickOff ? ram_adr_i : upg_adr_i),
        .dina (kickOff ? ram_dat_i : upg_dat_i),
        .douta (ram_dat_o)
    );

endmodule
```

### `Ifetch`

```verilog
`timescale 1ns / 1ps

module Ifetc32(Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr,PC_plus_4,PC);
    input[31:0] Instruction;           // 根据PC的值从存放指令的prgrom中取出的指令
    output[31:0] branch_base_addr;      // 对于有条件跳转类的指令而言，该值为(pc+4)送往ALU
    input[31:0]  Addr_result;            // 来自ALU,为ALU计算出的跳转地址
    input[31:0]  Read_data_1;           // 来自Decoder，jr指令用的地址
    input        Branch;                // 来自控制单元
    input        nBranch;               // 来自控制单元
    input        Jmp;                   // 来自控制单元
    input        Jal;                   // 来自控制单元
    input        Jr;                    // 来自控制单元
    input        Zero;                  //来自ALU，Zero为1表示两个值相等，反之表示不相等
    input        clock,reset;           //时钟与复位,复位信号用于给PC赋初始值，复位信号高电平有效
    output reg [31:0] link_addr = 0;        // JAL指令专用的PC+4
    output [31:0] PC_plus_4;             // PC + 4;
    output reg [31:0] PC = 32'b0;
    
    reg [31:0] Next_PC = 32'b0;
    assign PC_plus_4 = PC + 4;
    wire [25:0]address = Instruction[25:0];
    assign branch_base_addr = PC + 4;

    // 组合逻辑，只要ALU、寄存器算完，就设置 dNextProgramCounter
    always @* begin
        if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result; //ALU计算出的跳转地址
        else if(Jr == 1)
            Next_PC = Read_data_1; // the value of $31 register
        else 
            Next_PC = PC_plus_4; // PC+4
    end

    always @(negedge clock or posedge reset) begin
        if(reset == 1)
            PC <= 32'b0;
        else if((Jmp == 1) || (Jal == 1)) 
            PC <= {PC[31:28], address, 2'b00}; 
        else
            PC <= Next_PC;
    end

    always @(negedge clock or posedge reset) begin
        if(reset) link_addr <= 0;
        else if((Jal == 1)) 
            link_addr <= PC_plus_4; // PC+4 for jal
    end


endmodule
```

### `programROM` (`instruction memory`)

```verilog
`timescale 1ns / 1ps


module programrom ( 
// Program ROM Pinouts 
input rom_clk_i, // ROM clock 
input [13:0] rom_adr_i, // From IFetch 
output [31:0] Instruction_o, // To IFetch 
// UART Programmer Pinouts 
input upg_rst_i, // UPG reset (Active High) 
input upg_clk_i, // UPG clock (10MHz) 
input upg_wen_i, // UPG write enable 
input[13:0] upg_adr_i, // UPG write address 
input[31:0] upg_dat_i, // UPG write data 
input upg_done_i // 1 if program finished 
);

wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i ); 
prgrom instmem ( 
.clka (kickOff ? rom_clk_i : upg_clk_i ), 
.wea (kickOff ? 1'b0 : upg_wen_i ), 
.addra (kickOff ? rom_adr_i : upg_adr_i ), 
.dina (kickOff ? 32'h00000000 : upg_dat_i ), 
.douta (Instruction_o) ); 
endmodule
```
