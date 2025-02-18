library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFetch is
	port(

	-- Decode interface
			dec2if_empty	: in Std_Logic;
			if_pop			: out Std_Logic;

			
			if2dec_empty	: out Std_Logic;
			dec_pop			: in Std_Logic;

			if_ir			: out Std_Logic_Vector(31 downto 0) ;
			PC 				: out std_logic_vector(31 downto 0);
			NPC			    : out std_logic_vector(31 downto 0);

	-- global interface
			ck			    : in Std_Logic;
			reset_n			: in Std_Logic
            );
end IFetch;

----------------------------------------------------------------------

architecture Behavior OF IFetch is

component instr_memory
    port (
        if_adr       : in std_logic_vector(31 downto 0);
        if_adr_valid : in std_logic;
        ic_stall    : out std_logic;
        ic_inst      : out std_logic_vector(31 downto 0)
    );
end component;

component fifo_32b
	port(
		din		: in std_logic_vector(95 downto 0);
		dout		: out std_logic_vector(95 downto 0);

		-- commands
		push		: in std_logic;
		pop		: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic
	);
end component;

signal if2dec_push	: std_logic;
signal if2dec_full	: std_logic;
signal if_adr_valid    : std_logic;
signal ic_inst   : std_logic_vector(31 downto 0); -- Stores fetched instruction
signal ic_stall  : std_logic;                      -- Stall signal 
signal pc           : std_logic_vector(31 downto 0);
signal next_pc      : std_logic_vector(31 downto 0);



begin

------------------------------------------------------
---------------- PC incrementer + 4 ----------------
------------------------------------------------------
process(ck)
begin
    if rising_edge(ck) then
        if reset_n = '0' then
            pc <= (others => '0');
        elsif (if2dec_full = '0' and ic_stall = '0' and dec2if_empty = '0') then
            pc <= next_pc; 
        end if;
    end if;
end process;
next_pc <= std_logic_vector(unsigned(pc) + 4); 

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

inst_mem : instr_memory
port map (
    if_adr       => pc,       -- fetch from pc
    if_adr_valid => if_adr_valid,    -- valid pc
    ic_inst      => ic_inst,     -- fetched instruction
    ic_stall     => ic_stall
);


if2dec : fifo_32b
	port map (	   
        din	(31 downto 0)	    => ic_inst,
		din	(63 downto 32)		=> pc,
		din (95 downto 64)		=> next_pc,

		dout (31 downto 0)		=> if_ir,
		dout (63 downto 32)		=> PC,
		dout (95 downto 64)		=> NPC,

        push	    => if2dec_push,
        pop		    => dec_pop,
        
        empty		 => if2dec_empty,
        full		 => if2dec_full,

        reset_n	 => reset_n,
        ck			 => ck
                    );


	if_adr_valid <= '1' when dec2if_empty = '0' else '0';
	if_pop <= '1' when dec2if_empty = '0' and ic_stall = '0' and if2dec_full = '0' else '0';
	if2dec_push <= '1' when dec2if_empty = '0' and ic_stall = '0' and if2dec_full = '0' else '0';

	

end Behavior;