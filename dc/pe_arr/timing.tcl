# TCL script of timing setup for synthesis

# Time unit: 1ns (in the IBM power-delivery library)
# Capacitance unit: 1pF (in the IBM power-delivery library)

##################################################
# Define the clock timing
################################################## 

# Variables for clock
set clk_period 5
set clk_uncertainty 0.01
set clk_transition 0.01

set clk_name "clk"
set clk_port "clk"

# Create a clock if clock port is found
if {[sizeof_collection [get_ports $clk_port]] > 0} {

    # Create a clock object and define its waveform in the current design
    # Note: source_objects are the pin or port where the clock waveform is applied to the design
    #       If no waveform is specified, 50% duty cycle is assumed
    create_clock $clk_port -name $clk_name -period $clk_period

    # Set the rise_drive or fall_drive attributes to the specified resistance values on the specified input and inout ports
    # Note: For heavily loaded driving ports, such as clock lines, keep the drive strength seeeting 0 so that DC does not buffer the net
    set_drive 0 [get_clocks $clk_name] 
}

# Create virtual clock if clock port is not found
if {[sizeof_collection [get_ports $clk_port]] == 0} {

    # Create a clock object and define its waveform in the current design
    # Note: source_objects are the pin or port where the clock waveform is applied to the design
    #       If no waveform is specified, 50% duty cycle is assumed
    set clk_name vclk
    create_clock -period $clk_period -name vclk

    # Set the rise_drive or fall_drive attributes to the specified resistance values on the specified input and inour ports
    # Note: For heavily loaded driving ports, such as clock lines, keep the drive strength seeeting 0 so that DC does not buffer the net
    set_drive 0 [get_clocks $clk_name] 
}

# Set clock uncertainty (skew)
# Note: This command considers different clock arrival time to FFs
set_clock_uncertainty $clk_uncertainty [get_clocks $clk_name]

# Set the transition time at the clock pins of all sequential devices clocked by the specified ideal clocks
set_clock_transition $clk_transition [get_clocks $clk_name]

# Fix hold violations at registers during compilation
# Note: If fix_hold or min_delay is specified, the minimum delay is a secondary optimization cost
#       DC inserts more buffers to solve the hold violations
set_fix_hold [all_clocks]

# Prevent cells and nets from being modified or replaced during optimization
# Note: Placing a dont_touch_network on a clock object prevents the toll from buffering the clock network
#       If dont_touch_network is set, DC reports violations (e.g. fanout) but does not modify the network during optimization
set_dont_touch_network $clk_port

# Mark ports and pins as sources of ideal networks
# Note: This command disables the timing update and optimization of cells and nets in the fanout of the specified objects
set_ideal_network      $clk_port


##################################################
# Define the input and output ports' timing
################################################## 

# Varaibles for input/output delay
set typical_input_delay 0.1
set typical_output_delay 0.1
set typical_wire_load 0.005

# Specifiy drive characteristics on ports that are driven by cells in the technology library
set_driving_cell -lib_cell INVX1TS [all_inputs]

# Define the arrival time for input ports
# Note: We define the input delay constraint relative to the system clock and to the other inputs
#       If data is stable (A) after the clock edge, input_delay is (A) (related to setup time)
set_input_delay $typical_input_delay [all_inputs] -clock $clk_name 

# Remove input delay on the specified pins or input ports
remove_input_delay -clock $clk_name [find port $clk_port]

# Set output delay on pins or output ports relative to a clock signal 
# Note: If data needs to be available (B) before the clock edge, output_delay is (B)
#       MIN & MAX delays are related to the shorest and longest path, respectively 
set_output_delay $typical_output_delay [all_outputs] -clock $clk_name

# Set a capacitive load value on input and output ports of the design
set_load 0.005 [all_outputs] 
