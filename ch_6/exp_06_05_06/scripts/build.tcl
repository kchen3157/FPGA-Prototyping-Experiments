######## SET DESIGN SOURCES HERE (ONE PER FILE) ########
read_verilog -sv "src/sources/top.sv"
read_verilog -sv "src/sources/reaction.sv"
read_verilog -sv "src/sources/sseg4/bintobcd.sv"
read_verilog -sv "src/sources/sseg4/hextosseg.sv"
read_verilog -sv "src/sources/sseg4/sseg4.sv"
read_verilog -sv "src/sources/sseg4/ledmux.sv"
read_verilog -sv "src/sources/rand_gen/div.sv"
read_verilog -sv "src/sources/rand_gen/lfsr32.sv"
read_verilog -sv "src/sources/rand_gen/rand_gen.sv"




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
