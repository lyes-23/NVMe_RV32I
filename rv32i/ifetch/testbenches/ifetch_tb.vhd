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
            dec_pc         : in std_logic_vector(31 downto 0);

            if_ir          : out std_logic_vector(31 downto 0);
            if2dec_empty   : out std_logic;
            dec_pop        : in std_logic;

            -- Global interface
            ck             : in std_logic;
            reset_n        : in std_logic
        );
    end component;

  
    signal dec2if_empty_tb : std_logic := '0';  -- Simulating Decode stage readiness
    signal if_pop_tb       : std_logic;
    signal dec_pc_tb       : std_logic_vector(31 downto 0) := (others => '0');

    signal if_ir_tb        : std_logic_vector(31 downto 0);
    signal if2dec_empty_tb : std_logic;
    signal dec_pop_tb      : std_logic := '0';  -- Simulating instruction consumption by Decode

    signal ck_tb           : std_logic := '0';  -- Clock signal
    signal reset_n_tb      : std_logic := '0';  -- Active-low reset

    -- ✅ Clock Process (50 MHz Simulation)
    constant clk_period : time := 20 ns;
    
    begin

    -- ✅ Instantiate `IFetch`
    uut: IFetch
    port map (
        dec2if_empty => dec2if_empty_tb,
        if_pop       => if_pop_tb,
        dec_pc       => dec_pc_tb,
        
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

        -- Test Case 1: Fetch First Instruction
        dec_pc_tb <= x"00000000";  -- Set Program Counter to 0
        dec2if_empty_tb <= '0';    -- Indicate that Decode stage is not empty
        wait for clk_period;

        -- Test Case 2: Fetch Second Instruction
        dec_pc_tb <= x"00000004";  -- Increment PC to fetch next instruction
        wait for clk_period;

        -- Test Case 3: Fetch Third Instruction
        dec_pc_tb <= x"00000008";  -- Increment PC again
        wait for clk_period;

        -- Test Case 4: Simulate Decode Stage Requesting an Instruction
        dec_pop_tb <= '1';
        wait for clk_period;
        dec_pop_tb <= '0';

        -- Test Case 5: Pause Fetching (Decode stage full)
        dec2if_empty_tb <= '1';  -- Simulate Decode stage being full
        wait for clk_period * 2;
        dec2if_empty_tb <= '0';  -- Resume fetching
        wait for clk_period;

        -- End Simulation
        wait for clk_period * 5;
        report "Testbench completed!";
        wait;
    end process;

end Behavioral;
