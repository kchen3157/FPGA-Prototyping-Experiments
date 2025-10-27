#! THE SOURCE MODULE UNDER TESTING MUST BE NAMED ${MODULE_UNDER_TEST}.sv
#! THE TB MUST BE NAMED $(MODULE_UNDER_TEST)_tb.sv

######## SET MODULE NAME HERE ########
set MODULE_UNDER_TEST "low_freq_counter_bin"

######## SET SIM TIME HERE ########
set SIM_TIME "10s"

######## SET WAVEFORM OUTPUT DIRECTORY ########
set WAVEFORM_DIR "waveforms"
set TIMESTAMP [clock format [clock seconds] -format "%Y%m%d_%H%M%S"]
file mkdir ${WAVEFORM_DIR}

# Create new project for simulation
create_project temp_proj_${MODULE_UNDER_TEST}_tb ./temp_proj_${MODULE_UNDER_TEST}_tb -force
set_property target_language Verilog [current_project]

######## SET PART HERE ########
set_property part xc7a200tsbg484-1 [current_project]

######## ADD SOURCE FILES HERE ########
add_files -fileset sim_1 "src/sims/${MODULE_UNDER_TEST}_tb.sv"
add_files -fileset sources_1 "src/sources/${MODULE_UNDER_TEST}.sv"
add_files -fileset sources_1 "src/sources/div.sv"
add_files -fileset sources_1 "src/sources/period_counter_us.sv"
# add_files -fileset sources_1 "src/sources/DEPENDENCIES.sv"

# Set top
set_property top ${MODULE_UNDER_TEST}_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

launch_simulation

# Save space by not writing vcd
# open_vcd ../../../../../${WAVEFORM_DIR}/${TIMESTAMP}_${MODULE_UNDER_TEST}_tb.vcd
# log_vcd /${MODULE_UNDER_TEST}_tb/*

# Run simulation to generate VCD
restart
run ${SIM_TIME}

# Close VCD and exit
close_vcd