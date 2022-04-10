##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ../../verilog/pe.v
vlog +acc -incr ../../verilog/pe_arr.v
vlog +acc -incr ./pe_arr_test.v 

# Run Simulator 
vsim +acc -t ps -lib work pe_arr_test
do waveformat.do
run -all
