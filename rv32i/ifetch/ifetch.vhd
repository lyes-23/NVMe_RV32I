library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFetch is
	port(

	-- Decode interface
			dec2if_empty	: in Std_Logic;
			if_pop			: out Std_Logic;
			dec_pc			: in Std_Logic_Vector(31 downto 0) ;

			if_ir				: out Std_Logic_Vector(31 downto 0) ;
			if2dec_empty	: out Std_Logic;
			dec_pop			: in Std_Logic;

	-- global interface
			ck					: in Std_Logic;
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
		din		: in std_logic_vector(31 downto 0);
		dout		: out std_logic_vector(31 downto 0);

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


begin

inst_mem : instr_memory
port map (
    if_adr       => dec_pc,       -- Fetch from program counter (PC)
    if_adr_valid => if_adr_valid,          -- Valid PC request
    ic_inst      => ic_inst,     -- Output fetched instruction
    ic_stall     => ic_stall
);


if2dec : fifo_32b
	port map (	   
        din		    => ic_inst,
		dout		=> if_ir,

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