class ahb_rst_driver extends uvm_driver #(ahb_rst_trans);

  `uvm_component_utils(ahb_rst_driver)

  virtual ahb_rst_if vif;

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      @(vif.drv_cb);
      vif.drv_cb.hresetn <= req.hresetn;

      @(vif.drv_cb);
      vif.drv_cb.hresetn <= 1'b1;

      seq_item_port.item_done();
    end
  endtask

endclass