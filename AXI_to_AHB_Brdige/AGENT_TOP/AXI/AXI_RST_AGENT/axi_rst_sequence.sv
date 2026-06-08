class axi_rst_sequence_base extends uvm_sequence#(axi_rst_trans);
  `uvm_object_utils(axi_rst_sequence_base)
  extern function new(string name="axi_rst_sequence_base");
endclass
//-------------------------------- new --------------------------------//
function axi_rst_sequence_base::new(string name="axi_rst_sequence_base");
  super.new(name);
endfunction
//=====================================================================//
//reset sequence
class axi_rst_seq extends axi_rst_sequence_base;
  `uvm_object_utils(axi_rst_seq)

  extern function new(string name="axi_rst_seq");
  extern task body();
endclass

//-------------------------------- new --------------------------------//
function axi_rst_seq::new(string name="axi_rst_seq");
  super.new(name);
endfunction

//-------------------------------- body --------------------------------//
task axi_rst_seq::body();
  req = axi_rst_trans::type_id::create("req");
  start_item(req);
  assert(req.randomize() with {aresetn==1'b0;});
  finish_item(req);
endtask