##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ../../rtl/pe.sv
vlog +acc -incr ./pe_tb.sv 

# Run Simulator 
vsim +acc -t ps -lib work PE_TB
do waveformat.do
run -all
