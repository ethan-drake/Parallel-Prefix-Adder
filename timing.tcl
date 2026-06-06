# 1. Load the exact same physics dictionary you used for synthesis
read_liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Read the gate-level netlist Yosys just created
read_verilog ./synth/synth_netlist_sky130_72bit.v

# 3. Link the design to your top module
link_design adder

# --- THE NEW CONSTRAINTS ---

# 2. Create a virtual clock running at 500 MHz (2.0 ns period)
#create_clock -name MY_VIRTUAL_CLK -period 2.0
#
## 3. Tell the tool that all inputs launch perfectly on the clock tick
#set_input_delay 0 -clock MY_VIRTUAL_CLK [all_inputs]
#
## 4. Tell the tool that all outputs MUST be ready by the next clock tick
#set_output_delay 0 -clock MY_VIRTUAL_CLK [all_outputs]
#
## ---------------------------
#
## 5. Report the timing checks (removed the -unconstrained flag!)
#report_checks -digits 4

# 4. Report the single worst-case path delay (with 4 digits of precision)
report_checks -unconstrained -digits 4