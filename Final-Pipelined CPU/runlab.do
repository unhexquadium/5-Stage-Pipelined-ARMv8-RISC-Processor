# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./pipelined_cpu.sv"
vlog "./setflag.sv"
vlog "./PC.sv"
vlog "./signextend.sv"
vlog "./mult.sv"
vlog "./cpu_cntrl.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./adder.sv"
vlog "./mux8x64_1.sv"
vlog "./alu.sv"
vlog "./regfile.sv"
vlog "./mux2_1.sv"
vlog "./giantMux.sv"
vlog "./decoder5_32.sv"
vlog "./D_FF.sv"
vlog "./createReg.sv"
vlog "./IFDE.sv"
vlog "./forwarding.sv"



# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work pipelined_cpustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
