###########################################
# Modelsim do file for running simulation #
###########################################

vlib work
vmap work work

# Include rtl and testbench
vlog +acc ../pe.sv
vlog +acc ../pe_arr.sv
vlog +acc ../sa_core.sv
vlog +acc ../col_output_ctrl.sv
vlog +acc ../core_input_ctrl.sv
vlog +acc ../ctrl_aux.sv
vlog +acc ../tb/sa_core_tb.sv

# Run simulator
vsim +acc -t ps -lib work SA_CORE_TB
do waveformat.do
run -all

