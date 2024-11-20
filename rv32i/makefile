GHDL = ghdl 
FLAGS = --std=08
TESTBENCH_DIR = testbenches

alu: 
	@$(GHDL) -a $(FLAGS) $(TESTBENCH_DIR)/alu_tb.vhd alu.vhd 
	@$(GHDL) -e $(FLAGS) alu_tb
	@$(GHDL) -r $(FLAGS) alu_tb --wave=wave.ghw --stop-time=1us
	@gtkwave wave.ghw &
clean: 
	@rm -f *.cf
	@rm -f *.ghw
