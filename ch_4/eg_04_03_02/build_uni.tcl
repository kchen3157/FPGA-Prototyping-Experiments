# read design sources (add one line for each file)
read_verilog -sv "src/sources/top_uni.sv"
read_verilog -sv "src/sources/bin_counter.sv"

# read constraints
read_xdc "src/constrs/Nexys-Video-Master-uni.xdc"

# synth
synth_design -top "top" -part "xc7a200tsbg484-1"

# place and route
opt_design
place_design
route_design

# write bitstream1
write_bitstream -force "build/proj.bit"
