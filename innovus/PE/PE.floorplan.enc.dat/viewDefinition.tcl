if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name typical_lib\
   -timing\
    [list ${::IMEX::libVar}/mmmc/scx3_cmos8rf_lpvt_tt_1p2v_25c.lib]
create_rc_corner -name typical_rc\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name typical_dly\
   -library_set typical_lib\
   -rc_corner typical_rc
create_constraint_mode -name typical_constraint\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/PE.syn.sdc]
create_analysis_view -name typical -constraint_mode typical_constraint -delay_corner typical_dly
set_analysis_view -setup [list typical] -hold [list typical]
