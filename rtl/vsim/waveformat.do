onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SA_CORE_TB/clk
add wave -noupdate /SA_CORE_TB/rstn

add wave -noupdate /SA_CORE_TB/a_in
add wave -noupdate /SA_CORE_TB/w_in
add wave -noupdate /SA_CORE_TB/inpvalid
add wave -noupdate /SA_CORE_TB/outread
add wave -noupdate /SA_CORE_TB/resvalid
add wave -noupdate /SA_CORE_TB/coreout

add wave -noupdate /SA_CORE_TB/DUT_CORE/arr_w_in
add wave -noupdate /SA_CORE_TB/DUT_CORE/arr_a_in
add wave -noupdate /SA_CORE_TB/DUT_CORE/r_outs
add wave -noupdate /SA_CORE_TB/DUT_CORE/inpvalid
add wave -noupdate /SA_CORE_TB/DUT_CORE/fire
add wave -noupdate /SA_CORE_TB/DUT_CORE/start

add wave -noupdate /SA_CORE_TB/DUT_CORE/input_ctrl/ainbuf/bufdat
add wave -noupdate /SA_CORE_TB/DUT_CORE/input_ctrl/winbuf/bufdat

add wave -noupdate /SA_CORE_TB/DUT_CORE/sysarr/outs