class ahb_sequence_base extends uvm_sequence #(ahb_trans);

  `uvm_object_utils(ahb_sequence_base)

  environment_config env_cfg;


  function new(string name="ahb_sequence_base");

    super.new(name);

  endfunction

endclass




class ahb_seq extends ahb_sequence_base;

  `uvm_object_utils(ahb_seq)


  function new(string name="ahb_seq");

    super.new(name);

  endfunction



  task body();

    req = ahb_trans::type_id::create("req");


    if(!(uvm_config_db#(environment_config)::get
       (null,
        get_full_name(),
        "environment_config",
        env_cfg)))

      `uvm_fatal(get_type_name(),
                 "configuration fail in ahb_sequence")



    repeat((2*(env_cfg.ahb_length.pop_front())))
    begin

      start_item(req);

      assert(req.randomize() with
      {
        delay_cycles == 2;
      });

      finish_item(req);

    end

  endtask

endclass





class ahb_read_seq extends ahb_sequence_base;

  `uvm_object_utils(ahb_read_seq)



  function new(string name="ahb_read_seq");

    super.new(name);

  endfunction



  task body();

    req = ahb_trans::type_id::create("req");


    if(!(uvm_config_db#(environment_config)::get
       (null,
        get_full_name(),
        "environment_config",
        env_cfg)))

      `uvm_fatal(get_type_name(),
                 "configuration fail in ahb_sequence")



    repeat((2*(env_cfg.ahb_length.pop_front())))
    begin

      start_item(req);

      assert(req.randomize() with
      {
        hwrite == 1'b0;
      });

      finish_item(req);

    end

  endtask

endclass