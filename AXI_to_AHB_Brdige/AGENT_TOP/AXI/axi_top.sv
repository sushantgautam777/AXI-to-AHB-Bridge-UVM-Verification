class axi_agent_top extends uvm_env;

  `uvm_component_utils(axi_agent_top)

  axi_agent        axi_agth[];
  axi_rst_agent    axi_rst_agth[];

  axi_agent_config      axi_cfg[];
  axi_rst_agent_config  axi_rst_cfg[];

  environment_config env_cfg;


  extern function new(string name="axi_agent_top",
                      uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass



//======================================================
// Constructor
//======================================================

function axi_agent_top::new(string name="axi_agent_top",
                            uvm_component parent);

  super.new(name,parent);

endfunction



//======================================================
// Build Phase
//======================================================

function void axi_agent_top::build_phase(uvm_phase phase);

  super.build_phase(phase);


  if(!uvm_config_db #(environment_config)::get(this,
                                               "",
                                               "environment_config",
                                               env_cfg))
  begin

    `uvm_fatal(get_type_name(),
               "environment_config not found")

  end



  //----------------------------------------------------
  // AXI AGENTS
  //----------------------------------------------------

  if(env_cfg.has_axi_agent)
  begin

    axi_agth = new[env_cfg.no_of_axi_agent];

    foreach(axi_agth[i])
    begin

      uvm_config_db #(axi_agent_config)::set
      (
        this,
        $sformatf("axi_agth[%0d]*",i),
        "axi_agent_config",
        env_cfg.axi_cfg[i]
      );

      axi_agth[i] =
      axi_agent::type_id::create
      (
        $sformatf("axi_agth[%0d]",i),
        this
      );

    end

  end



  //----------------------------------------------------
  // AXI RESET AGENTS
  //----------------------------------------------------

  if(env_cfg.has_axi_rst_agent)
  begin

    axi_rst_agth =
    new[env_cfg.no_of_axi_rst_agent];

    foreach(axi_rst_agth[i])
    begin

      uvm_config_db #(axi_rst_agent_config)::set
      (
        this,
        $sformatf("axi_rst_agth[%0d]*",i),
        "axi_rst_agent_config",
        env_cfg.axi_rst_cfg[i]
      );

      axi_rst_agth[i] =
      axi_rst_agent::type_id::create
      (
        $sformatf("axi_rst_agth[%0d]",i),
        this
      );

    end

  end

endfunction
