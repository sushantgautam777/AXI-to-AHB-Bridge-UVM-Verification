
class axi_rst_driver extends uvm_driver#(axi_rst_trans);
  `uvm_component_utils(axi_rst_driver)
  axi_rst_trans axi_rst_xtn;
  axi_rst_agent_config rst_cfg;

  virtual axi_rst_if.AXI_RST_DRV_MP vif;

  extern function new(string name="axi_rst_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(axi_rst_trans xtn);
endclass


//-------------------------------- new --------------------------------//
function axi_rst_driver::new(string name="axi_rst_driver",uvm_component parent);
  super.new(name,parent);
endfunction
//-------------------------------- build phase --------------------------------//
function void axi_rst_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(axi_rst_agent_config)::get(this,"","axi_rst_agent_config",rst_cfg))
    `uvm_fatal(get_type_name(),"configuration is not set properly")
  `uvm_info(get_type_name(),"axi rst driver build_phase",UVM_HIGH)
endfunction
//-------------------------------- connect phase --------------------------------//
function void axi_rst_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif=rst_cfg.vif;
  `uvm_info(get_type_name(),"axi rst driver connect_phase",UVM_HIGH)
endfunction
//-------------------------------- run phase --------------------------------//
task axi_rst_driver::run_phase(uvm_phase phase);
  forever
  begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
  `uvm_info(get_type_name(),
            "axi rst driver run_phase",
            UVM_HIGH)
endtask
//-------------------------------- send to dut --------------------------------//
task axi_rst_driver::send_to_dut(axi_rst_trans xtn);
  @(vif.axi_rst_drv_cb)
  vif.axi_rst_drv_cb.aresetn<=xtn.aresetn;
  @(vif.axi_rst_drv_cb);
  @(vif.axi_rst_drv_cb);
  vif.axi_rst_drv_cb.aresetn<=1'b1;
endtask
~
