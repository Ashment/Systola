##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ../../rtl/mem_out/mem_out.v 
vlog +acc -incr ../../rtl/mem_out/mem32.v 
vlog +acc -incr test_mem_out.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
