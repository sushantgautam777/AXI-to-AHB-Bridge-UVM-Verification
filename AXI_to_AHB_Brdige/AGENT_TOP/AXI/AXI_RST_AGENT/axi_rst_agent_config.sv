class axi_rst_agent_config extends uvm_object;

  `uvm_object_utils(axi_rst_agent_config)

  virtual axi_rst_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;


  extern function new(string name="axi_rst_agent_config");

endclass



//=====================================================
// Constructor
//=====================================================

function axi_rst_agent_config::new(string name="axi_rst_agent_config");

  super.new(name);

endfunction
