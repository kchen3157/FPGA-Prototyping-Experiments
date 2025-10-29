######## SET DESIGN SOURCES HERE (ONE PER FILE) ########
read_verilog -sv "src/sources/top.sv"
read_verilog -sv "src/sources/period_counter_us.sv"
read_verilog -sv "src/sources/low_freq_counter_bcd.sv"
read_verilog -sv "src/sources/ledmux.sv"
read_verilog -sv "src/sources/hextosseg.sv"
read_verilog -sv "src/sources/div.sv"
read_verilog -sv "src/sources/bintobcd.sv"
read_verilog -sv "src/sources/debouncer.sv"

######## SET CONSTRAINTS HERE ########
read_xdc "src/constrs/Nexys-Video-Master.xdc"

######## SET PART HERE ########
synth_design -top "top" -part "xc7a200tsbg484-1"

# place and route
opt_design
place_design
route_design

report_utilization -file utilizationReport.txt

######## SET FINAL BITSTREAM OUTPUT HERE ########
write_bitstream -force "build/proj.bit"
