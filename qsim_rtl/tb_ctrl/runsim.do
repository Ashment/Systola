##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# include netlist and testbench files
vlog +acc -incr ../../verilog/ctrl/ctrl_aux.v
vlog +acc -incr ../../verilog/mem/mem8.v
vlog +acc -incr ../../verilog/mem/inpmem.v
vlog +acc -incr ../../verilog/ctrl/arr_controller.v  
vlog +acc -incr tb_ctrl.v 

# run simulation 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
