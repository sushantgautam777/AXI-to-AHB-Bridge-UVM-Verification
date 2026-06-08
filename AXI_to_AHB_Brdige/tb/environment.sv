class environment extends uvm_env;
  `uvm_component_utils(environment)
  axi_agent_top axi_agnt_top_h[];
  ahb_agent_top ahb_agnt_top_h[];
  scoreboard scoreboardh;
  virtual_sequencer vseqrh;
  environment_config env_cfg;
  extern function new(string name="environment", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

//======================================================
// Constructor
//======================================================
function environment::new(string name="environment",   uvm_component parent);
  super.new(name,parent);
endfunction

//======================================================
// Build Phase
//======================================================
function void environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(environment_config)::get(this, "", "environment_config", env_cfg))
    `uvm_fatal(get_type_name(),  "configuration failed in environment")

  //---------------------------------------------
  // AXI AGENT TOP
  //---------------------------------------------
  if(env_cfg.has_axi_agent ||
     env_cfg.has_axi_rst_agent)
  begin
    axi_agnt_top_h = new[env_cfg.no_of_axi_agent];
    foreach(axi_agnt_top_h[i])
      axi_agnt_top_h[i] = axi_agent_top::type_id::create ( $sformatf("axi_agnt_top_h[%0d]",i), this);
  end

  //---------------------------------------------
  // AHB AGENT TOP
  //---------------------------------------------
  if(env_cfg.has_ahb_agent ||
     env_cfg.has_ahb_rst_agent)
  begin
    ahb_agnt_top_h =new[env_cfg.no_of_ahb_agent];
    foreach(ahb_agnt_top_h[i])
        ahb_agnt_top_h[i]=           ahb_agent_top::type_id::create ( $sformatf("ahb_agnt_top_h[%0d]",i),this);
  end
  //---------------------------------------------
  // SCOREBOARD
  //---------------------------------------------
  if(env_cfg.has_scoreboard)
    scoreboardh =    scoreboard::type_id::create( "scoreboardh", this);
  //---------------------------------------------
  // VIRTUAL SEQUENCER
  //---------------------------------------------
  if(env_cfg.has_virtual_sequencer)
    vseqrh = virtual_sequencer::type_id::create ("vseqrh", this );
endfunction

//======================================================
// Connect Phase
//======================================================
function void environment::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //----------------------------------------------------
  // Virtual Sequencer Connections
  //----------------------------------------------------
  if(env_cfg.has_virtual_sequencer)
  begin

    if(env_cfg.has_axi_agent)
    begin
      foreach(axi_agnt_top_h[i])
        vseqrh.axi_seqrh[i] =
        axi_agnt_top_h[i].axi_agth[i].seqrh;
    end

    if(env_cfg.has_ahb_agent)
    begin
      foreach(ahb_agnt_top_h[i])
        vseqrh.ahb_seqrh[i] =
        ahb_agnt_top_h[i].ahb_agth[i].seqrh;
    end

    if(env_cfg.has_axi_rst_agent)
    begin
      foreach(axi_agnt_top_h[i])
        vseqrh.axi_rst_seqrh[i] = axi_agnt_top_h[i].axi_rst_agth[i].seqr;
    end

    if(env_cfg.has_ahb_rst_agent)
    begin
      foreach(ahb_agnt_top_h[i])
        vseqrh.ahb_rst_seqrh[i] =  ahb_agnt_top_h[i].ahb_rst_agth[i].seqrh;
    end
  end

  //----------------------------------------------------
  // Scoreboard Connections
  //----------------------------------------------------

  if(env_cfg.has_scoreboard)
  begin

    //-----------------------------------------
    // AXI MONITOR
    //-----------------------------------------
    foreach(axi_agnt_top_h[i])
    begin

      axi_agnt_top_h[i].axi_agth[i].mon. axi_monitor_port.connect (   scoreboardh.fifo_axi_h[i].analysis_export   );

      axi_agnt_top_h[i].axi_agth[i].mon.axi_write_data_monitor_port.connect  ( scoreboardh.fifo_axi_wdata_h[i].analysis_export      );

      axi_agnt_top_h[i].axi_agth[i].mon.axi_read_data_monitor_port.connect (   scoreboardh.fifo_axi_rdata_h[i].analysis_export );

    end
    //-----------------------------------------
    // AHB MONITOR
    //-----------------------------------------
    foreach(ahb_agnt_top_h[i])
    begin
      ahb_agnt_top_h[i].ahb_agth[i].mon. monitor_port.connect(scoreboardh.fifo_ahb_h[i].analysis_export);
    end
    //-----------------------------------------
    // AXI RESET MONITOR
    //-----------------------------------------
    foreach(axi_agnt_top_h[i])
    begin
      axi_agnt_top_h[i].axi_rst_agth[i].mon.rst_monitor_port.connect(scoreboardh.fifo_axi_rst_h[i].analysis_export);

    end
    //-----------------------------------------
    // AHB RESET MONITOR
    //-----------------------------------------
    foreach(ahb_agnt_top_h[i])
    begin
      ahb_agnt_top_h[i].ahb_rst_agth[i].mon. rst_monitor_port.connect ( scoreboardh.fifo_ahb_rst_h[i].analysis_export);
    end
  end
endfunction
