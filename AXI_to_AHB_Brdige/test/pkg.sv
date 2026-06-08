package axi2ahb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // ================================================
    // AXI AGENT
    // ================================================
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_trans.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_agent_config.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_sequencer.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_driver.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_monitor.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_sequence.sv"
    `include "../AGENT_TOP/AXI/AXI_AGENT/axi_agent.sv"

    // ================================================
    // AHB AGENT
    // ================================================
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_trans.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_agent_config.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_sequencer.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_driver.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_monitor.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_sequence.sv"
    `include "../AGENT_TOP/AHB/AHB_AGENT/ahb_agent.sv"

    // ================================================
    // AXI RESET AGENT
    // ================================================
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_trans.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_agent_config.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_sequencer.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_driver.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_monitor.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_sequence.sv"
    `include "../AGENT_TOP/AXI/AXI_RST_AGENT/axi_rst_agent.sv"

    // ================================================
    // AHB RESET AGENT
    // ================================================
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_trans.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_agent_config.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_sequencer.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_driver.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_monitor.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_sequence.sv"
    `include "../AGENT_TOP/AHB/AHB_RST_AGENT/ahb_rst_agent.sv"

    // ================================================
    // TB COMPONENTS
    // ================================================
    `include "../tb/environment_config.sv"
    `include "../tb/scoreboard.sv"
    `include "../tb/virtual_sequencer.sv"
    `include "../tb/virtual_sequence.sv"
    `include "../tb/environment.sv"

    // ================================================
    // TESTS
    // ================================================
    `include "../test/test.sv"

endpackage
