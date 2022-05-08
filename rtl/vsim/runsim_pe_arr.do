###########################################
# Modelsim do file for running simulation #
###########################################

vlib work
vmap work work

# Include rtl and testbench
vlog +acc ../pe.sv
vlog +acc ../pe_arr.sv
vlog +acc ../tb/pe_arr_tb.sv

# Start vsim
vsim +acc -t ps -lib work pe_arr_tb
#do waveformat.do

# Waveformat
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pe_arr_tb/clk
add wave -noupdate /pe_arr_tb/rstn
add wave -noupdate /pe_arr_tb/in_w
add wave -noupdate /pe_arr_tb/in_a
add wave -noupdate /pe_arr_tb/outs
add wave -nodupate /pe_arr_tb/outvalids

# Run Simulation
run -all

