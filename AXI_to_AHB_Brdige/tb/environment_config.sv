class environment_config extends uvm_object;

  `uvm_object_utils(environment_config)

  bit has_axi_agent=1'b1;
  bit has_ahb_agent=1'b1;
  bit has_virtual_sequencer=1'b0;
  bit has_scoreboard=1'b1;
  bit has_axi_rst_agent=1'b1;
  bit has_ahb_rst_agent=1'b1;

  int no_of_axi_agent=1;
  int no_of_ahb_agent=1;
  int no_of_axi_rst_agent=1;
  int no_of_ahb_rst_agent=1;

  axi_agent_config axi_cfg[];
  ahb_agent_config ahb_cfg[];
  axi_rst_agent_config axi_rst_cfg[];
  ahb_rst_agent_config ahb_rst_cfg[];

  int ahb_length[$];
  int axi_length[$];
  extern function new(string name="environment_config");
endclass

function environment_config::new(string name="environment_config");
  super.new(name);
endfunction
