set_param general.maxThreads 8

# read design sources
read_verilog -v "../rtl/top.v"
read_verilog -v "../rtl/decode.v"
read_verilog -v "../rtl/execute.v"
read_verilog -v "../rtl/alu.v"
read_verilog -v "../rtl/lsu.v"
read_verilog -v "../rtl/regfile.v"
read_verilog -v "../rtl/uart.v"
read_verilog -v "../rtl/ram.v"
read_verilog -v "../rtl/rom.v"
read_verilog -v "../rtl/sync_fifo.v"

read_mem -q "../sw/image.hex"

# read constraints
read_xdc "../arty.xdc"

# synth
synth_design -verbose -top "top" -part "xc7a35tcpg236-1"

opt_design
place_design
route_design

report_utilization -file synth/reports/utilization

report_utilization -hierarchical -file synth/reports/hierarchical_utilization

#write bitstream
write_bitstream -force "bit/top.bit"

