class axi_rst_monitor extends uvm_monitor;
  `uvm_component_utils(axi_rst_monitor)
  axi_rst_trans axi_rst_xtn;
  axi_rst_agent_config rst_cfg;
//  axi_agent_config axi_cfg;
  virtual axi_rst_if.AXI_RST_MON_MP vif;
 // virtual axi_if.AXI_MON_MP a_vif;
  uvm_analysis_port #(axi_rst_trans) rst_monitor_port;

  extern function new(string name="axi_rst_monitor",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect();
endclass
//-------------------------------- new --------------------------------//
function axi_rst_monitor::new(string name="axi_rst_monitor",uvm_component parent);
  super.new(name,parent);
  rst_monitor_port=new("rst_monitor_port",this);
endfunction
//-------------------------------- build phase --------------------------------//
function void axi_rst_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(axi_rst_agent_config)::get(this,"","axi_rst_agent_config",rst_cfg))

    `uvm_fatal(get_type_name(),"configuration is not get properly in axi monitor")
 /* if(!uvm_config_db#(axi_agent_config)::get(this,"","axi_agent_config",axi_cfg))

    `uvm_fatal(get_type_name(),"configuration is not get properly in axi monitor")
 */
    axi_rst_xtn=axi_rst_trans::type_id::create("axi_rst_xtn",this);
  `uvm_info(get_type_name(),"axi rst monitor build_phase",UVM_HIGH)
endfunction
//-------------------------------- connect phase --------------------------------//
function void axi_rst_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif=rst_cfg.vif;
 // a_vif=axi_cfg.vif;
  `uvm_info(get_type_name(),"axi rst monitor connect_phase",UVM_HIGH)
endfunction
//-------------------------------- run phase --------------------------------//
task axi_rst_monitor::run_phase(uvm_phase phase);
  forever
    collect();
  `uvm_info(get_type_name(),"axi rst monitor run_phase",UVM_HIGH)
endtask
//-------------------------------- collect --------------------------------//
task axi_rst_monitor::collect();
  wait(!vif.axi_rst_mon_cb.aresetn);
  @(vif.axi_rst_mon_cb);
  $display("//////////////////// %d",vif.axi_rst_mon_cb.aresetn);
  axi_rst_xtn.aresetn=vif.axi_rst_mon_cb.aresetn;
 // axi_rst_xtn.bvalid=a_vif.axi_mon_cb.bvalid;
 // axi_rst_xtn.rvalid=a_vif.axi_mon_cb.rvalid;
  rst_monitor_port.write(axi_rst_xtn);
  //`uvm_info(get_type_name(),$sformatf("axi_rst_trans: \n %p",axi_rst_xtn.sprint()),UVM_LOW)
endtask
