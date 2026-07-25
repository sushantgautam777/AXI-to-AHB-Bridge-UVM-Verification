class virtual_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(virtual_sequence)

  virtual_sequencer vseqr_h;

  environment_config env_cfg;

  function new(string name="virtual_sequence");
    super.new(name);
  endfunction

  task body();

    if(!$cast(vseqr_h,m_sequencer))
      `uvm_fatal(get_type_name(),
                 "virtual sequencer casting failed");

    if(!(uvm_config_db#(environment_config)::get
        (null,
         get_full_name(),
         "environment_config",
         env_cfg)))
      `uvm_fatal(get_type_name(),
                 "configuration failed in virtual sequence");

  endtask

endclass


//=====================================================
// AXI VIRTUAL SEQUENCE
//=====================================================

class axi_vseq extends virtual_sequence;

  `uvm_object_utils(axi_vseq)

  axi_seq seqh;

  function new(string name="axi_vseq");
    super.new(name);
  endfunction

  task body();

    super.body();

    seqh = axi_seq::type_id::create("seqh");

    seqh.start(vseqr_h.axi_seqrh[0]);

  endtask

endclass


//=====================================================
// AHB VIRTUAL SEQUENCE
//=====================================================

class ahb_vseq extends virtual_sequence;

  `uvm_object_utils(ahb_vseq)

  ahb_seq seqh;

  function new(string name="ahb_vseq");
    super.new(name);
  endfunction

  task body();

    super.body();

    seqh = ahb_seq::type_id::create("seqh");

    seqh.start(vseqr_h.ahb_seqrh[0]);

  endtask

endclass


//=====================================================
// AXI RESET VIRTUAL SEQUENCE
//=====================================================

class axi_rst_vseq extends virtual_sequence;

  `uvm_object_utils(axi_rst_vseq)

  axi_rst_seq seqh;

  function new(string name="axi_rst_vseq");
    super.new(name);
  endfunction

  task body();

    super.body();

    seqh = axi_rst_seq::type_id::create("seqh");

    seqh.start(vseqr_h.axi_rst_seqrh[0]);

  endtask

endclass


//=====================================================
// AHB RESET VIRTUAL SEQUENCE
//=====================================================

class ahb_rst_vseq extends virtual_sequence;

  `uvm_object_utils(ahb_rst_vseq)

  ahb_rst_seq seqh;

  function new(string name="ahb_rst_vseq");
    super.new(name);
  endfunction

  task body();

    super.body();

    seqh = ahb_rst_seq::type_id::create("seqh");

    seqh.start(vseqr_h.ahb_rst_seqrh[0]);

  endtask

endclass
