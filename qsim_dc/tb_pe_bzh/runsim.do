##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# include netlist and testbench files
vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
vlog +acc -incr ../../dc/pe_bzh/PE.nl.v 
vlog +acc -incr pe_tb.v 

# run simulation 
vsim -t ps -lib work PE_TB
do waveformat.do   
run -all
