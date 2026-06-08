class axi_rst_sequencer extends uvm_sequencer#(axi_rst_trans);
     `uvm_component_utils(axi_rst_sequencer)

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass
