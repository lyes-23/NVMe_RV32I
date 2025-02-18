library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFetch_tb is
end entity;

architecture Behavioral of IFetch_tb is
    component IFetch
        port(
            -- Decode interface
            dec2if_empty   : in std_logic;
            if_pop         : out std_logic;

            if_ir          : out std_logic_vector(31 downto 0);
            if2dec_empty   : out std_logic;
            dec_pop        : in std_logic;

            -- Global interface
            ck             : in std_logic;
            reset_n        : in std_logic
        );
    end component;

    -- Signal Declarations
    signal dec2if_empty_tb : std_logic := '0';  -- Simulating Decode stage readiness
    signal if_pop_tb       : std_logic;  -- Fetch requests Decode to pop
    signal if_ir_tb        : std_logic_vector(31 downto 0);  -- Output instruction
    signal if2dec_empty_tb : std_logic;  -- FIFO status signal
    signal dec_pop_tb      : std_logic := '0';  -- Simulating instruction consumption by Decode
    signal ck_tb           : std_logic := '0';  -- Clock signal
    signal reset_n_tb      : std_logic := '0';  -- Active-low reset

    --  Clock Process (50 MHz Simulation)
    constant clk_period : time := 20 ns;
    
    begin

    --  Instantiate `IFetch`
    uut: IFetch
    port map (
        dec2if_empty => dec2if_empty_tb,
        if_pop       => if_pop_tb,
       
        
        if_ir        => if_ir_tb,
        if2dec_empty => if2dec_empty_tb,
        dec_pop      => dec_pop_tb,

        ck           => ck_tb,
        reset_n      => reset_n_tb
    );

    -- clock gen 
    clk_process: process
    begin
        while true loop
            ck_tb <= '0';
            wait for clk_period / 2;
            ck_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    
    stim_process: process
    begin
        
        reset_n_tb <= '0';
        wait for clk_period * 2;
        reset_n_tb <= '1';
        wait for clk_period;

         --  Test Case 1: Fetch First Instruction (PC should start at 0)
         report "Test Case 1: Fetch First Instruction (PC = 0x00000000)";
         dec2if_empty_tb <= '0';  -- Indicate that Decode is not full
         wait for clk_period;
 
         --  Test Case 2: Fetch Next Instruction (PC should auto-increment)
         report "Test Case 2: Fetch Second Instruction (PC = 0x00000004)";
         wait for clk_period;
 
         -- Test Case 3: Fetch Third Instruction (PC should auto-increment)
         report "Test Case 3: Fetch Third Instruction (PC = 0x00000008)";
         wait for clk_period;
 
         --  Test Case 4: Decode Requests an Instruction (FIFO Pop)
         dec_pop_tb <= '1';
         wait for clk_period;
         dec_pop_tb <= '0';
 
         -- Test Case 5: Pause Fetching (Decode stage full)
         dec2if_empty_tb <= '1';  -- Simulate Decode stage being full
         wait for clk_period * 2;
         dec2if_empty_tb <= '0'; 
         wait for clk_period;
 
         --  Test Case 6: Multiple Fetch and Pop Cycles
         wait for clk_period;
         dec_pop_tb <= '1';
         wait for clk_period;
         dec_pop_tb <= '0';
         wait for clk_period;
         dec_pop_tb <= '1';
         wait for clk_period;
         dec_pop_tb <= '0';
 
         -- End Simulation
         wait for clk_period * 5;
         report "Testbench completed!";
         wait;
     end process;
 
end Behavioral;
