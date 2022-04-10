# TCL script for Design Compiler

# Set library paths
# Note: DC uses the search path defined in the search_path variable to locate the library files
set search_path [list "." "/courses/ee6321/share/ibm13rflpvt/synopsys/"]

# Set the DesignWare library
# Note: A DesignWare library is a collection of reusable circuit-design building blocks that are tightly integrated into the Synopsys synthesis environment
set synthetic_library [list "dw_foundation.sldb"]

# Set the link library
# Note: DC uses the link library to resolve references
#       When you load a design into memory, DC also loads all libraries specified in the link_library variable (For macros like RAM, ROM, PAD etc..)
set link_library [list "*" \
                       "scx3_cmos8rf_lpvt_tt_1p2v_25c.db" \
                       "dw_foundation.sldb"]

# Set the target library
# Note: DC uses the target library to build a circuit
#       During mapping, it selects functionally correct gates from the target library
set target_library "/courses/ee6321/share/ibm13rflpvt/synopsys/scx3_cmos8rf_lpvt_tt_1p2v_25c.db"
