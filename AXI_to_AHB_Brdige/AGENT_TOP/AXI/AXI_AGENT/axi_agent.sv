class axi_agent extends uvm_agent;

  `uvm_component_utils(axi_agent)

  axi_driver    drv;
  axi_monitor   mon;
  axi_sequencer seqrh;

  axi_agent_config axi_cfg;


  extern function new(string name="axi_agent",
                      uvm_component parent);

  extern function void build_phase(uvm_phase phase);

  extern function void connect_phase(uvm_phase phase);

endclass



//=====================================================
// Constructor
//=====================================================

function axi_agent::new(string name="axi_agent",
                        uvm_component parent);

  super.new(name,parent);

endfunction



//=====================================================
// Build Phase
//=====================================================

function void axi_agent::build_phase(uvm_phase phase);

  super.build_phase(phase);

  if(!uvm_config_db #(axi_agent_config)::get(this,
                                             "",
                                             "axi_agent_config",
                                             axi_cfg))
  begin

    `uvm_fatal(get_type_name(),
               "axi_agent_config not found")

  end


  mon = axi_monitor::type_id::create("mon",this);


  if(axi_cfg.is_active == UVM_ACTIVE)
  begin

    drv   = axi_driver::type_id::create("drv",this);

    seqrh = axi_sequencer::type_id::create("seqrh",this);

  end

endfunction



//=====================================================
// Connect Phase
//=====================================================

function void axi_agent::connect_phase(uvm_phase phase);

  super.connect_phase(phase);

  if(axi_cfg.is_active == UVM_ACTIVE)
  begin

    drv.seq_item_port.connect(seqrh.seq_item_export);

  end

endfunction
