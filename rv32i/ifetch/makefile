GHDL = ghdl 
FLAGS = --std=08
TESTBENCH_DIR = testbenches


ifetch: 
	@$(GHDL) -a $(FLAGS) $(TESTBENCH_DIR)/ifetch_tb.vhd ifetch.vhd instr_memory.vhd fifo_32b.vhd
	@$(GHDL) -e $(FLAGS) ifetch_tb
	@$(GHDL) -r $(FLAGS) ifetch_tb --wave=wave.ghw --stop-time=1us
	@gtkwave wave.ghw &
clean: 
	@rm -f *.cf
	@rm -f *.ghw
