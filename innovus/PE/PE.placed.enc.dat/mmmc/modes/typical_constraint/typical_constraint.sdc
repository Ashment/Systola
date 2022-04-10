###############################################################
#  Generated by:      Cadence Innovus 19.10-p002_1
#  OS:                Linux x86_64(Host ID cadpc15)
#  Generated on:      Sat Apr  9 14:46:22 2022
#  Design:            PE
#  Command:           saveDesign PE.placed.enc
###############################################################
current_design PE
create_clock [get_ports {clk}]  -name clk -period 4.000000 -waveform {0.000000 2.000000}
set_clock_transition  -rise -min 0.01 [get_clocks {clk}]
set_clock_transition  -rise -max 0.01 [get_clocks {clk}]
set_clock_transition  -fall -min 0.01 [get_clocks {clk}]
set_clock_transition  -fall -max 0.01 [get_clocks {clk}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {clk}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {clk}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {clk}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {clk}]
set_max_capacitance 0.005  [get_ports {clk}]
set_max_fanout 4  [get_ports {clk}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {rst_n}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {rst_n}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {rst_n}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {rst_n}]
set_max_capacitance 0.005  [get_ports {rst_n}]
set_max_fanout 4  [get_ports {rst_n}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {fire_in}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {fire_in}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {fire_in}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {fire_in}]
set_max_capacitance 0.005  [get_ports {fire_in}]
set_max_fanout 4  [get_ports {fire_in}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[7]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[7]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[7]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[7]}]
set_max_capacitance 0.005  [get_ports {weight_in[7]}]
set_max_fanout 4  [get_ports {weight_in[7]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[6]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[6]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[6]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[6]}]
set_max_capacitance 0.005  [get_ports {weight_in[6]}]
set_max_fanout 4  [get_ports {weight_in[6]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[5]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[5]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[5]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[5]}]
set_max_capacitance 0.005  [get_ports {weight_in[5]}]
set_max_fanout 4  [get_ports {weight_in[5]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[4]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[4]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[4]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[4]}]
set_max_capacitance 0.005  [get_ports {weight_in[4]}]
set_max_fanout 4  [get_ports {weight_in[4]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[3]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[3]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[3]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[3]}]
set_max_capacitance 0.005  [get_ports {weight_in[3]}]
set_max_fanout 4  [get_ports {weight_in[3]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[2]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[2]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[2]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[2]}]
set_max_capacitance 0.005  [get_ports {weight_in[2]}]
set_max_fanout 4  [get_ports {weight_in[2]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[1]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[1]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[1]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[1]}]
set_max_capacitance 0.005  [get_ports {weight_in[1]}]
set_max_fanout 4  [get_ports {weight_in[1]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {weight_in[0]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {weight_in[0]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {weight_in[0]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {weight_in[0]}]
set_max_capacitance 0.005  [get_ports {weight_in[0]}]
set_max_fanout 4  [get_ports {weight_in[0]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[7]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[7]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[7]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[7]}]
set_max_capacitance 0.005  [get_ports {data_in[7]}]
set_max_fanout 4  [get_ports {data_in[7]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[6]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[6]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[6]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[6]}]
set_max_capacitance 0.005  [get_ports {data_in[6]}]
set_max_fanout 4  [get_ports {data_in[6]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[5]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[5]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[5]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[5]}]
set_max_capacitance 0.005  [get_ports {data_in[5]}]
set_max_fanout 4  [get_ports {data_in[5]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[4]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[4]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[4]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[4]}]
set_max_capacitance 0.005  [get_ports {data_in[4]}]
set_max_fanout 4  [get_ports {data_in[4]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[3]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[3]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[3]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[3]}]
set_max_capacitance 0.005  [get_ports {data_in[3]}]
set_max_fanout 4  [get_ports {data_in[3]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[2]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[2]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[2]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[2]}]
set_max_capacitance 0.005  [get_ports {data_in[2]}]
set_max_fanout 4  [get_ports {data_in[2]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[1]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[1]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[1]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[1]}]
set_max_capacitance 0.005  [get_ports {data_in[1]}]
set_max_fanout 4  [get_ports {data_in[1]}]
set_driving_cell -lib_cell INVX1TS -rise -min [get_ports {data_in[0]}]
set_driving_cell -lib_cell INVX1TS -fall -min [get_ports {data_in[0]}]
set_driving_cell -lib_cell INVX1TS -rise -max [get_ports {data_in[0]}]
set_driving_cell -lib_cell INVX1TS -fall -max [get_ports {data_in[0]}]
set_max_capacitance 0.005  [get_ports {data_in[0]}]
set_max_fanout 4  [get_ports {data_in[0]}]
set_load -pin_load -max  0.005  [get_ports {fire_out}]
set_load -pin_load -min  0.005  [get_ports {fire_out}]
set_load -pin_load -max  0.005  [get_ports {weight_out[7]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[7]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[6]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[6]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[5]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[5]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[4]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[4]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[3]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[3]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[2]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[2]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[1]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[1]}]
set_load -pin_load -max  0.005  [get_ports {weight_out[0]}]
set_load -pin_load -min  0.005  [get_ports {weight_out[0]}]
set_load -pin_load -max  0.005  [get_ports {data_out[7]}]
set_load -pin_load -min  0.005  [get_ports {data_out[7]}]
set_load -pin_load -max  0.005  [get_ports {data_out[6]}]
set_load -pin_load -min  0.005  [get_ports {data_out[6]}]
set_load -pin_load -max  0.005  [get_ports {data_out[5]}]
set_load -pin_load -min  0.005  [get_ports {data_out[5]}]
set_load -pin_load -max  0.005  [get_ports {data_out[4]}]
set_load -pin_load -min  0.005  [get_ports {data_out[4]}]
set_load -pin_load -max  0.005  [get_ports {data_out[3]}]
set_load -pin_load -min  0.005  [get_ports {data_out[3]}]
set_load -pin_load -max  0.005  [get_ports {data_out[2]}]
set_load -pin_load -min  0.005  [get_ports {data_out[2]}]
set_load -pin_load -max  0.005  [get_ports {data_out[1]}]
set_load -pin_load -min  0.005  [get_ports {data_out[1]}]
set_load -pin_load -max  0.005  [get_ports {data_out[0]}]
set_load -pin_load -min  0.005  [get_ports {data_out[0]}]
set_load -pin_load -max  0.005  [get_ports {result[31]}]
set_load -pin_load -min  0.005  [get_ports {result[31]}]
set_load -pin_load -max  0.005  [get_ports {result[30]}]
set_load -pin_load -min  0.005  [get_ports {result[30]}]
set_load -pin_load -max  0.005  [get_ports {result[29]}]
set_load -pin_load -min  0.005  [get_ports {result[29]}]
set_load -pin_load -max  0.005  [get_ports {result[28]}]
set_load -pin_load -min  0.005  [get_ports {result[28]}]
set_load -pin_load -max  0.005  [get_ports {result[27]}]
set_load -pin_load -min  0.005  [get_ports {result[27]}]
set_load -pin_load -max  0.005  [get_ports {result[26]}]
set_load -pin_load -min  0.005  [get_ports {result[26]}]
set_load -pin_load -max  0.005  [get_ports {result[25]}]
set_load -pin_load -min  0.005  [get_ports {result[25]}]
set_load -pin_load -max  0.005  [get_ports {result[24]}]
set_load -pin_load -min  0.005  [get_ports {result[24]}]
set_load -pin_load -max  0.005  [get_ports {result[23]}]
set_load -pin_load -min  0.005  [get_ports {result[23]}]
set_load -pin_load -max  0.005  [get_ports {result[22]}]
set_load -pin_load -min  0.005  [get_ports {result[22]}]
set_load -pin_load -max  0.005  [get_ports {result[21]}]
set_load -pin_load -min  0.005  [get_ports {result[21]}]
set_load -pin_load -max  0.005  [get_ports {result[20]}]
set_load -pin_load -min  0.005  [get_ports {result[20]}]
set_load -pin_load -max  0.005  [get_ports {result[19]}]
set_load -pin_load -min  0.005  [get_ports {result[19]}]
set_load -pin_load -max  0.005  [get_ports {result[18]}]
set_load -pin_load -min  0.005  [get_ports {result[18]}]
set_load -pin_load -max  0.005  [get_ports {result[17]}]
set_load -pin_load -min  0.005  [get_ports {result[17]}]
set_load -pin_load -max  0.005  [get_ports {result[16]}]
set_load -pin_load -min  0.005  [get_ports {result[16]}]
set_load -pin_load -max  0.005  [get_ports {result[15]}]
set_load -pin_load -min  0.005  [get_ports {result[15]}]
set_load -pin_load -max  0.005  [get_ports {result[14]}]
set_load -pin_load -min  0.005  [get_ports {result[14]}]
set_load -pin_load -max  0.005  [get_ports {result[13]}]
set_load -pin_load -min  0.005  [get_ports {result[13]}]
set_load -pin_load -max  0.005  [get_ports {result[12]}]
set_load -pin_load -min  0.005  [get_ports {result[12]}]
set_load -pin_load -max  0.005  [get_ports {result[11]}]
set_load -pin_load -min  0.005  [get_ports {result[11]}]
set_load -pin_load -max  0.005  [get_ports {result[10]}]
set_load -pin_load -min  0.005  [get_ports {result[10]}]
set_load -pin_load -max  0.005  [get_ports {result[9]}]
set_load -pin_load -min  0.005  [get_ports {result[9]}]
set_load -pin_load -max  0.005  [get_ports {result[8]}]
set_load -pin_load -min  0.005  [get_ports {result[8]}]
set_load -pin_load -max  0.005  [get_ports {result[7]}]
set_load -pin_load -min  0.005  [get_ports {result[7]}]
set_load -pin_load -max  0.005  [get_ports {result[6]}]
set_load -pin_load -min  0.005  [get_ports {result[6]}]
set_load -pin_load -max  0.005  [get_ports {result[5]}]
set_load -pin_load -min  0.005  [get_ports {result[5]}]
set_load -pin_load -max  0.005  [get_ports {result[4]}]
set_load -pin_load -min  0.005  [get_ports {result[4]}]
set_load -pin_load -max  0.005  [get_ports {result[3]}]
set_load -pin_load -min  0.005  [get_ports {result[3]}]
set_load -pin_load -max  0.005  [get_ports {result[2]}]
set_load -pin_load -min  0.005  [get_ports {result[2]}]
set_load -pin_load -max  0.005  [get_ports {result[1]}]
set_load -pin_load -min  0.005  [get_ports {result[1]}]
set_load -pin_load -max  0.005  [get_ports {result[0]}]
set_load -pin_load -min  0.005  [get_ports {result[0]}]
set_max_fanout 4  [get_designs {PE}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[4]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[2]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {rst_n}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[0]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[6]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[4]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[2]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[0]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[7]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[5]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[3]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[1]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[7]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[5]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[3]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {fire_in}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_in[1]}]
set_input_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_in[6]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[0]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[11]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[7]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[9]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[3]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[4]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[27]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[5]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[0]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[30]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[23]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[16]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[1]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[12]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[4]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[5]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[28]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[6]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[0]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[1]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[31]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[24]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[17]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[2]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[20]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[13]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[29]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[5]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[6]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[7]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[1]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[2]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[25]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[18]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[3]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[21]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[14]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[10]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[6]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[7]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {fire_out}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[8]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {data_out[2]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {weight_out[3]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[26]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[19]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[4]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[22]}]
set_output_delay -add_delay 0.1 -clock [get_clocks {clk}] [get_ports {result[15]}]
set_clock_uncertainty 0.01 [get_clocks {clk}]
set_ideal_network  [get_ports {clk}]
