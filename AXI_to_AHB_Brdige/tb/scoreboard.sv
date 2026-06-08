class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(axi_rst_trans) fifo_axi_rst_h[];
  uvm_tlm_analysis_fifo #(ahb_rst_trans) fifo_ahb_rst_h[];
  uvm_tlm_analysis_fifo #(axi_trans)     fifo_axi_h[];
  uvm_tlm_analysis_fifo #(ahb_trans)     fifo_ahb_h[];
  uvm_tlm_analysis_fifo #(axi_trans)     fifo_axi_wdata_h[];
  uvm_tlm_analysis_fifo #(axi_trans)     fifo_axi_rdata_h[];

  axi_trans wdata[$], rdata[$];

  axi_rst_trans axi_rst_xtn;
  axi_rst_trans axi_rst_cov_data;

  ahb_rst_trans ahb_rst_xtn;
  ahb_rst_trans ahb_rst_cov_data;

  axi_trans axi_xtn;
  axi_trans axi_wdata;
  axi_trans axi_rdata;
  axi_trans axi_cov_data;

  ahb_trans ahb_cov_data;
  ahb_trans ahb_xtn;

  environment_config env_cfg;

  //---------------------------------------
  // AXI RESET COVERAGE
  //-----------------------------------------

  covergroup axi_rst_cg;
    option.per_instance = 1;
    CP_A_RESETN : coverpoint axi_rst_cov_data.aresetn{bins RST[] = {0,1};}
  endgroup

  //-----------------------------------------
  // AHB RESET COVERAGE
  //-----------------------------------------
  covergroup ahb_rst_cg;
    option.per_instance = 1;
    CP_H_RESETN : coverpoint ahb_rst_cov_data.hresetn{bins RST[] = {0,1};}
  endgroup
  //-----------------------------------------
  // AXI COVERAGE
  //-----------------------------------------
  covergroup axi_cg;
    option.per_instance = 1;
    CP_AW_ID : coverpoint axi_cov_data.awid{bins low = {[0:$]};}
    CP_AW_ADDR : coverpoint axi_cov_data.awaddr{
      bins first_slave  = {[32'h0000_0000 : 32'h4444_4444]};
      bins second_slave = {[32'h4444_4445 : 32'h8888_8888]};
      bins third_slave  = {[32'h8888_8889 : 32'hcccc_cccc]};
      bins fourth_slave = {[32'hcccc_cccd : 32'hffff_ffff]};
    }

    CP_AWLEN : coverpoint axi_cov_data.awlen {
  bins aw_short  = {[1:4]};
  bins aw_mid = {[5:10]};
  bins aw_long   = {[11:15]};
}

CP_ARLEN : coverpoint axi_cov_data.arlen {
  bins ar_short  = {[1:4]};
  bins ar_mid = {[5:10]};
  bins ar_long   = {[11:15]};
}
   // CP_AWLEN   : coverpoint axi_cov_data.awlen   { bins AW_LEN[]   = {[1:15]}; }
    CP_AWSIZE  : coverpoint axi_cov_data.awsize  { bins AW_SIZE[]  = {0,1,2,3}; }
    CP_AWBURST : coverpoint axi_cov_data.awburst { bins AW_BURST[] = {[0:2]}; }
    CP_W_ID : coverpoint axi_cov_data.wid{bins low = {[0:$]};}
    CP_W_LAST : coverpoint axi_cov_data.wlast{ bins W_LAST[] = {0,1};}
    CP_B_ID : coverpoint axi_cov_data.bid{bins low = {[0:$]};}
    CP_BRESP : coverpoint axi_cov_data.bresp{bins B_BRESP[] = {0,1};}
    CP_AR_ID : coverpoint axi_cov_data.arid{ bins low = {[0:$]};}
    CP_AR_ADDR : coverpoint axi_cov_data.araddr{bins slave_addr = {[32'h0000_0000 : 32'hffff_ffff]};}
   // CP_ARLEN   : coverpoint axi_cov_data.arlen   { bins AR_LEN[]   = {[1:15]}; }
    CP_ARSIZE  : coverpoint axi_cov_data.arsize  { bins AR_SIZE[]  = {0,1,2,3}; }
    CP_ARBURST : coverpoint axi_cov_data.arburst { bins AR_BURST[] = {[0:2]}; }
    CP_R_ID : coverpoint axi_cov_data.rid{bins low = {[0:$]};}
    CP_R_LAST : coverpoint axi_cov_data.rlast{bins R_LAST[] = {0,1};}


    //-----------------------------------
  // Cross Coverage
  //-----------------------------------

  CROSS_AW : cross CP_AWSIZE, CP_AWBURST;

  CROSS_AR : cross CP_ARSIZE, CP_ARBURST;


 endgroup
  //-----------------------------------------
  // AXI WRITE DATA COVERAGE
  //-----------------------------------------
  covergroup axi_wdata_dyn_cg with function sample(int i);
    CP_W_DATA : coverpoint axi_cov_data.wdata[i]{
      bins wdata =
      {[64'h0000_0000_0000_0000 : 64'hffff_ffff_ffff_ffff]};
    }

   CP_W_STRB : coverpoint axi_cov_data.wstrb[i] {
  bins strb_low  = {[1:15]};
  bins strb_mid  = {[16:127]};
  bins strb_high = {[128:255]};
}


//    CP_W_STRB : coverpoint axi_cov_data.wstrb[i]{bins W_STRB[] ={1,2,4,8,16,32,64,128,3,12,48,192,15,240,255};}
  endgroup
  //-----------------------------------------
  // AXI READ DATA COVERAGE
  //-----------------------------------------
/*  covergroup axi_rdata_dyn_cg with function sample(int i);
    CP_R_DATA : coverpoint axi_cov_data.rdata[i]{bins rdata = {[64'h0000_0000_0000_0000 : 64'hffff_ffff_ffff_ffff]};}
    CP_RRESP : coverpoint axi_cov_data.rresp[i]{ bins RRESP[] = {0};}
  endgroup*/
  //-----------------------------------------
  // AHB COVERAGE
  //-----------------------------------------
  covergroup ahb_cg;
    option.per_instance = 1;
    CP_HADDR : coverpoint ahb_cov_data.haddr{
      bins first_slave  = {[32'h0000_0000 : 32'h4444_4444]};
      bins second_slave = {[32'h4444_4445 : 32'h8888_8888]};
      bins third_slave  = {[32'h8888_8889 : 32'hcccc_cccc]};
      bins fourth_slave = {[32'hcccc_cccd : 32'hffff_ffff]};
    }

    CP_HWRITE : coverpoint ahb_cov_data.hwrite{bins HWRITE[] = {0,1};}
    CP_HSIZE : coverpoint ahb_cov_data.hsize{ bins H_SIZE[] = {0,1,2,3};}
    CP_HREADY : coverpoint ahb_cov_data.hready{bins H_READY[] = {1};}
    CP_HRESP : coverpoint ahb_cov_data.hresp{ bins H_RESP[] = {0,1};}
    CP_HWDATA : coverpoint ahb_cov_data.hwdata{bins ahb_wdata ={[64'h0000_0000_0000_0000 : 64'hffff_ffff_ffff_ffff]};}
    CP_HRDATA : coverpoint ahb_cov_data.hrdata{bins ahb_rdata ={[64'h0000_0000_0000_0000 : 64'hffff_ffff_ffff_ffff]};}
  endgroup
  //-----------------------------------------
  // CONSTRUCTOR
  //-----------------------------------------
  function new(string name="scoreboard", uvm_component parent);
    super.new(name,parent);
    axi_cg          = new();
    axi_rst_cg      = new();
    ahb_cg          = new();
    ahb_rst_cg      = new();
    axi_wdata_dyn_cg = new();
   // axi_rdata_dyn_cg = new();
  endfunction
  //-----------------------------------------
  // BUILD PHASE
  //-----------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(environment_config)::get(this,"","environment_config",env_cfg))
    `uvm_fatal(get_type_name(),"configuration is not set properly")

    fifo_axi_rst_h = new[env_cfg.no_of_axi_rst_agent];
    fifo_ahb_rst_h = new[env_cfg.no_of_ahb_rst_agent];
    fifo_axi_h     = new[env_cfg.no_of_axi_agent];
    fifo_axi_wdata_h = new[env_cfg.no_of_axi_agent];
    fifo_axi_rdata_h = new[env_cfg.no_of_axi_agent];
    fifo_ahb_h     = new[env_cfg.no_of_ahb_agent];

    foreach(fifo_axi_rst_h[i])
      fifo_axi_rst_h[i] =new($sformatf("fifo_axi_rst_h[%0d]",i),this);

    foreach(fifo_ahb_rst_h[i])
      fifo_ahb_rst_h[i] =new($sformatf("fifo_ahb_rst_h[%0d]",i),this);

    foreach(fifo_axi_h[i])
      fifo_axi_h[i] =new($sformatf("fifo_axi_h[%0d]",i),this);

    foreach(fifo_axi_wdata_h[i])
      fifo_axi_wdata_h[i] =new($sformatf("fifo_axi_wdata_h[%0d]",i),this);

    foreach(fifo_axi_rdata_h[i])
      fifo_axi_rdata_h[i] =new($sformatf("fifo_axi_rdata_h[%0d]",i),this);

    foreach(fifo_ahb_h[i])
      fifo_ahb_h[i] =new($sformatf("fifo_ahb_h[%0d]",i),this);

  endfunction

  //-----------------------------------------
  // RUN PHASE (VISIBLE PART)
  //-----------------------------------------

  task run_phase(uvm_phase phase);

    fork
      begin
        forever begin
          fifo_axi_rst_h[0].get(axi_rst_xtn);
          axi_rst_check(axi_rst_xtn);
          axi_rst_cov_data =  axi_rst_xtn;
          axi_rst_cg.sample();
        end
      end

      begin
        forever begin
          fifo_ahb_rst_h[0].get(ahb_rst_xtn);
          ahb_rst_check(ahb_rst_xtn);
          ahb_rst_cov_data =  ahb_rst_xtn;
          ahb_rst_cg.sample();
        end
      end

      begin
        forever begin
          fifo_axi_h[0].get(axi_xtn);
          axi_cov_data =  axi_xtn;



          `uvm_info("AXI_COV",
$sformatf("AWADDR=%h AWLEN=%0d AWSIZE=%0d AWBURST=%0d",
axi_cov_data.awaddr,
axi_cov_data.awlen,
axi_cov_data.awsize,
axi_cov_data.awburst),
UVM_LOW)



          axi_cg.sample();

          foreach(axi_cov_data.wdata[i])
            axi_wdata_dyn_cg.sample(i);

          foreach(axi_cov_data.rdata[i])
                  begin
  `uvm_info("AXI_RDATA_COV",
            $sformatf("Sampling RDATA[%0d]=%h",
                       i,
                       axi_cov_data.rdata[i]),
            UVM_LOW)
//            axi_rdata_dyn_cg.sample(i);
    end
        end
      end

      begin
        forever begin
          fifo_ahb_h[0].get(ahb_xtn);
          ahb_cov_data =  ahb_xtn;
          data_compare(ahb_xtn);




`uvm_info("AHB_COV",
$sformatf("HADDR=%h HSIZE=%0d HWRITE=%0d HRESP=%0d",
ahb_cov_data.haddr,
ahb_cov_data.hsize,
ahb_cov_data.hwrite,
ahb_cov_data.hresp),
UVM_LOW)



          ahb_cg.sample();
        end
      end

      begin
        forever begin
          fifo_axi_wdata_h[0].get(axi_wdata);
       `uvm_info("SB_FIFO", $sformatf("RECEIVED %h", axi_wdata.temp_wdata), UVM_LOW)

          wdata.push_back(axi_wdata);
        end
      end

      begin
        forever begin
          fifo_axi_rdata_h[0].get(axi_rdata);

                 `uvm_info("SB_RDATA_FIFO",
              $sformatf("Received RDATA transaction, size=%0d",
                        axi_rdata.rdata.size()),
              UVM_LOW)

          rdata.push_back(axi_rdata);
        end
      end
    join
  endtask

  //-----------------------------------------
  // RESET CHECKS
  //-----------------------------------------

  task axi_rst_check(axi_rst_trans axi_rst_xtn);
    if(axi_rst_xtn.aresetn == 1'b0)
    begin
      if(axi_rst_xtn.bvalid == 1'b0 &&
         axi_rst_xtn.rvalid == 1'b0)
        `uvm_info(get_type_name(), "axi reset operation is successful", UVM_LOW)
      else
        `uvm_error(get_type_name(), "axi reset operation is not successful")
    end

  endtask
  task ahb_rst_check(ahb_rst_trans ahb_rst_xtn);
    if(ahb_rst_xtn.hresetn == 1'b0)
    begin
      if(ahb_rst_xtn.htrans == 2'b00)
        `uvm_info(get_type_name(),"ahb reset operation successful", UVM_LOW)
      else
        `uvm_error(get_type_name(), "ahb reset operation not successful");
    end
  endtask

  //-----------------------------------------
  // DATA COMPARE
  //-----------------------------------------
  task data_compare(ahb_trans ahb_xtn);
  axi_trans axi_xtn;
  if(ahb_xtn.hwrite == 1)
  begin
    wait(wdata.size() != 0);
    axi_xtn = wdata.pop_front();
`uvm_info("COMPARE",$sformatf("AXI=%h  AHB=%h", axi_xtn.temp_wdata, ahb_xtn.hwdata),UVM_LOW)
`uvm_info("SB_POP", $sformatf("POPPED %h",  axi_xtn.temp_wdata), UVM_LOW)


    if(axi_xtn.temp_wdata == ahb_xtn.hwdata)
    begin
      `uvm_info(get_type_name(), "data is matched", UVM_LOW)
      `uvm_info(get_type_name(),
                $sformatf("axi_temporary_wdata: %0d , ahb_hwdata: %0d", axi_xtn.temp_wdata, ahb_xtn.hwdata), UVM_LOW)
    end
    else
    begin
      `uvm_error(get_type_name(),"data is mismatched")
    end
  end

  else
  begin
    wait(rdata.size() != 0);
    axi_xtn = rdata.pop_front();
    if(axi_xtn.temp_rdata == ahb_xtn.hrdata)
    begin
      `uvm_info(get_type_name(),"data is matched",UVM_LOW)

      `uvm_info(get_type_name(),
             $sformatf("axi_temporary_rdata: %0d , ahb_hrdata: %0d",axi_xtn.temp_rdata,ahb_xtn.hrdata),UVM_LOW)
    end
    else
    begin
      `uvm_error(get_type_name(),"data is mismatched")
    end
  end
endtask
endclass
