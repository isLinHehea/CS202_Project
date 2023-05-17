// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module cpu_clk(cpu_clk, upg_clk, fpga_clk);
  output cpu_clk;
  output upg_clk;
  input fpga_clk;
endmodule
