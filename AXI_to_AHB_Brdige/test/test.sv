class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  environment envh;
  environment_config env_cfg;

  axi_agent_config axi_cfg[];
  ahb_agent_config ahb_cfg[];

  axi_rst_agent_config axi_rst_cfg[];
  ahb_rst_agent_config ahb_rst_cfg[];

  bit has_axi_agent=1'b1;
  bit has_ahb_agent=1'b1;
  bit has_scoreboard=1'b1;
  bit has_virtual_sequencer=1'b1;

  int no_of_axi_agent=1;
  int no_of_ahb_agent=1;

  bit has_axi_rst_agent=1'b1;
  bit has_ahb_rst_agent=1'b1;

  int no_of_axi_rst_agent=1;
  int no_of_ahb_rst_agent=1;

  rand int length[];

  int no_of_transactions = 5;

  constraint length_c
  {
    foreach(length[i])
      length[i] inside {[1:15]};
  }

  function new(string name="base_test",
               uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    env_cfg=environment_config::type_id::create("env_cfg");

    config_method();

    uvm_config_db#(environment_config)::set(this,
                                            "*",
                                            "environment_config",
                                            env_cfg);

    envh=environment::type_id::create("envh",this);

  endfunction


  function void config_method();

    env_cfg.has_axi_agent=has_axi_agent;
    env_cfg.has_ahb_agent=has_ahb_agent;
    env_cfg.has_virtual_sequencer=has_virtual_sequencer;
    env_cfg.has_scoreboard=has_scoreboard;

    env_cfg.has_axi_rst_agent=has_axi_rst_agent;
    env_cfg.has_ahb_rst_agent=has_ahb_rst_agent;

    env_cfg.no_of_axi_agent=no_of_axi_agent;
    env_cfg.no_of_ahb_agent=no_of_ahb_agent;

    env_cfg.no_of_axi_rst_agent=no_of_axi_rst_agent;
    env_cfg.no_of_ahb_rst_agent=no_of_ahb_rst_agent;


    //------------------------------------------
    // AXI AGENT CONFIG
    //------------------------------------------

    if(has_axi_agent)
    begin

      axi_cfg=new[no_of_axi_agent];
      env_cfg.axi_cfg=new[no_of_axi_agent];

      foreach(axi_cfg[i])
      begin

        axi_cfg[i]=axi_agent_config::type_id::create
                   ($sformatf("axi_cfg[%0d]",i));

        if(!uvm_config_db#(virtual axi_if)::get
            (this,"","axi_if",axi_cfg[i].vif))

          `uvm_fatal(get_type_name(),
                     "configuration is not getting properly in test")

        axi_cfg[i].is_active=UVM_ACTIVE;

        env_cfg.axi_cfg[i]=axi_cfg[i];

      end

    end


    //------------------------------------------
    // AXI RESET CONFIG
    //------------------------------------------

    if(has_axi_rst_agent)
    begin

      axi_rst_cfg=new[no_of_axi_rst_agent];
      env_cfg.axi_rst_cfg=new[no_of_axi_rst_agent];

      foreach(axi_rst_cfg[i])
      begin

        axi_rst_cfg[i]=axi_rst_agent_config::type_id::create
                       ($sformatf("axi_rst_cfg[%0d]",i));

        if(!uvm_config_db#(virtual axi_rst_if)::get
            (this,"","axi_rst_if",axi_rst_cfg[i].vif))

          `uvm_fatal(get_type_name(),
                     "configuration is not getting properly in test")

        axi_rst_cfg[i].is_active=UVM_ACTIVE;

        env_cfg.axi_rst_cfg[i]=axi_rst_cfg[i];

      end

    end


    //------------------------------------------
    // AHB AGENT CONFIG
    //------------------------------------------

    if(has_ahb_agent)
    begin

      ahb_cfg=new[no_of_ahb_agent];
      env_cfg.ahb_cfg=new[no_of_ahb_agent];

      foreach(ahb_cfg[i])
      begin

        ahb_cfg[i]=ahb_agent_config::type_id::create
                   ($sformatf("ahb_cfg[%0d]",i));

        if(!uvm_config_db#(virtual ahb_if)::get
            (this,"","ahb_if",ahb_cfg[i].vif))

          `uvm_fatal(get_type_name(),
                     "configuration is not getting properly in test")

        ahb_cfg[i].is_active=UVM_ACTIVE;

        env_cfg.ahb_cfg[i]=ahb_cfg[i];

      end

    end


    //------------------------------------------
    // AHB RESET CONFIG
    //------------------------------------------

    if(has_ahb_rst_agent)
    begin

      ahb_rst_cfg=new[no_of_ahb_rst_agent];
      env_cfg.ahb_rst_cfg=new[no_of_ahb_rst_agent];

      foreach(ahb_rst_cfg[i])
      begin

        ahb_rst_cfg[i]=ahb_rst_agent_config::type_id::create
                       ($sformatf("ahb_rst_cfg[%0d]",i));

        if(!uvm_config_db#(virtual ahb_rst_if)::get
            (this,"","ahb_rst_if",ahb_rst_cfg[i].vif))

          `uvm_fatal(get_type_name(),
                     "configuration is not getting properly in test")

        ahb_rst_cfg[i].is_active=UVM_ACTIVE;

        env_cfg.ahb_rst_cfg[i]=ahb_rst_cfg[i];

      end

    end


    this.randomize() with
    {
      length.size == no_of_transactions;
    };

    foreach(length[i])
    begin
      env_cfg.axi_length.push_back(length[i]);
      env_cfg.ahb_length.push_back(length[i]);
    end

  endfunction


  function void end_of_elaboration_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              "test end_of_elaboration_phase",
              UVM_HIGH)

    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

  endfunction

endclass



class reset_test extends base_test;

  `uvm_component_utils(reset_test)

  axi_rst_vseq axi_rst_vseqh;
  ahb_rst_vseq ahb_rst_vseqh;

  function new(string name="reset_test",
               uvm_component parent);

    super.new(name,parent);

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "reset_test run phase",
              UVM_LOW)

    axi_rst_vseqh=axi_rst_vseq::type_id::create("axi_rst_vseqh");
    ahb_rst_vseqh=ahb_rst_vseq::type_id::create("ahb_rst_vseqh");

    fork
      axi_rst_vseqh.start(envh.vseqrh);
      ahb_rst_vseqh.start(envh.vseqrh);
    join

    phase.drop_objection(this);

  endtask

endclass



class axi_test extends base_test;

  `uvm_component_utils(axi_test)

  axi_vseq axi_vseqh;
  ahb_vseq ahb_vseqh;

  axi_rst_vseq axi_rst_vseqh;
  ahb_rst_vseq ahb_rst_vseqh;

  function new(string name="axi_test",
               uvm_component parent);

    super.new(name,parent);

  endfunction


  function void build_phase(uvm_phase phase);

    super.no_of_transactions=100;

    super.build_phase(phase);

  endfunction


  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(get_type_name(),
              "axi_test run phase",
              UVM_LOW)

    axi_rst_vseqh=axi_rst_vseq::type_id::create("axi_rst_vseqh");
    ahb_rst_vseqh=ahb_rst_vseq::type_id::create("ahb_rst_vseqh");

    fork
      axi_rst_vseqh.start(envh.vseqrh);
      ahb_rst_vseqh.start(envh.vseqrh);
    join

    axi_vseqh=axi_vseq::type_id::create("axi_vseqh");
    ahb_vseqh=ahb_vseq::type_id::create("ahb_vseqh");

    fork
      axi_vseqh.start(envh.vseqrh);
      ahb_vseqh.start(envh.vseqrh);
    join

    phase.drop_objection(this);

  endtask

endclass




/*
class axi_read_test extends base_test;

  `uvm_component_utils(axi_read_test)

  axi_read_vseq axi_read_vseqh;

  function new(string name="axi_read_test",
               uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    super.no_of_transactions = 100;

    super.build_phase(phase);

  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    axi_read_vseqh =
      axi_read_vseq::type_id::create("axi_read_vseqh");

    axi_read_vseqh.start(envh.vseqrh);

    phase.drop_objection(this);

  endtask

endclass




class axi_burst_test extends base_test;

  `uvm_component_utils(axi_burst_test)

  axi_burst_vseq axi_burst_vseqh;

  function new(string name="axi_burst_test",
               uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    super.no_of_transactions = 100;

    super.build_phase(phase);

  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    axi_burst_vseqh =
      axi_burst_vseq::type_id::create("axi_burst_vseqh");

    axi_burst_vseqh.start(envh.vseqrh);

    phase.drop_objection(this);

  endtask

endclass*/


