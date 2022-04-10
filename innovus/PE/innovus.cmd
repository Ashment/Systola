#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Apr  9 14:42:59 2022                
#                                                     
#######################################################

#@(#)CDS: Innovus v19.10-p002_1 (64bit) 04/19/2019 15:18 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 19.10-p002_1 NR190418-1643/19_10-UB (database version 18.20, 458.7.1) {superthreading v1.51}
#@(#)CDS: AAE 19.10-b002 (64bit) 04/19/2019 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 19.10-p002_1 () Apr 19 2019 06:39:48 ( )
#@(#)CDS: SYNTECH 19.10-b001_1 () Apr  4 2019 03:00:51 ( )
#@(#)CDS: CPE v19.10-p002
#@(#)CDS: IQuantus/TQuantus 19.1.0-e101 (64bit) Thu Feb 28 10:29:46 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set init_verilog /courses/ee6321/Groups/Team5/dc/PE/PE.nl.v
set init_io_file ./PE.io
set init_lef_file {/courses/ee6321/share/ibm13rflpvt/lef/ibm13_8lm_2thick_3rf_tech.lef /courses/ee6321/share/ibm13rflpvt/lef/ibm13rflpvt_macros.lef}
set init_mmmc_file ./mmmc.view
setImportMode -treatUndefinedCellAsBbox 0 -keepEmptyModule 1
set init_import_mode {-treatUndefinedCellAsBbox 0 -keepEmptyModule 1}
set init_pwr_net VDD
set init_gnd_net VSS
set_message -no_limit
init_design
floorPlan -s 180 68.4 8.4 8.4 8.4 8.4
redraw
fit
globalNetConnect VDD -type tiehi -inst * -verbose
globalNetConnect VSS -type tielo -inst * -verbose
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
applyGlobalNets
addRing -nets {VDD VSS} -type core_rings -layer {top M3 bottom M3 left M2 right M2} -width 2.4 -spacing 1.2 -center 1
redraw
sroute -nets {VDD VSS} -allowJogging 0 -allowLayerChange 0
loadIoFile ./PE.io
redraw
saveDesign PE.floorplan.enc
setDesignMode -process 130 -flowEffort standard
setMaxRouteLayer 3
setPlaceMode -timingDriven true -congEffort high
setOptMode -fixFanoutLoad true -effort high -moveInst true -reclaimArea true
place_design
globalNetConnect VDD -type tiehi -inst * -verbose
globalNetConnect VSS -type tielo -inst * -verbose
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
redraw
checkPlace
optDesign -preCTS
redraw
saveDesign PE.placed.enc
getPlaceMode -doneQuickCTS -quiet
setAttribute -net fire_in -weight 5 -avoid_detour true -bottom_preferred_routing_layer 2 -top_preferred_routing_layer 3 -preferred_extra_space 2
selectNet fire_in
zoomBox 10.44000 -6.82100 143.38600 116.15000
zoomBox 29.22200 28.35300 110.86700 103.87200
zoomBox 43.50800 55.11000 86.12800 94.53200
zoomBox 51.33500 64.96600 73.58300 85.54500
zoomBox 52.50500 66.39500 71.41600 83.88700
zoomBox 53.40400 67.65400 69.47800 82.52200
zoomBox 54.16800 68.72700 67.83100 81.36500
zoomBox 54.70900 69.72900 66.32200 80.47100
zoomBox 56.14400 72.51500 62.20700 78.12300
zoomBox 56.89300 73.96800 60.06000 76.89700
zoomBox 55.16100 72.06600 63.55800 79.83300
zoomBox 51.14000 67.36500 70.06800 84.87300
zoomBox 49.78200 65.95200 72.05100 86.55000
zoomBox 46.15200 63.03700 76.97500 91.54700
zoomBox 41.12800 59.02400 83.79000 98.48500
zoomBox 24.55000 45.78200 106.27900 121.37900
zoomBox -18.93000 11.12300 165.26800 181.50000
zoomBox -89.84500 -44.13900 263.02100 282.25100
pan 51.58400 -40.57000
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeSelectedNetOnly true
setNanoRouteMode -quiet -routeTopRoutingLayer 3
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
globalDetailRoute
redraw
setNanoRouteMode -quiet -routeSelectedNetOnly false
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeTdrEffort 10
setNanoRouteMode -quiet -drouteFixAntenna true
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -quiet -routeSiLengthLimit 200
setNanoRouteMode -quiet -routeSiEffort high
setNanoRouteMode -quiet -routeWithViaInPin true
setNanoRouteMode -quiet -routeWithViaOnlyForStandardCellPin false
setNanoRouteMode -quiet -droutePostRouteSwapVia none
setNanoRouteMode -quiet -drouteUseMultiCutViaEffort high
setNanoRouteMode -routeTopRoutingLayer 3
setNanoRouteMode -routeBottomRoutingLayer 1
globalDetailRoute
redraw
setExtractRCMode -engine postRoute -effortLevel low -coupled true
extractRC
setAnalysisMode -analysisType onChipVariation
setOptMode -yieldEffort none
setOptMode -effort high
setOptMode -drcMargin 0.0
setOptMode -holdTargetSlack 0.2 -setupTargetSlack 0.0
setOptMode -simplifyNetlist false
setOptMode -usefulSkew false
setOptMode -moveInst true
setOptMode -reclaimArea true
setOptMode -fixDRC true
setOptMode -fixCap true
optDesign -postRoute -setup -hold
zoomBox 0.67700 -68.93900 255.62200 166.87700
zoomBox 15.86500 -44.74700 232.56800 155.69600
zoomBox 35.12000 6.63600 168.20400 129.73400
zoomBox 15.57100 -56.74100 270.52000 179.07900
zoomBox 39.06100 -20.63900 172.14600 102.46000
zoomBox 51.32100 -1.79400 120.79300 62.46500
zoomBox 57.72200 8.04200 93.98700 41.58600
zoomBox 46.17700 -9.70100 142.33400 79.24100
zoomBox 22.93800 -45.41600 239.65200 155.03700
zoomBox -15.95800 -102.77900 399.20000 281.22900
pan -42.42900 -89.50600
globalNetConnect VDD -type pgpin -pin VDD -override
globalNetConnect VSS -type pgpin -pin VSS -override
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
applyGlobalNets
saveDesign PE.routed.enc
verify_drc
addFiller -cell fill1 -prefix IBM13RFLPVT_FILLER
addFiller -cell fill1 -prefix IBM13RFLPVT_FILLER
ecoRoute -target
addFiller -cell fill1 -prefix IBM13RFLPVT_FILLER
man IMPSP-5125
addFiller -cell FILL16TS FILL1TS FILL2TS FILL32TS FILL4TS FILL64TS FILL8TS -prefix IBM13RFLPVT_FILLER
verify_drc
redraw
clearDrc
verify_drc
verifyConnectivity -type regular -error 1000 -warning 50
report_power -leakage -cap -nworst -pg_pin -outfile PE.power.rpt
write_lef_abstract PE.lef -5.7 -PgpinLayers 3 -specifyTopLayer 3 -stripePin
defOut -floorplan -netlist -routing PE.final.def
streamOut PE.gds -mapFile /courses/ee6321/share/ibm13rflpvt/mapfiles/enc2gds.map -libName ibm13rflpvt -structureName PE -units 1000 -mode ALL
saveNetlist -phys -excludeLeafCell -excludeCellInst {FILL1TS FILL2TS FILL4TS FILL8TS FILL16TS FILL32TS FILL64TS} PE.phy.v
saveNetlist PE.nophy.v
extractRC -outfile PE.cap
rcOut -spef PE.spef
write_sdf -version 2.1 "$design_name.sdf"
write_sdf -version 2.1 -target_application verilog "$design_name.verilog.sdf"
setAnalysisMode -checkType hold -useDetailRC true
report_timing -check_type hold -nworst 5 > "$design_name.hold.rpt"
setAnalysisMode -checkType setup -useDetailRC true
report_timing -check_type setup -nworst 5 > "$design_name.setup.rpt"
reportCapViolation -outfile final_cap.tarpt
verifyGeometry
verifyConnectivity -type all
summaryReport -outfile PE.summary.rpt
reportCritNet -outfile PE.critnet.rpt
deselectAll
