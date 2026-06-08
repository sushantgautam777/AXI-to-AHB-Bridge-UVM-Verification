class ahb_rst_sequence_base extends uvm_sequence#(ahb_rst_trans);
  `uvm_object_utils(ahb_rst_sequence_base)
  extern function new(string name="ahb_rst_sequence_base");
endclass
//-------------------------------- new --------------------------------//
function ahb_rst_sequence_base::new(string name="ahb_rst_sequence_base");
  super.new(name);
endfunction
//=====================================================================//
class ahb_rst_seq extends ahb_rst_sequence_base;
  `uvm_object_utils(ahb_rst_seq)
  extern function new(string name="ahb_rst_seq");
  extern task body();
endclass
//-------------------------------- new --------------------------------//
function ahb_rst_seq::new(string name="ahb_rst_seq");
  super.new(name);
endfunction
//-------------------------------- body --------------------------------//
task ahb_rst_seq::body();
  req = ahb_rst_trans::type_id::create("req");
  start_item(req);
  assert(req.randomize() with {hresetn==1'b0;});
  finish_item(req);
endtask