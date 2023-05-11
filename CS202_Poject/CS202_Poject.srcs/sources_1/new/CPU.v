`timescale 1ns / 1ps

module CPU(input fpga_rst,  //Active High  S2
           input fpga_clk,
           input start_pg,  //Active High  S3
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
    .uart_clk(upg_clk)
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
    
endmodule
