class ahb_agent extends uvm_agent;

  `uvm_component_utils(ahb_agent)

  ahb_driver drv;
  ahb_monitor mon;
  ahb_sequencer seqrh;

  ahb_agent_config ahb_cfg;


  extern function new(string name="ahb_agent",
                      uvm_component parent);

  extern function void build_phase(uvm_phase phase);

  extern function void connect_phase(uvm_phase phase);

endclass



//=====================================================
// Constructor
//=====================================================

function ahb_agent::new(string name="ahb_agent",
                        uvm_component parent);

  super.new(name,parent);

endfunction



//=====================================================
// Build Phase
//=====================================================

function void ahb_agent::build_phase(uvm_phase phase);

  super.build_phase(phase);

  if(!uvm_config_db #(ahb_agent_config)::get(this,
                                             "",
                                             "ahb_agent_config",
                                             ahb_cfg))
  begin

    `uvm_fatal(get_type_name(),
               "ahb_agent_config not found")

  end

  `uvm_info("AHB_AGENT",
            "Successfully got ahb_cfg",
            UVM_LOW)

  mon = ahb_monitor::type_id::create("mon",this);

  if(ahb_cfg.is_active == UVM_ACTIVE)
  begin

    uvm_config_db #(ahb_agent_config)::set(
      this,
      "drv",
      "ahb_agent_config",
      ahb_cfg
    );

  /*  uvm_config_db #(ahb_rst_agent_config)::set(
    this,
    "drv",
    "ahb_rst_agent_config",
    ahb_cfg.ahb_rst_cfg
);*/

    drv   = ahb_driver::type_id::create("drv",this);

    seqrh = ahb_sequencer::type_id::create("seqrh",this);

  end

endfunction

//=====================================================
// Connect Phase
//=====================================================

function void ahb_agent::connect_phase(uvm_phase phase);

  super.connect_phase(phase);

  if(ahb_cfg.is_active == UVM_ACTIVE)
  begin

    drv.seq_item_port.connect(seqrh.seq_item_export);

  end

endfunction
