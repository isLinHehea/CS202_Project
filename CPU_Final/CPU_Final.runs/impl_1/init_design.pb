
o
Command: %s
53*	vivadotcl2>
*link_design -top cpu -part xc7a35tcsg324-12default:defaultZ4-113h px� 
g
#Design is defaulting to srcset: %s
437*	planAhead2
	sources_12default:defaultZ12-437h px� 
j
&Design is defaulting to constrset: %s
434*	planAhead2
	constrs_12default:defaultZ12-434h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2~
jd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.dcp2default:default2 
cpu_clk_inst2default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2�
rd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg_0.dcp2default:default2
	uart_inst2default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2v
bd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/ROM/ROM.dcp2default:default2'
ProgramROM_inst/rom2default:defaultZ1-454h px� 
�
-Reading design checkpoint '%s' for cell '%s'
275*project2v
bd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/RAM/RAM.dcp2default:default2$
dmemory/RAM_inst2default:defaultZ1-454h px� 
g
-Analyzing %s Unisim elements for replacement
17*netlist2
6062default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
x
Netlist was created with %s %s291*project2
Vivado2default:default2
2017.42default:defaultZ1-479h px� 
V
Loading part %s157*device2#
xc7a35tcsg324-12default:defaultZ21-403h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
�
LRemoving redundant IBUF, %s, from the path connected to top-level port: %s 
35*opt22
cpu_clk_inst/inst/clkin1_ibufg2default:default2
fpga_clk2default:defaultZ31-35h px� 
�
NRemoving redundant IBUF since it is not being driven by a top-level port. %s 
32*opt2?
+uart_inst/inst/upg_inst/upg_clk_i_IBUF_inst2default:defaultZ31-32h px� 
�
NRemoving redundant IBUF since it is not being driven by a top-level port. %s 
32*opt2?
+uart_inst/inst/upg_inst/upg_rst_i_IBUF_inst2default:defaultZ31-32h px� 
�
LRemoving redundant IBUF, %s, from the path connected to top-level port: %s 
35*opt2>
*uart_inst/inst/upg_inst/upg_rx_i_IBUF_inst2default:default2
rx2default:defaultZ31-35h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[0]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_adr_o_OBUF[10]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_adr_o_OBUF[11]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_adr_o_OBUF[12]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_adr_o_OBUF[13]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_adr_o_OBUF[14]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[1]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[2]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[3]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[4]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[5]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[6]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[7]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[8]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_adr_o_OBUF[9]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2?
+uart_inst/inst/upg_inst/upg_clk_o_OBUF_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[0]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[10]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[11]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[12]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[13]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[14]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[15]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[16]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[17]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[18]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[19]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[1]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[20]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[21]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[22]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[23]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[24]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[25]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[26]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[27]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[28]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[29]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[2]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[30]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2C
/uart_inst/inst/upg_inst/upg_dat_o_OBUF[31]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[3]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[4]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[5]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[6]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[7]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[8]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2B
.uart_inst/inst/upg_inst/upg_dat_o_OBUF[9]_inst2default:defaultZ31-33h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2@
,uart_inst/inst/upg_inst/upg_done_o_OBUF_inst2default:defaultZ31-33h px� 
�
LRemoving redundant OBUF, %s, from the path connected to top-level port: %s 
36*opt2 
tx_OBUF_inst2default:default2
tx2default:defaultZ31-36h px� 
�
FRemoving redundant OBUF since it is not driving a top-level port. %s 
33*opt2?
+uart_inst/inst/upg_inst/upg_wen_o_OBUF_inst2default:defaultZ31-33h px� 
�
�Could not create '%s' constraint because net '%s' is not directly connected to top level port. '%s' is ignored by %s but preserved for implementation tool.
528*constraints2 
IBUF_LOW_PWR2default:default2+
cpu_clk_inst/fpga_clk2default:default2 
IBUF_LOW_PWR2default:default2
Vivado2default:default2�
�D:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.runs/impl_1/.Xil/Vivado-2672-LAPTOP-7DFI8QQJ/dcp3/cpu_clk.edf2default:default2
2692default:default8@Z18-550h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
pd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk_board.xdc2default:default2'
cpu_clk_inst/inst	2default:default8Z20-848h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
pd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk_board.xdc2default:default2'
cpu_clk_inst/inst	2default:default8Z20-847h px� 
�
$Parsing XDC File [%s] for cell '%s'
848*designutils2�
jd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2'
cpu_clk_inst/inst	2default:default8Z20-848h px� 
�
%Done setting XDC timing constraints.
35*timing2�
jd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2
572default:default8@Z38-35h px� 
�
Deriving generated clocks
2*timing2�
jd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2
572default:default8@Z38-2h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2 
get_clocks: 2default:default2
00:00:082default:default2
00:00:102default:default2
1143.4842default:default2
565.0862default:defaultZ17-268h px� 
�
-Finished Parsing XDC File [%s] for cell '%s'
847*designutils2�
jd:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/sources_1/ip/cpu_clk/cpu_clk.xdc2default:default2'
cpu_clk_inst/inst	2default:default8Z20-847h px� 
�
Parsing XDC File [%s]
179*designutils2u
_D:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/constrs_1/new/cpu.xdc2default:default8Z20-179h px� 
�
Finished Parsing XDC File [%s]
178*designutils2u
_D:/LearningMaterials/CS202/Project/CS202_Project/CPU_Final/CPU_Final.srcs/constrs_1/new/cpu.xdc2default:default8Z20-178h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
132default:default2
562default:default2
02default:default2
02default:defaultZ4-41h px� 
]
%s completed successfully
29*	vivadotcl2
link_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2!
link_design: 2default:default2
00:00:152default:default2
00:00:182default:default2
1143.6332default:default2
911.8832default:defaultZ17-268h px� 


End Record