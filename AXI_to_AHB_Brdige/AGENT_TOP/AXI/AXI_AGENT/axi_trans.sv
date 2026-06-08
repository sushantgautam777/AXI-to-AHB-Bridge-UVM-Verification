class axi_trans extends uvm_sequence_item;

  `uvm_object_utils(axi_trans)

  rand bit aresetn;
  rand bit [7:0] awid;
  rand bit [31:0] awaddr;
  rand bit [7:0] awlen;
  rand bit [2:0] awsize;
  rand bit [1:0] awburst;
  rand bit awvalid;
  bit awready;
  rand bit [7:0] wid;
  rand bit [63:0] wdata[];
  bit [7:0] wstrb[];
  bit wlast;
  rand bit wvalid;
  bit wready;
  rand bit [7:0] arid;
  rand bit [31:0] araddr;
  rand bit [7:0] arlen;
  rand bit [2:0] arsize;
  rand bit [1:0] arburst;
  rand bit arvalid;
  bit arready;
  bit [7:0] bid;
  bit [1:0] bresp;
  bit bvalid;
  bit bready;
  bit [7:0] rid;
  bit [63:0] rdata[];
  bit [1:0] rresp[];
  bit rlast;
  bit rvalid;
  bit rready;
  bit [63:0] temp_wdata;
  bit [63:0] temp_rdata;
  int delay_cycles;

  constraint write_id_c{awid == wid;bid  == wid;}
  constraint read_id_c{rid == arid;}
  constraint arburst_c{arburst inside {0,1,2};}
  constraint awburst_c{awburst inside {0,1,2};}
  constraint arsize_c{arsize inside {0,1,2,3};}
  constraint awsize_c{awsize inside {0,1,2,3};}
  constraint write_align{(((awburst == 2'b10) || awburst==2'b00) && awsize == 1)-> awaddr%2 == 0;}
  constraint write_align2{((awburst == 2'b10) && awsize == 2)-> awaddr%4 == 0;}
  constraint write_align3{((awburst == 2'b10) && awsize == 3)-> awaddr%8 == 0;}
  constraint read_align1{((arburst == 2'b10) && arsize == 1)-> araddr%2 == 0;}
  constraint read_align2{((arburst == 2'b10) && arsize == 2)-> araddr%4 == 0;}
  constraint read_align3{((arburst == 2'b10) && arsize == 3)-> araddr%8 == 0;}
  constraint wdat_c  {wdata.size == awlen+1;}

  function new(string name="axi_trans");
    super.new(name);
  endfunction

  function void post_randomize();
    int j=0;
    bit [31:0] start_address=awaddr;
    int number_of_bytes=2**awsize;
    int burst_length=awlen+1;
    bit[31:0] aligned_address =
      (start_address/number_of_bytes)*number_of_bytes;
    wstrb=new[awlen+1];
    for(int i=(start_address%8);
            i<((aligned_address%8)+number_of_bytes);
            i++)
    begin
      wstrb[j][i]=1'b1;
    end

    for(int l=1;l<burst_length;l++)
    begin
      aligned_address=aligned_address+number_of_bytes;
      j++;
      for(int k=(aligned_address%8);
              k<((aligned_address%8)+number_of_bytes);
              k++)
        wstrb[j][k]=1'b1;
    end
  endfunction


  function void do_print(uvm_printer printer);
   super.do_print(printer);

   // reset
   printer.print_field("aresetn", aresetn, 1, UVM_BIN);

   // write address channel
   printer.print_field("awid", awid, 8, UVM_DEC);
   printer.print_field("awaddr", awaddr, 32, UVM_HEX);
   printer.print_field("awburst", awburst, 2, UVM_BIN);
   printer.print_field("awlen", awlen, 8, UVM_DEC);
   printer.print_field("awsize", awsize, 3, UVM_DEC);
   printer.print_field("awvalid", awvalid, 1, UVM_BIN);
   printer.print_field("awready", awready, 1, UVM_BIN);

   // write data channel
   printer.print_field("wid", wid, 8, UVM_DEC);

   printer.print_array_header("wdata", wdata.size());
   foreach(wdata[i])
      printer.print_field($sformatf("wdata[%0d]", i),
                           wdata[i],
                           64,
                           UVM_HEX);
   printer.print_array_footer();

   printer.print_array_header("wstrb", wstrb.size());
   foreach(wstrb[i])
      printer.print_field($sformatf("wstrb[%0d]", i),
                           wstrb[i],
                           8,
                           UVM_HEX);
   printer.print_array_footer();

   printer.print_field("wvalid", wvalid, 1, UVM_BIN);
   printer.print_field("wready", wready, 1, UVM_BIN);
   printer.print_field("wlast", wlast, 1, UVM_BIN);

   // write response channel
   printer.print_field("bresp", bresp, 2, UVM_BIN);
   printer.print_field("bvalid", bvalid, 1, UVM_BIN);
   printer.print_field("bready", bready, 1, UVM_BIN);
   printer.print_field("bid", bid, 8, UVM_DEC);

   // read address channel
   printer.print_field("arid", arid, 8, UVM_DEC);
   printer.print_field("araddr", araddr, 32, UVM_HEX);
   printer.print_field("arburst", arburst, 2, UVM_BIN);
   printer.print_field("arlen", arlen, 8, UVM_DEC);
   printer.print_field("arsize", arsize, 3, UVM_DEC);
   printer.print_field("arvalid", arvalid, 1, UVM_BIN);
   printer.print_field("arready", arready, 1, UVM_BIN);

   // read data channel
   printer.print_field("rid", rid, 8, UVM_DEC);

   printer.print_array_header("rdata", rdata.size());
   foreach(rdata[i])
      printer.print_field($sformatf("rdata[%0d]", i),
                           rdata[i],
                           64,
                           UVM_HEX);
   printer.print_array_footer();

   printer.print_array_header("rresp", rresp.size());
   foreach(rresp[i])
      printer.print_field($sformatf("rresp[%0d]", i),
                           rresp[i],
                           2,
                           UVM_BIN);
   printer.print_array_footer();

   printer.print_field("rvalid", rvalid, 1, UVM_BIN);
   printer.print_field("rready", rready, 1, UVM_BIN);
   printer.print_field("rlast", rlast, 1, UVM_BIN);

   // temporary variables
   printer.print_field("temp_wdata", temp_wdata, 64, UVM_HEX);
   printer.print_field("temp_rdata", temp_rdata, 64, UVM_HEX);

   // misc
   printer.print_int("delay_cycles", delay_cycles, 32, UVM_DEC);

endfunction
endclass