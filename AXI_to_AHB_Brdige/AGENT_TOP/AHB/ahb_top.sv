AGENT_TOP  AXI2AHB_RTL  sim  tb  test
[SGautam@mavenserver-RH3 axi3x3]$ cd AGENT_TOP
[SGautam@mavenserver-RH3 AGENT_TOP]$ ls
AHB  AXI
[SGautam@mavenserver-RH3 AGENT_TOP]$ cd AHB
[SGautam@mavenserver-RH3 AHB]$ ls
AHB_AGENT  AHB_RST_AGENT  ahb_top.sv
[SGautam@mavenserver-RH3 AHB]$ vi ahb_top.sv
class ahb_agent_top extends uvm_env;

  `uvm_component_utils(ahb_agent_top)

  ahb_agent        ahb_agth[];
  ahb_rst_agent    ahb_rst_agth[];

  ahb_agent_config      ahb_cfg[];
  ahb_rst_agent_config  ahb_rst_cfg[];

  environment_config env_cfg;


  extern function new(string name="ahb_agent_top",
                      uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass



//======================================================
// Constructor
//======================================================

function ahb_agent_top::new(string name="ahb_agent_top",
                            uvm_component parent);

  super.new(name,parent);

endfunction



//======================================================
// Build Phase
//======================================================

function void ahb_agent_top::build_phase(uvm_phase phase);

  super.build_phase(phase);


  if(!uvm_config_db #(environment_config)::get(this,
                                               "",
                                               "environment_config",
                                               env_cfg))
  begin

    `uvm_fatal(get_type_name(),
               "environment_config not found")

  end



  //--------------------------------------------
  // AHB AGENTS
  //--------------------------------------------

  if(env_cfg.has_ahb_agent)
  begin

    ahb_agth = new[env_cfg.no_of_ahb_agent];

    foreach(ahb_agth[i])
    begin

      uvm_config_db #(ahb_agent_config)::set
      (
        this,
        $sformatf("ahb_agth[%0d]*",i),
        "ahb_agent_config",
        env_cfg.ahb_cfg[i]
      );

      ahb_agth[i] =
      ahb_agent::type_id::create
      (
        $sformatf("ahb_agth[%0d]",i),
        this
      );

    end

  end



  //--------------------------------------------
  // AHB RESET AGENTS
  //--------------------------------------------

  if(env_cfg.has_ahb_rst_agent)
  begin

    ahb_rst_agth =
    new[env_cfg.no_of_ahb_rst_agent];

    foreach(ahb_rst_agth[i])
    begin

      uvm_config_db #(ahb_rst_agent_config)::set
      (
        this,
        $sformatf("ahb_rst_agth[%0d]*",i),
        "ahb_rst_agent_config",
        env_cfg.ahb_rst_cfg[i]
      );

      ahb_rst_agth[i] =
      ahb_rst_agent::type_id::create
      (
        $sformatf("ahb_rst_agth[%0d]",i),
        this
      );

    end

  end

endfunction
