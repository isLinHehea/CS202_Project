set_property SRC_FILE_INFO {cfile:d:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc rfile:../../../CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports fpga_clk]] 0.1
