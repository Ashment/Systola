onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/CLK
add wave -noupdate /testbench/CEN
add wave -noupdate /testbench/WEN
add wave -noupdate -radix unsigned /testbench/i
add wave -noupdate -radix unsigned /testbench/D
add wave -noupdate -radix unsigned /testbench/A
add wave -noupdate -radix unsigned /testbench/Q
add wave -noupdate -radix unsigned /testbench/read_out_qsim
add wave -noupdate -radix unsigned /testbench/input_qsim
add wave -noupdate -radix unsigned /testbench/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 89
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {12 ns}


