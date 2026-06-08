class ahb_monitor extends uvm_monitor;

  `uvm_component_utils(ahb_monitor)
  ahb_agent_config ahb_cfg;
  virtual ahb_if.AHB_MON_MP vif;
  ahb_trans ahb_xtn;
  uvm_analysis_port #(ahb_trans) monitor_port;

  function new(string name = "ahb_monitor",uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this,"","ahb_agent_config",ahb_cfg))
      `uvm_fatal(get_type_name(),"configuration is not set properly for ahb monitor")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = ahb_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    forever
      collect();
  endtask


  task collect();
    ahb_xtn = ahb_trans::type_id::create("ahb_xtn",this);
    begin
      wait((vif.ahb_mon_cb.hready == 1'b1) &&(vif.ahb_mon_cb.htrans == 2'b10));


     `uvm_info("AHB_PHASE",$sformatf("ADDR_PHASE HADDR=%h HTRANS=%0d",vif.ahb_mon_cb.haddr, vif.ahb_mon_cb.htrans),UVM_LOW)





      ahb_xtn.haddr  = vif.ahb_mon_cb.haddr;
      ahb_xtn.htrans = vif.ahb_mon_cb.htrans;
      ahb_xtn.hburst = vif.ahb_mon_cb.hburst;
      ahb_xtn.hsize  = vif.ahb_mon_cb.hsize;
      ahb_xtn.hwrite = vif.ahb_mon_cb.hwrite;
      ahb_xtn.hready = vif.ahb_mon_cb.hready;
      ahb_xtn.hresp  = vif.ahb_mon_cb.hresp;

      if(vif.ahb_mon_cb.hwrite == 1'b1)
      begin
        @(vif.ahb_mon_cb);
        wait(vif.ahb_mon_cb.hready == 1'b1)

`uvm_info("AHB_DEBUG",$sformatf("ADDR=%h DATA=%h", ahb_xtn.haddr,  vif.ahb_mon_cb.hwdata),UVM_LOW)



        ahb_xtn.hwdata = vif.ahb_mon_cb.hwdata;

        `uvm_info("AHB_MON",$sformatf("CAPTURED HADDR=%h HWDATA=%h", ahb_xtn.haddr, ahb_xtn.hwdata), UVM_LOW)

`uvm_info("AHB_DATA",$sformatf("DATA_PHASE HWDATA=%h", vif.ahb_mon_cb.hwdata),UVM_LOW)



        monitor_port.write(ahb_xtn);
      end
      else
      begin
        @(vif.ahb_mon_cb);
        ahb_xtn.hrdata = vif.ahb_mon_cb.hrdata;
        monitor_port.write(ahb_xtn);
      end
    end
    `uvm_info(get_type_name(), $sformatf("ahb_trans : \n %p",ahb_xtn.sprint()), UVM_LOW)
  endtask
endclass
