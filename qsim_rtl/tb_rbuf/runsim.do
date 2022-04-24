##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# include netlist and testbench files
vlog +acc -incr ../../verilog/ctrl/ctrl_aux.v
vlog +acc -incr tb_rbuf.v 

# run simulation 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
