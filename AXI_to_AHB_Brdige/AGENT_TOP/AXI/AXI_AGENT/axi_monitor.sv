
class axi_monitor extends uvm_monitor;

  `uvm_component_utils(axi_monitor)

  virtual axi_if.AXI_MON_MP vif;

  uvm_analysis_port #(axi_trans) axi_monitor_port;
  uvm_analysis_port #(axi_trans) axi_write_data_monitor_port;
  uvm_analysis_port #(axi_trans) axi_read_data_monitor_port;

  axi_trans axi_xtn;
  axi_trans axi_xtn1;
  axi_trans axi_xtn2;
  axi_trans axi_xtn3;
  axi_trans axi_xtn4;

  axi_trans axi_write_data;
  axi_trans axi_read_data;

  axi_trans q1[$],q2[$];

  semaphore sem1=new();
  semaphore sem2=new();
  semaphore sem3=new(1);
  semaphore sem4=new(1);
  semaphore sem5=new(1);
  semaphore sem6=new();
  semaphore sem7=new(1);
  semaphore sem8=new(1);


  axi_agent_config axi_cfg;

  function new(string name="axi_monitor",uvm_component parent);

    super.new(name,parent);
    axi_monitor_port =new("axi_monitor_port",this);

    axi_write_data_monitor_port =new("axi_write_data_monitor_port",this);

    axi_read_data_monitor_port =new("axi_read_data_monitor_port",this);

  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(axi_agent_config)::get(this,"","axi_agent_config", axi_cfg))
      `uvm_fatal(get_type_name(),"configuration is not get properly in axi monitor")

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = axi_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    begin
      forever
        collect();
    end
  endtask

  task collect();
    axi_xtn = axi_trans::type_id::create("axi_xtn",this);
    fork
      begin
        sem3.get(1);
        wr_addr_channel();
        sem1.put(1);
        sem3.put(1);
      end

      begin
        sem4.get(1);
        sem1.get(1);
        wr_data_channel(q1.pop_front());
        sem2.put(1);
        sem4.put(1);
      end

      begin
        sem5.get(1);
        sem2.get(1);
        wr_rsp_channel(q1.pop_front());
        sem5.put(1);
      end

      begin
        sem7.get(1);
        rd_addr_channel();
        sem6.put(1);
        sem7.put(1);
      end

      begin
        sem8.get(1);
        sem6.get(1);
        rd_data_channel(q2.pop_front());
        sem8.put(1);
      end
    join
  endtask

  // ---------------- WRITE ADDRESS CHANNEL ----------------
  task wr_addr_channel();

    wait((vif.axi_mon_cb.awvalid) &&(vif.axi_mon_cb.awready))
    axi_xtn.awid    = vif.axi_mon_cb.awid;
    axi_xtn.awvalid = vif.axi_mon_cb.awvalid;
    axi_xtn.awready = vif.axi_mon_cb.awready;
    axi_xtn.awaddr  = vif.axi_mon_cb.awaddr;
    axi_xtn.awlen   = vif.axi_mon_cb.awlen;
    axi_xtn.awsize  = vif.axi_mon_cb.awsize;
    axi_xtn.awburst = vif.axi_mon_cb.awburst;
    q1.push_back(axi_xtn);
    @(vif.axi_mon_cb);
  endtask

  // ---------------- WRITE DATA CHANNEL ----------------
  task wr_data_channel(axi_trans axi_xtn);
    axi_xtn1 = axi_trans::type_id::create("axi_xtn1");
    axi_xtn1 = axi_xtn;
    axi_xtn1.wdata = new[axi_xtn1.awlen+1];
    axi_xtn1.wstrb = new[axi_xtn1.awlen+1];

    foreach(axi_xtn1.wdata[i])

    begin

      wait((vif.axi_mon_cb.wvalid == 1'b1) &&(vif.axi_mon_cb.wready == 1'b1));

      axi_write_data = axi_trans::type_id::create("axi_write_data");

      axi_xtn.wready  = vif.axi_mon_cb.wready;
      axi_xtn.wvalid  = vif.axi_mon_cb.wvalid;
      axi_xtn1.wid    = vif.axi_mon_cb.wid;
      axi_xtn1.wdata[i] = vif.axi_mon_cb.wdata;

      axi_write_data.temp_wdata[7:0] =vif.axi_mon_cb.wstrb[0] ?vif.axi_mon_cb.wdata[7:0] : 8'b00000000;
      axi_write_data.temp_wdata[15:8] =vif.axi_mon_cb.wstrb[1] ?vif.axi_mon_cb.wdata[15:8] : 8'b00000000;
      axi_write_data.temp_wdata[23:16] =vif.axi_mon_cb.wstrb[2] ?vif.axi_mon_cb.wdata[23:16] : 8'b00000000;
      axi_write_data.temp_wdata[31:24] =vif.axi_mon_cb.wstrb[3] ?vif.axi_mon_cb.wdata[31:24] : 8'b00000000;
      axi_write_data.temp_wdata[39:32] =vif.axi_mon_cb.wstrb[4] ?vif.axi_mon_cb.wdata[39:32] : 8'b00000000;
      axi_write_data.temp_wdata[47:40] =vif.axi_mon_cb.wstrb[5] ?vif.axi_mon_cb.wdata[47:40] : 8'b00000000;
      axi_write_data.temp_wdata[55:48] =vif.axi_mon_cb.wstrb[6] ?vif.axi_mon_cb.wdata[55:48] : 8'b00000000;
      axi_write_data.temp_wdata[63:56] =vif.axi_mon_cb.wstrb[7] ? vif.axi_mon_cb.wdata[63:56] : 8'b00000000;

      axi_xtn1.wstrb[i] =vif.axi_mon_cb.wstrb;
      if(i == (axi_xtn1.wdata.size()-1))
        axi_xtn1.wlast =vif.axi_mon_cb.wlast;
        @(vif.axi_mon_cb);
        `uvm_info("AXI_WDATA_MON",$sformatf("PUSHING %h",axi_write_data.temp_wdata), UVM_LOW)
        axi_write_data_monitor_port.write(axi_write_data);
    end
    `uvm_info(get_type_name(),$sformatf("axi_trans :\n %p",axi_xtn1.sprint()),UVM_LOW)

    q1.push_back(axi_xtn1);
  endtask
  // ---------------- WRITE RESPONSE CHANNEL ----------------
  task wr_rsp_channel(axi_trans axi_xtn1);
    axi_xtn2 = axi_trans::type_id::create("axi_xtn2");
    axi_xtn2 = axi_xtn1;
    wait((vif.axi_mon_cb.bvalid) &&(vif.axi_mon_cb.bready))
    axi_xtn.bvalid = vif.axi_mon_cb.bvalid;
    axi_xtn.bready = vif.axi_mon_cb.bready;
    axi_xtn2.bid   = vif.axi_mon_cb.bid;
    axi_xtn2.bresp = vif.axi_mon_cb.bresp;
    axi_xtn2.bvalid = vif.axi_mon_cb.bvalid;
    axi_monitor_port.write(axi_xtn2);
    `uvm_info(get_type_name(),$sformatf("axi_trans:\n %p",axi_xtn1.sprint()),UVM_LOW)
    @(vif.axi_mon_cb);
  endtask
  // ---------------- READ ADDRESS CHANNEL ----------------
  task rd_addr_channel();
    axi_xtn3 =axi_trans::type_id::create("axi_xtn3");
    @(vif.axi_mon_cb);
    wait((vif.axi_mon_cb.arvalid) &&(vif.axi_mon_cb.arready))
    axi_xtn3.arid    = vif.axi_mon_cb.arid;
    axi_xtn3.arready = vif.axi_mon_cb.arready;
    axi_xtn3.arvalid = vif.axi_mon_cb.arvalid;
    axi_xtn3.araddr  = vif.axi_mon_cb.araddr;
    axi_xtn3.arlen   = vif.axi_mon_cb.arlen;
    axi_xtn3.arsize  = vif.axi_mon_cb.arsize;
    axi_xtn3.arburst = vif.axi_mon_cb.arburst;
    @(vif.axi_mon_cb);
    q2.push_back(axi_xtn3);
  endtask
  // ---------------- READ DATA CHANNEL ----------------
  task rd_data_channel(axi_trans axi_xtn3);
    bit a;
    axi_xtn4 =axi_trans::type_id::create("axi_xtn4");
    axi_xtn4 = axi_xtn3;
    axi_xtn4.rdata =new[axi_xtn4.arlen+1];
    foreach(axi_xtn4.rdata[i])
    begin
      wait((vif.axi_mon_cb.rvalid) && (vif.axi_mon_cb.rready));
      axi_read_data =axi_trans::type_id::create("axi_read_data");
      axi_xtn4.rid    = vif.axi_mon_cb.rid;
      axi_xtn4.rvalid = vif.axi_mon_cb.rvalid;
      axi_xtn4.rready = vif.axi_mon_cb.rready;
      axi_xtn4.rdata[i] =vif.axi_mon_cb.rdata;
      axi_xtn4.rresp[i] =vif.axi_mon_cb.rresp;
      axi_read_data.temp_rdata =vif.axi_mon_cb.rdata;
      if(i == (axi_xtn4.rdata.size()-1))
      begin
        axi_xtn4.rlast = vif.axi_mon_cb.rlast;
        a = vif.axi_mon_cb.rlast;
      end
      @(vif.axi_mon_cb);
      axi_read_data_monitor_port.write(axi_read_data);
    end
    axi_monitor_port.write(axi_xtn4);
    `uvm_info(get_type_name(),$sformatf("axi_trans :\n %p",axi_xtn4.sprint()),UVM_LOW)

  endtask
