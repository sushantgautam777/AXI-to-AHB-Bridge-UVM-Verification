SIMULATOR = Questa

# ---------------- SOURCE FILES ----------------
# Interfaces (in AXI2AHB_RTL folder)
RTL_IF = ../AXI2AHB_RTL/axi_rst_interface.sv \
         ../AXI2AHB_RTL/ahb_rst_interface.sv  \
         ../AXI2AHB_RTL/axi_interface.sv      \
         ../AXI2AHB_RTL/ahb_interface.sv

# DUT RTL files (in AXI2AHB_RTL folder)
RTL_DUT = ../AXI2AHB_RTL/addr_fifo.v         \
          ../AXI2AHB_RTL/data_fifo.v          \
          ../AXI2AHB_RTL/id_resp_fifo.v       \
          ../AXI2AHB_RTL/id_send_fifo.v       \
          ../AXI2AHB_RTL/rdata_fifo.v         \
          ../AXI2AHB_RTL/resp_fifo.v          \
          ../AXI2AHB_RTL/size_fifo.v          \
          ../AXI2AHB_RTL/write_fifo.v         \
          ../AXI2AHB_RTL/fifo_wrapper.v       \
          ../AXI2AHB_RTL/axi2fifo.v           \
          ../AXI2AHB_RTL/fifo2axi.v           \
          ../AXI2AHB_RTL/axi_controller.v     \
          ../AXI2AHB_RTL/ahb_controller.v     \
          ../AXI2AHB_RTL/axi2ahb_bridge_top.v

# Top testbench module
SVTB1 = ../AXI2AHB_RTL/top.sv

# UVM package (includes all TB classes)
SVTB2 = ../test/pkg.sv

# Include directories
INC   = +incdir+../AXI2AHB_RTL   \
        +incdir+../AXI_AGENT      \
        +incdir+../AHB_AGENT      \
        +incdir+../AXI_RST_AGENT  \
        +incdir+../AHB_RST_AGENT  \
        +incdir+../tb             \
        +incdir+../test

work = work

# ---------------- OPTIONS ----------------
VSIMOPT  = -vopt -voptargs=+acc
VSIMCOV  = -coverage

# ---------------- COVERAGE ----------------
VSIMBATCH = -c -do "log -r /*; coverage save -onexit cov_all; run -all; exit"

# ---------------- CLEAN ----------------
clean:
	rm -rf work transcript* *.log *.wlf modelsim.ini cov* *.ucdb covhtmlreport
	clear

# ---------------- COMPILE ----------------
compile:
	vlib $(work)
	vmap work $(work)
	vlog -sv -mfcu +cover -work $(work) \
	     $(RTL_IF)  \
	     $(RTL_DUT) \
	     $(INC)     \
	     $(SVTB2)   \
	     $(SVTB1)

# ==================================================
# INDIVIDUAL TESTS
# ==================================================
run_write: compile
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH) \
	work.axi2ahb_bridge_tb_top +UVM_TESTNAME=write_test \
	+UVM_VERBOSITY=UVM_LOW -l write.log

run_read: compile
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH) \
	work.axi2ahb_bridge_tb_top +UVM_TESTNAME=read_test \
	+UVM_VERBOSITY=UVM_LOW -l read.log

run_burst_write: compile
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH) \
	work.axi2ahb_bridge_tb_top +UVM_TESTNAME=burst_write_test \
	+UVM_VERBOSITY=UVM_LOW -l burst_write.log

# ==================================================
# REGRESSION
# ==================================================
regress:
	make clean
	make compile
	make run_write
	make run_read
	make run_burst_write
	make report
	make cov

# ==================================================
# COVERAGE REPORT
# ==================================================
report:
	vcover report -cvg -details -html cov_all

cov:
	firefox file://$(PWD)/covhtmlreport/index.html &