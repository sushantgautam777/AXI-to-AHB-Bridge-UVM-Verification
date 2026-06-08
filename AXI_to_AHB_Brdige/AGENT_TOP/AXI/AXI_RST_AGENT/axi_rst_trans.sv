class axi_rst_trans extends uvm_sequence_item;

  `uvm_object_utils(axi_rst_trans)

  rand bit aresetn;
  logic bvalid;
  logic rvalid;

  function new(string name="axi_rst_trans");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    printer.print_field("aresetn", aresetn, 1, UVM_DEC);
    printer.print_field("bvalid", bvalid, 1, UVM_DEC);
    printer.print_field("rvalid", rvalid, 1, UVM_DEC);
  endfunction

endclass