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

# Start vsim
vsim +acc -t ps -lib work SA_CORE_TB
#do waveformat.do

# Waveformat
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -radix unsigned /SA_CORE_TB/simCyclesElapsed
add wave /SA_CORE_TB/clk
add wave /SA_CORE_TB/rstn

add wave /SA_CORE_TB/a_in
add wave /SA_CORE_TB/w_in
add wave /SA_CORE_TB/inpvalid
add wave /SA_CORE_TB/outread
add wave /SA_CORE_TB/resvalid
add wave /SA_CORE_TB/coreout

add wave /SA_CORE_TB/DUT_CORE/arr_w_in
add wave /SA_CORE_TB/DUT_CORE/arr_a_in
add wave /SA_CORE_TB/DUT_CORE/r_outs
add wave /SA_CORE_TB/DUT_CORE/inpvalid
add wave /SA_CORE_TB/DUT_CORE/aemptys
add wave /SA_CORE_TB/DUT_CORE/wemptys
add wave /SA_CORE_TB/DUT_CORE/fire
add wave /SA_CORE_TB/DUT_CORE/start

add wave /SA_CORE_TB/DUT_CORE/sysarr/outs
add wave /SA_CORE_TB/DUT_CORE/sysarr/f_o

# Run Simulation
run -all

