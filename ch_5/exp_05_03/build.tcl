# read design sources (add one line for each file)
read_verilog -sv "src/sources/top.sv"
read_verilog -sv "src/sources/ploc.sv"
read_verilog -sv "src/sources/countreg.sv"
read_verilog -sv "src/sources/hextosseg.sv"
read_verilog -sv "src/sources/ledmux.sv"


# read constraints
read_xdc "src/constrs/Nexys-Video-Master.xdc"

# synth
synth_design -top "top" -part "xc7a200tsbg484-1"

# place and route
opt_design
place_design
route_design

# write bitstream1
write_bitstream -force "build/proj.bit"
