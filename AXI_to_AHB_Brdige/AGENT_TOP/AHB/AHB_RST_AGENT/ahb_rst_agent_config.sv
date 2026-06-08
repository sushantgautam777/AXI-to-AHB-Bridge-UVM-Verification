// =====================================================
//  ahb_rst_agent_config.sv
// =====================================================
class ahb_rst_agent_config extends uvm_object;
    `uvm_object_utils(ahb_rst_agent_config)
 
    virtual ahb_rst_if.AHB_RST_DRV_MP vif;
 
    uvm_active_passive_enum is_active = UVM_ACTIVE;
 
    extern function new(string name="ahb_rst_agent_config");
 
endclass
 
//--------------------------- new -------------------
function ahb_rst_agent_config::new(string name="ahb_rst_agent_config");
    super.new(name);
endfunction
 