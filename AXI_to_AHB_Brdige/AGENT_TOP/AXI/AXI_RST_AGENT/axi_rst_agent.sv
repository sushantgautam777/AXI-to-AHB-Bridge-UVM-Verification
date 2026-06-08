class axi_rst_agent extends uvm_agent;

  `uvm_component_utils(axi_rst_agent)

  axi_rst_driver drv;
  axi_rst_monitor mon;
  axi_rst_sequencer seqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    drv  = axi_rst_driver   ::type_id::create("drv", this);
    mon  = axi_rst_monitor  ::type_id::create("mon", this);
    seqr = axi_rst_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass