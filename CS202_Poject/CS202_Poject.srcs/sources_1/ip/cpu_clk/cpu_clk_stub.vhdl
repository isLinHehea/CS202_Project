-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Thu May 11 20:52:53 2023
-- Host        : LAPTOP-7DFI8QQJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/LearningMaterials/CS202/Project/CS202_Project/CS202_Poject/CS202_Poject.srcs/sources_1/ip/cpu_clk/cpu_clk_stub.vhdl
-- Design      : cpu_clk
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_clk is
  Port ( 
    cpu_clk : out STD_LOGIC;
    uart_clk : out STD_LOGIC;
    fpga_clk : in STD_LOGIC
  );

end cpu_clk;

architecture stub of cpu_clk is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "cpu_clk,uart_clk,fpga_clk";
begin
end;
