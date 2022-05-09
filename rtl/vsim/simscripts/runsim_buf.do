###########################################
# Modelsim do file for running simulation #
###########################################

vlib work
vmap work work

# Include rtl and testbench
vlog +acc ../ctrl_aux.sv
vlog +acc ../tb/buf_tb.sv

# Start vsim
vsim +acc -t ps -lib work BUF_TB

# Waveformat
onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -radix unsigned /BUF_TB/simCyclesElapsed
add wave /BUF_TB/clk
add wave /BUF_TB/rstn
add wave /BUF_TB/din
add wave /BUF_TB/empty
add wave /BUF_TB/douts

add wave /BUF_TB/DUT1/bufdat
add wave /BUF_TB/DUT1/curhead
add wave /BUF_TB/DUT1/curtail

add wave /BUF_TB/DUT2/bufdat
add wave /BUF_TB/DUT2/curhead
add wave /BUF_TB/DUT2/curtail

add wave /BUF_TB/DUT3/bufdat
add wave /BUF_TB/DUT3/curhead
add wave /BUF_TB/DUT3/curtail

# Run Simulation
run -all

