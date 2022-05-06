onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate -radix hexadecimal /testbench/i
add wave -noupdate -radix hexadecimal /testbench/aouts
add wave -noupdate -radix hexadecimal /testbench/wouts
add wave -noupdate /testbench/mode
add wave -noupdate /testbench/saclk
add wave -noupdate /testbench/data_in
add wave -noupdate /testbench/ARR_CTRL_16x16_0/configs
add wave -noupdate /testbench/ARR_CTRL_16x16_0/wWEN
add wave -noupdate /testbench/ARR_CTRL_16x16_0/wmemQ
add wave -noupdate /testbench/ARR_CTRL_16x16_0/w_addr
add wave -noupdate /testbench/ARR_CTRL_16x16_0/wbufwrites
add wave -noupdate /testbench/ARR_CTRL_16x16_0/prefillcnt
add wave -noupdate /testbench/ARR_CTRL_16x16_0/wbufdout
add wave -noupdate /testbench/ARR_CTRL_16x16_0/aWEN
add wave -noupdate /testbench/ARR_CTRL_16x16_0/amemQ
add wave -noupdate /testbench/ARR_CTRL_16x16_0/a_addr
add wave -noupdate /testbench/ARR_CTRL_16x16_0/abufwrites
add wave -noupdate /testbench/ARR_CTRL_16x16_0/abufdin
add wave -noupdate /testbench/ARR_CTRL_16x16_0/abufdout
add wave -noupdate /testbench/ARR_CTRL_16x16_0/edgecnt
add wave -noupdate /testbench/ARR_CTRL_16x16_0/abufreads

add wave -noupdate /testbench/ARR_CTRL_16x16_0/convcnt
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/base_addr
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/peitcnt
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/lchcnt
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/lrowcnt
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/lcolcnt
add wave -noupdate -radix unsigned /testbench/ARR_CTRL_16x16_0/rowendcnt

add wave -noupdate /testbench/ARR_CTRL_16x16_0/clkdivo
add wave -noupdate /testbench/ARR_CTRL_16x16_0/clkdiven
add wave -noupdate /testbench/ARR_CTRL_16x16_0/clkdiv/clkreg
add wave -noupdate /testbench/fire
add wave -noupdate /testbench/done
add wave -noupdate /testbench/ARR_CTRL_16x16_0/computestart
add wave -noupdate /testbench/ARR_CTRL_16x16_0/computedone
add wave -noupdate /testbench/ARR_CTRL_16x16_0/inpscnt
add wave -noupdate /testbench/ARR_CTRL_16x16_0/windowendwait
add wave -noupdate /testbench/ARR_CTRL_16x16_0/iterationwait

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


