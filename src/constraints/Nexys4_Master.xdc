# This file is derived from the Nexys4 Master XDC file provided at digilentinc.com
# This file is specific to the Nexys4 board, and will not work for other products
# As this is a derivative of the Nexys4 Master XDC, I have left unincluded pins in the file, commented out

# In order to port this code to another board, this file should be replaced with the master XDC file for that board
#  with equivalent pins uncommented as below. It should be noted that different hardware on different boards may 
#  require rewrites of some of the Verilog source, or rerouting of some I/O.
# For instance, the Basys2 has four in-line buttons, instead of the five d-pad buttons that the Nexys4 has.
# In order to port to that board, one of the five buttons would have to be moved to a switch, and the other
#  four would have to somehow be placed in-line in a usable way. It should be noted that the btn_flsm module
#  should work with switch or button inputs, as the debouncer and pulser modules (see btn_flsm for more detail)
#  will work fine with a switch.
# The Basys2 also is only supported by Xilinx ISE, not Vivado, and as such, this file would need to be replaced by a UCF file, 
# ideally an edited version of its Master UCF
# To port to a board with a different base clock speed, the parameters passed to the cc counter module 
#  from the vga module would have to be changed. See the vga file for more detail on how my parameters were selected.

# Clock signal at 100MHz (10ns period)
#Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# This block corresponds to the two RGB leds found on the Nexys4 Board
#Bank = 34, Pin name = IO_L5P_T0_34,						Sch name = LED16_R
set_property PACKAGE_PIN K5 [get_ports RGB1_Red]					
	set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Red]
#Bank = 15, Pin name = IO_L5P_T0_AD9P_15,					Sch name = LED16_G
set_property PACKAGE_PIN F13 [get_ports RGB1_Green]				
	set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Green]
#Bank = 35, Pin name = IO_L19N_T3_VREF_35,					Sch name = LED16_B
set_property PACKAGE_PIN F6 [get_ports RGB1_Blue]					
	set_property IOSTANDARD LVCMOS33 [get_ports RGB1_Blue]
#Bank = 34, Pin name = IO_0_34,								Sch name = LED17_R
#set_property PACKAGE_PIN K6 [get_ports RGB2_Red]					
#	set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Red]
##Bank = 35, Pin name = IO_24P_T3_35,						Sch name =  LED17_G
#set_property PACKAGE_PIN H6 [get_ports RGB2_Green]					
#	set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Green]
##Bank = CONFIG, Pin name = IO_L3N_T0_DQS_EMCCLK_14,			Sch name = LED17_B
#set_property PACKAGE_PIN L16 [get_ports RGB2_Blue]					
#	set_property IOSTANDARD LVCMOS33 [get_ports RGB2_Blue]

#Buttons
#Bank = 15, Pin name = IO_L3P_T0_DQS_AD1P_15,				Sch name = CPU_RESET
set_property PACKAGE_PIN C12 [get_ports btnCpuReset]				
	set_property IOSTANDARD LVCMOS33 [get_ports btnCpuReset]
#Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports btnC]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnC]
#Bank = 15, Pin name = IO_L14P_T2_SRCC_15,					Sch name = BTNU
set_property PACKAGE_PIN F15 [get_ports btnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnU]
#Bank = CONFIG, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,	Sch name = BTNL
set_property PACKAGE_PIN T16 [get_ports btnL]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnL]
#Bank = 14, Pin name = IO_25_14,							Sch name = BTNR
set_property PACKAGE_PIN R10 [get_ports btnR]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnR]
#Bank = 14, Pin name = IO_L21P_T3_DQS_14,					Sch name = BTND
set_property PACKAGE_PIN V10 [get_ports btnD]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnD]
 
#VGA Connector with 12 data pins, horizontal and vertical sync pins
#Bank = 35, Pin name = IO_L8N_T1_AD14N_35,					Sch name = VGA_R0
set_property PACKAGE_PIN A3 [get_ports {vgaR[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[0]}]
#Bank = 35, Pin name = IO_L7N_T1_AD6N_35,					Sch name = VGA_R1
set_property PACKAGE_PIN B4 [get_ports {vgaR[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[1]}]
#Bank = 35, Pin name = IO_L1N_T0_AD4N_35,					Sch name = VGA_R2
set_property PACKAGE_PIN C5 [get_ports {vgaR[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[2]}]
#Bank = 35, Pin name = IO_L8P_T1_AD14P_35,					Sch name = VGA_R3
set_property PACKAGE_PIN A4 [get_ports {vgaR[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaR[3]}]
#Bank = 35, Pin name = IO_L2P_T0_AD12P_35,					Sch name = VGA_B0
set_property PACKAGE_PIN B7 [get_ports {vgaB[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[0]}]
#Bank = 35, Pin name = IO_L4N_T0_35,						Sch name = VGA_B1
set_property PACKAGE_PIN C7 [get_ports {vgaB[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[1]}]
#Bank = 35, Pin name = IO_L6N_T0_VREF_35,					Sch name = VGA_B2
set_property PACKAGE_PIN D7 [get_ports {vgaB[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[2]}]
#Bank = 35, Pin name = IO_L4P_T0_35,						Sch name = VGA_B3
set_property PACKAGE_PIN D8 [get_ports {vgaB[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaB[3]}]
#Bank = 35, Pin name = IO_L1P_T0_AD4P_35,					Sch name = VGA_G0
set_property PACKAGE_PIN C6 [get_ports {vgaG[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[0]}]
#Bank = 35, Pin name = IO_L3N_T0_DQS_AD5N_35,				Sch name = VGA_G1
set_property PACKAGE_PIN A5 [get_ports {vgaG[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[1]}]
#Bank = 35, Pin name = IO_L2N_T0_AD12N_35,					Sch name = VGA_G2
set_property PACKAGE_PIN B6 [get_ports {vgaG[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[2]}]
#Bank = 35, Pin name = IO_L3P_T0_DQS_AD5P_35,				Sch name = VGA_G3
set_property PACKAGE_PIN A6 [get_ports {vgaG[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaG[3]}]
#Bank = 15, Pin name = IO_L4P_T0_15,						Sch name = VGA_HS
set_property PACKAGE_PIN B11 [get_ports HS]						
	set_property IOSTANDARD LVCMOS33 [get_ports HS]
#Bank = 15, Pin name = IO_L3N_T0_DQS_AD1N_15,				Sch name = VGA_VS
set_property PACKAGE_PIN B12 [get_ports VS]						
	set_property IOSTANDARD LVCMOS33 [get_ports VS]
	
	
	
##Pmod Header JA
##Bank = 15, Pin name = IO_L1N_T0_AD0N_15,					Sch name = JA1
set_property PACKAGE_PIN B13 [get_ports {JA[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
##Bank = 15, Pin name = IO_L5N_T0_AD9N_15,					Sch name = JA2
set_property PACKAGE_PIN F14 [get_ports {JA[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
##Bank = 15, Pin name = IO_L16N_T2_A27_15,					Sch name = JA3
set_property PACKAGE_PIN D17 [get_ports {JA[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[2]}]
##Bank = 15, Pin name = IO_L16P_T2_A28_15,					Sch name = JA4
set_property PACKAGE_PIN E17 [get_ports {JA[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Bank = 15, Pin name = IO_0_15,								Sch name = JA7
set_property PACKAGE_PIN G13 [get_ports {JA[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Bank = 15, Pin name = IO_L20N_T3_A19_15,					Sch name = JA8
set_property PACKAGE_PIN C17 [get_ports {JA[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Bank = 15, Pin name = IO_L21N_T3_A17_15,					Sch name = JA9
set_property PACKAGE_PIN D18 [get_ports {JA[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Bank = 15, Pin name = IO_L21P_T3_DQS_15,					Sch name = JA10
set_property PACKAGE_PIN E18 [get_ports {JA[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]

##Pmod Header JB
##Bank = 15, Pin name = IO_L15N_T2_DQS_ADV_B_15,				Sch name = JB1
set_property PACKAGE_PIN G14 [get_ports {JB[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[0]}]
##Bank = 14, Pin name = IO_L13P_T2_MRCC_14,					Sch name = JB2
set_property PACKAGE_PIN P15 [get_ports {JB[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[1]}]
##Bank = 14, Pin name = IO_L21N_T3_DQS_A06_D22_14,			Sch name = JB3
set_property PACKAGE_PIN V11 [get_ports {JB[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[2]}]
##Bank = CONFIG, Pin name = IO_L16P_T2_CSI_B_14,				Sch name = JB4
set_property PACKAGE_PIN V15 [get_ports {JB[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[3]}]
##Bank = 15, Pin name = IO_25_15,							Sch name = JB7
set_property PACKAGE_PIN K16 [get_ports {JB[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Bank = CONFIG, Pin name = IO_L15P_T2_DQS_RWR_B_14,			Sch name = JB8
set_property PACKAGE_PIN R16 [get_ports {JB[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[5]}]
##Bank = 14, Pin name = IO_L24P_T3_A01_D17_14,				Sch name = JB9
set_property PACKAGE_PIN T9 [get_ports {JB[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[6]}]
##Bank = 14, Pin name = IO_L19N_T3_A09_D25_VREF_14,			Sch name = JB10 
set_property PACKAGE_PIN U11 [get_ports {JB[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JB[7]}]
