# Set the target device
set device_name "xc7a35tcpg236-1"

# Load the bitstream file
set bitstream_file "/build/bit/top.bit"

# Initialize Vivado
open_hw_manager

# Connect to the hardware target
connect_hw_server -allow_non_jtag

# Open the target device
open_hw_target {localhost:3121/xilinx_tcf/Digilent/210328BB2376A}

current_hw_device [get_hw_devices xc7a35t_0]

refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a35t_0] 0]

set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]

set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]

set_property PROGRAM.FILE {/home/agamemnon/Desktop/PYGMY/build/bit/top.bit} [get_hw_devices xc7a35t_0]

program_hw_devices [get_hw_devices xc7a35t_0]

refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]

close_hw_manager
