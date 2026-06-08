class virtual_sequencer extends uvm_sequencer;

  `uvm_component_utils(virtual_sequencer)

  environment_config env_cfg;

  axi_sequencer      axi_seqrh[];
  ahb_sequencer      ahb_seqrh[];

  axi_rst_sequencer  axi_rst_seqrh[];
  ahb_rst_sequencer  ahb_rst_seqrh[];


  function new(string name="virtual_sequencer",
               uvm_component parent);

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(environment_config)::get(this,
                                                 "",
                                                 "environment_config",
                                                 env_cfg))

      `uvm_fatal(get_type_name(),
                 "configuration failed in virtual sequencer");


    if(env_cfg.has_axi_agent)

      axi_seqrh =
      new[env_cfg.no_of_axi_agent];


    if(env_cfg.has_ahb_agent)

      ahb_seqrh =
      new[env_cfg.no_of_ahb_agent];


    if(env_cfg.has_axi_rst_agent)

      axi_rst_seqrh =
      new[env_cfg.no_of_axi_rst_agent];


    if(env_cfg.has_ahb_rst_agent)

      ahb_rst_seqrh =
      new[env_cfg.no_of_ahb_rst_agent];

  endfunction

endclass
