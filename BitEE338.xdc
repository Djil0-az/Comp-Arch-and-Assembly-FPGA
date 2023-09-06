
# Clock signal
#Bank = 34, Pin name = ,					Sch name = CLK100MHZ
set_property PACKAGE_PIN T5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

#reset
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN p15 [get_ports rst_n] 
#p15

#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_pin]

# Switches
#wwset_property PACKAGE_PIN R1 [get_ports lb_sel_pin]
#wwset_property IOSTANDARD LVCMOS33 [get_ports lb_sel_pin]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
#set_property PACKAGE_PIN P5 [get_ports {sw[0]}]
#set_property PACKAGE_PIN P4 [get_ports {sw[1]}]
#set_property PACKAGE_PIN P3 [get_ports {sw[2]}]
#set_property PACKAGE_PIN P2 [get_ports {sw[3]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[4]}]
#set_property PACKAGE_PIN M4 [get_ports {sw[5]}]
#set_property PACKAGE_PIN N4 [get_ports {sw[6]}]
#set_property PACKAGE_PIN R1 [get_ports {sw[7]}]

#Buttons
#Bank = 14, Pin name = ,					Sch name = BTNC
#set_property PACKAGE_PIN U4 [get_ports rst_pin]
#set_property IOSTANDARD LVCMOS33 [get_ports rst_pin]

# LEDs
#set_property PACKAGE_PIN F6 [get_ports {led[7]}]
#set_property PACKAGE_PIN G4 [get_ports {led[6]}]
#set_property PACKAGE_PIN G3 [get_ports {led[5]}]
#set_property PACKAGE_PIN J4 [get_ports {led[4]}]
#set_property PACKAGE_PIN H4 [get_ports {led[3]}]
#set_property PACKAGE_PIN J3 [get_ports {led[2]}]
#set_property PACKAGE_PIN J2 [get_ports {led[1]}]
#set_property PACKAGE_PIN K2 [get_ports {led[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

##USB-RS232 Interface
##Bank = 16, Pin name = ,					Sch name = UART_TXD_IN
#set_property PACKAGE_PIN L3 [get_ports rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports rxd]
##Bank = 16, Pin name = ,					Sch name = UART_RXD_OUT
#set_property PACKAGE_PIN N2 [get_ports txd]
#set_property IOSTANDARD LVCMOS33 [get_ports txd]
# BT
#set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports bt_pw_on]
#set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports bt_master_slave]
#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports bt_sw_hw]
#set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports bt_rst_n]
#set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports bt_sw]

##7 segment display
#set_property PACKAGE_PIN B4 [get_ports {seg7_1_7bit[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[0]}]
#set_property PACKAGE_PIN A4 [get_ports {seg7_1_7bit[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[1]}]
#set_property PACKAGE_PIN A3 [get_ports {seg7_1_7bit[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[2]}]
#set_property PACKAGE_PIN B1 [get_ports {seg7_1_7bit[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[3]}]
#set_property PACKAGE_PIN A1 [get_ports {seg7_1_7bit[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[4]}]
#set_property PACKAGE_PIN B3 [get_ports {seg7_1_7bit[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[5]}]
#set_property PACKAGE_PIN B2 [get_ports {seg7_1_7bit[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_7bit[6]}]
#set_property PACKAGE_PIN D5 [get_ports seg7_1_dp]
#set_property IOSTANDARD LVCMOS33 [get_ports seg7_1_dp]

#set_property PACKAGE_PIN G2 [get_ports {seg7_1_an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_an[0]}]
#set_property PACKAGE_PIN C2 [get_ports {seg7_1_an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_an[1]}]
#set_property PACKAGE_PIN C1 [get_ports {seg7_1_an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_an[2]}]
#set_property PACKAGE_PIN H1 [get_ports {seg7_1_an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_1_an[3]}]

#set_property PACKAGE_PIN D4 [get_ports {seg7_0_7bit[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[0]}]
#set_property PACKAGE_PIN E3 [get_ports {seg7_0_7bit[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[1]}]
#set_property PACKAGE_PIN D3 [get_ports {seg7_0_7bit[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[2]}]
#set_property PACKAGE_PIN F4 [get_ports {seg7_0_7bit[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[3]}]
#set_property PACKAGE_PIN F3 [get_ports {seg7_0_7bit[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[4]}]
#set_property PACKAGE_PIN E2 [get_ports {seg7_0_7bit[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[5]}]
#set_property PACKAGE_PIN D2 [get_ports {seg7_0_7bit[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_7bit[6]}]

#set_property PACKAGE_PIN H2 [get_ports seg7_0_dp]
#set_property IOSTANDARD LVCMOS33 [get_ports seg7_0_dp]

#set_property PACKAGE_PIN G1 [get_ports {seg7_0_an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_an[0]}]
#set_property PACKAGE_PIN F1 [get_ports {seg7_0_an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_an[1]}]
#set_property PACKAGE_PIN E1 [get_ports {seg7_0_an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_an[2]}]
#set_property PACKAGE_PIN G6 [get_ports {seg7_0_an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg7_0_an[3]}]

#set_property IOB TRUE [all_fanin -only_cells -startpoints_only -flat [all_outputs]]
#vga
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN F5 [get_ports {r[0]}]
set_property PACKAGE_PIN C6 [get_ports {r[1]}]
set_property PACKAGE_PIN C5 [get_ports {r[2]}]
set_property PACKAGE_PIN B7 [get_ports {r[3]}]
set_property PACKAGE_PIN B6 [get_ports {g[0]}]
set_property PACKAGE_PIN A6 [get_ports {g[1]}]
set_property PACKAGE_PIN A5 [get_ports {g[2]}]
set_property PACKAGE_PIN D8 [get_ports {g[3]}]
set_property PACKAGE_PIN C7 [get_ports {b[0]}]
set_property PACKAGE_PIN E6 [get_ports {b[1]}]
set_property PACKAGE_PIN E5 [get_ports {b[2]}]
set_property PACKAGE_PIN E7 [get_ports {b[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
set_property PACKAGE_PIN D7 [get_ports hsync]
set_property PACKAGE_PIN C4 [get_ports vsync]


####{lcd
#set_property IOSTANDARD LVCMOS33 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports cs]
#set_property IOSTANDARD LVCMOS33 [get_ports reset]
#set_property IOSTANDARD LVCMOS33 [get_ports rs]
#set_property IOSTANDARD LVCMOS33 [get_ports sck]
#set_property IOSTANDARD LVCMOS33 [get_ports sdi]
#set_property PACKAGE_PIN T5 [get_ports clk]
#set_property PACKAGE_PIN V6 [get_ports sck]
#set_property PACKAGE_PIN U9 [get_ports sdi]
#set_property PACKAGE_PIN T6 [get_ports rs]
#set_property PACKAGE_PIN R7 [get_ports reset]
#set_property PACKAGE_PIN U6 [get_ports cs]







#set_property IOSTANDARD LVCMOS33 [get_ports key_l]
#set_property IOSTANDARD LVCMOS33 [get_ports key_r]
#set_property PACKAGE_PIN V1 [get_ports key_l]
#set_property PACKAGE_PIN R11 [get_ports key_r]

#set_property IOSTANDARD LVCMOS33 [get_ports key_d]
#set_property IOSTANDARD LVCMOS33 [get_ports key_u]
#set_property PACKAGE_PIN R17 [get_ports key_u]
#set_property PACKAGE_PIN U4 [get_ports key_d]

#set_property IOSTANDARD LVCMOS33 [get_ports key_c]
#set_property PACKAGE_PIN R15 [get_ports key_c]

##ext io
set_property PACKAGE_PIN B11 [get_ports {EXT_IO[0]}]
set_property PACKAGE_PIN E15 [get_ports {EXT_IO[1]}]
set_property PACKAGE_PIN D15 [get_ports {EXT_IO[2]}]
set_property PACKAGE_PIN H16 [get_ports {EXT_IO[3]}]
set_property PACKAGE_PIN F15 [get_ports {EXT_IO[4]}]
set_property PACKAGE_PIN H14 [get_ports {EXT_IO[5]}]
set_property PACKAGE_PIN E17 [get_ports {EXT_IO[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {EXT_IO[0]}]

######}

##buzzer
#set_property PACKAGE_PIN G13 [get_ports buzzer]
#set_property IOSTANDARD LVCMOS33 [get_ports {buzzer}]