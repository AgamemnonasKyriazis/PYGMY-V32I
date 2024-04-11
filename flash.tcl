# Set the target device
set device_name "xc7a35t_0"

# Load the bitstream file
set bitstream_file "./build/bit/top.bit"

# Initialize Vivado
open_hw_manager

# Connect to the hardware target
connect_hw_server -allow_non_jtag

# Open the target device
open_hw_target {localhost:3121/xilinx_tcf/Digilent/210328BB2376A}

current_hw_device [get_hw_devices $device_name]

refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $device_name] 0]

set_property PROBES.FILE {} [get_hw_devices $device_name]

set_property FULL_PROBES.FILE {} [get_hw_devices $device_name]

set_property PROGRAM.FILE $bitstream_file [get_hw_devices $device_name]

program_hw_devices [get_hw_devices $device_name]

refresh_hw_device [lindex [get_hw_devices $device_name] 0]

close_hw_manager
