LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY fifo_32b IS
	PORT(
		din		    : in std_logic_vector(31 downto 0);
		dout		: out std_logic_vector(31 downto 0);

		push		: in std_logic;
		pop	    	: in std_logic;

		-- flags
		full		: out std_logic;
		empty		: out std_logic;

		reset_n	: in std_logic;
		ck			: in std_logic
	);
END fifo_32b;

architecture archi of fifo_32b is
signal fifo_d : std_logic_vector(31 downto 0);
signal fifo_v : std_logic:='0';

	begin

		process(ck)
			begin
				if rising_edge(ck) then
					if reset_n = '0' then 
						fifo_v <= '0';
					else
						if (fifo_v = '0') then
							-- si la fifo n'est pas valide et que on fait un push elle redevient valide
							if push = '1' then 
								fifo_v <= '1'; 
								fifo_d <= din;
							end if;
						else 
							if (pop = '1') then
								if (push = '0') then	 
							-- si on fait un pop alors que on pas fait de push la fifo devient invalide							
									fifo_v <= '0';
								elsif (push = '1') then
									fifo_d <= din;
								end if;
							end if;
						end if;
					end if;
				end if;

		end process;
	full <= '1' when fifo_v = '1' and pop = '0' else '0';
	empty <= not fifo_v;
	dout <= fifo_d;

end archi;