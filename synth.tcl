# Import all Yosys commands into the Tcl environment
yosys -import

# Define the list of widths you want to sweep
set widths {8 16 32 64 72}

# Loop through each width
foreach w $widths {
    
    puts "========================================================="
    puts "   STARTING SYNTHESIS FOR WIDTH: $w BITS"
    puts "========================================================="

    # 1. Clear Yosys memory so the previous loop doesn't conflict
    design -reset

    # 2. Read the physics dictionary (WITH THE -lib FLAG!) and Verilog
    read_liberty -lib ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
    read_verilog convert_to_v/adder.v

    # 3. Check hierarchy
    hierarchy -check -top adder

    # 4. Override the SystemVerilog parameter
    chparam -set WIDTH $w adder

    # 5. Run generic synthesis
    synth -top adder

    # 6. Map to Google Sky130 standard cells
    abc -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib

    # 7. Clean up unused wires
    opt
    clean

    # 8. Write the final netlist using the loop variable
    write_verilog ./synth/synth_netlist_sky130_${w}bit.v
    
    puts "Finished synthesis for $w bits!"
}