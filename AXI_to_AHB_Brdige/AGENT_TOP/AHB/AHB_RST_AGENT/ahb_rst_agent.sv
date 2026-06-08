class ahb_rst_agent extends uvm_agent;

  `uvm_component_utils(ahb_rst_agent)

  ahb_rst_driver drv;
  ahb_rst_monitor mon;
  uvm_sequencer #(ahb_rst_trans) seqr;

  function void build_phase(uvm_phase phase);
    drv  = ahb_rst_driver::type_id::create("drv", this);
    mon  = ahb_rst_monitor::type_id::create("mon", this);
    seqr = uvm_sequencer#(ahb_rst_trans)::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass