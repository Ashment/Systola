pe: 
	iverilog -g2012 -o pe.vvp pe.sv

test_pe:
	iverilog -g2012 -o pe_tb.vvp pe.sv pe_tb.sv; vvp pe_tb.vvp

pe_lin:
	iverilog -g2012 -o pe.vvp pe.sv pe_lin.sv

test_pe_lin:
	iverilog -g2012 -o pe_lin_tb.vvp pe.sv pe_lin.sv pe_lin_tb.sv; vvp pe_lin_tb.vvp

lin_gen:
	iverilog -g2012 -o lin_gen.vvp pe_lin_gen.sv pe.sv

test_lin_gen:
	iverilog -g2012 -o lin_gen_tb.vvp lin_gen_tb.sv pe_lin_gen.sv pe.sv; vvp lin_gen_tb.vvp -vcd

arr:
	iverilog -g2012 -o arr.vvp pe.sv pe_arr.sv

clean:
	rm -f *.vvp; rm -f *.vcd
