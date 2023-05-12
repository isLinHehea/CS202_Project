// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri May 12 11:09:31 2023
// Host        : LAPTOP-7DFI8QQJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top cpu_clk -prefix
//               cpu_clk_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module cpu_clk(cpu_clk, upg_clk, fpga_clk)
/* synthesis syn_black_box black_box_pad_pin="cpu_clk,upg_clk,fpga_clk" */;
  output cpu_clk;
  output upg_clk;
  input fpga_clk;
endmodule
