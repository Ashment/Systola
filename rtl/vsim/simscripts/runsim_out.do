###########################################
# Modelsim do file for running simulation #
###########################################

vlib work
vmap work work

# Include rtl and testbench
vlog +acc ../ctrl_aux.sv
vlog +acc ../col_output_ctrl.sv
vlog +acc ../tb/out_tb.sv

# Start vsim
vsim +acc -t ps -lib work OUT_TB

# Waveformat
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave /OUT_TB/clk
add wave /OUT_TB/rstn
add wave /OUT_TB/din
add wave /OUT_TB/in_v
add wave /OUT_TB/read
add wave /OUT_TB/dout
add wave /OUT_TB/rvalid

# Run Simulation
run -all

