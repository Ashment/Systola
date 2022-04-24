onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate -radix hexadecimal /testbench/i
add wave -noupdate /testbench/abufwrite
add wave -noupdate /testbench/abufread
add wave -noupdate /testbench/abufdin
add wave -noupdate /testbench/abufdout
add wave -noupdate /testbench/abuf/curhead
add wave -noupdate /testbench/abuf/curtail
add wave -noupdate /testbench/abuf/bufdat




TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
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


