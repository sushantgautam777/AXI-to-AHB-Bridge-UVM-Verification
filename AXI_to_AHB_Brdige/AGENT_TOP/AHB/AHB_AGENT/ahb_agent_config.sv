class ahb_agent_config extends uvm_object;

  `uvm_object_utils(ahb_agent_config)

  virtual ahb_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;


  extern function new(string name="ahb_agent_config");

endclass



function ahb_agent_config::new(string name="ahb_agent_config");

  super.new(name);

endfunction
