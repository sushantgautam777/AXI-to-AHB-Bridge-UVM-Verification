class ahb_rst_trans extends uvm_sequence_item;
 `uvm_object_utils(ahb_rst_trans)
  rand bit hresetn;
  logic [1:0] htrans;
  bit hready;
  extern function new(string name="ahb_rst_trans");
  extern function void do_print(uvm_printer printer);

endclass


//-------------------------------- new --------------------------------//
function ahb_rst_trans::new(string name="ahb_rst_trans");

  super.new(name);

endfunction
//-------------------------------- do_print --------------------------------//
function void ahb_rst_trans::do_print(uvm_printer printer);

  printer.print_field("hresetn",this.hresetn,1,UVM_DEC);
endfunction