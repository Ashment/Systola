###########################################
# Modelsim do file for running simulation #
###########################################

vlib work
vmap work work

# Include rtl and testbench
vlog +acc ../ctrl_aux.sv
vlog +acc ../core_input_ctrl.sv
vlog +acc ../tb/inpc_tb.sv

# Start vsim
vsim +acc -t ps -lib work BUF_TB

# Waveformat
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -radix unsigned /BUF_TB/simCyclesElapsed
add wave /INP_TB/clk
add wave /INP_TB/rstn
add wave /INP_TB/read
add wave /INP_TB/write
add wave /INP_TB/ain
add wave /INP_TB/win
add wave /INP_TB/aemptys
add wave /INP_TB/wemptys
add wave /INP_TB/as
add wave /INP_TB/ws

# Run Simulation
run -all

