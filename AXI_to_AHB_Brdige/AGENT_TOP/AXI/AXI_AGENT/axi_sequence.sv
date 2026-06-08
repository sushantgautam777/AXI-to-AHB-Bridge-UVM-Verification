class axi_sequence_base extends uvm_sequence#(axi_trans);

  `uvm_object_utils(axi_sequence_base)
  environment_config env_cfg;
  int temp;
  
  function new(string name="axi_sequence_base");
    super.new(name);
  endfunction
endclass

class axi_seq extends axi_sequence_base;
  `uvm_object_utils(axi_seq);
  function new(string name="axi_seq");
    super.new(name);
  endfunction

  task body();
    req=axi_trans::type_id::create("req");
    if(!(uvm_config_db#(environment_config)::get(null,
                                                 get_full_name(),
                                                 "environment_config",
                                                 env_cfg)))
      `uvm_fatal(get_type_name(),"configuration failed in axi sequence")

    temp=env_cfg.axi_length.pop_front();
    start_item(req);
    assert(req.randomize() with
           {
             awlen==temp;
             arlen==temp;
             arvalid==1;
             awvalid==1;
             wvalid==1;
             awburst inside {[0:1]};
           });
    finish_item(req);
  endtask
endclass

class axi_burst_seq extends axi_sequence_base;
  `uvm_object_utils(axi_burst_seq);
  function new(string name="axi_burst_seq");
    super.new(name);
  endfunction
  task body();
    req=axi_trans::type_id::create("req");
    if(!(uvm_config_db#(environment_config)::get(null,
                                                 get_full_name(),
                                                 "environment_config",
                                                 env_cfg)))
      `uvm_fatal(get_type_name(),"configuration failed in axi sequence")
    temp=env_cfg.axi_length.pop_front();
    start_item(req);
    assert(req.randomize() with
           {
             awlen==temp;
             arlen==temp;
             arvalid==0;
             awvalid==1;
             wvalid==1;
             awburst==2;
           });
    finish_item(req);
  endtask
endclass




class axi_read_seq extends axi_sequence_base;
  `uvm_object_utils(axi_read_seq);
  function new(string name="axi_read_seq");
    super.new(name);
  endfunction


  task body();
    req=axi_trans::type_id::create("req");
    if(!(uvm_config_db#(environment_config)::get(null,get_full_name(),"environment_config",env_cfg)))
      `uvm_fatal(get_type_name(),"configuration failed in axi sequence")
    temp=env_cfg.axi_length.pop_front();
    start_item(req);
    assert(req.randomize() with
           {
             awlen==temp;
             arlen==temp;
             awvalid==0;
             wvalid==0;
             arvalid==1;
             arsize inside {0,1,2,3};
             arburst inside {0,1,2};
           });
    finish_item(req);
  endtask
endclass