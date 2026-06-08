class axi_sequencer extends uvm_sequencer;
     `uvm_component_utils(axi_seqr)

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction
endclass
