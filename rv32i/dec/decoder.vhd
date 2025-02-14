library ieee; 
use work.common.all;
use ieee.std_logic_1164.all;

entity decoder is 
port(
	instr: in std_logic_vector(31 downto 0);
	Bres : in std_logic; 
	op_out	:	out		std_logic_vector(10 downto 0):= (others => 'Z');
	alu_op  :   out      std_logic_vector(6 downto 0);
	imm		:	out		std_logic_vector(31 downto 0):= (others => 'Z');
	rs1		:	out		std_logic_vector( 4 downto 0):= (others => 'Z');
	rs2		:	out		std_logic_vector( 4 downto 0):= (others => 'Z');
	Btype    :  out 		std_logic; 
	funct3_out:  out		std_logic_vector( 2 downto 0);
	funct7_out:  out     std_logic;
	rd			:	out		std_logic_vector( 4 downto 0):= (others => 'Z');
	rd_en		:  out std_logic;
	loadpc	:  out std_logic;
	wrMem		:  out std_logic;
	load_mem	:  out std_logic
	
	);
end decoder;

architecture behavioral of decoder is

	signal is_r_type	:	boolean;
	signal is_i_type	:	boolean;
	signal is_s_type	:	boolean;
	signal is_b_type	:	boolean;
	signal is_u_type	:	boolean;
	signal is_j_type	:	boolean;
	signal opcode		:	std_logic_vector( 6 downto 0);
	signal funct7		:	std_logic_vector( 6 downto 0);
	signal funct3		:	std_logic_vector( 2 downto 0);
	
begin


	opcode		<=	instr( 6 downto  0);
	alu_op      <= instr( 6 downto  0);
	funct3		<=	instr(14 downto 12);
	funct7		<=	instr(31 downto 25);
	
	funct7_out	<= instr(30);
	funct3_out  <= instr(14 downto 12);
	-- signals to detect which type of instruction is introduced
	is_r_type	<=	true when opcode = "0110011" else false;
	is_i_type	<=	true when opcode = "0010011" or opcode = "1100111" or opcode = "0000011"else false;
	is_s_type	<=	true when opcode = "0100011" else false;
	is_b_type	<=	true when opcode = "1100011" else false;
	is_u_type	<=	true when opcode = "0110111" or opcode = "0010111"else false;
	is_j_type	<=	true when opcode = "1101111" else false;
	
	
	rd_en    <= '1' when opcode /= "1100011" and opcode /= "0100011" else '0';
	wrMem    <= '1' when opcode  = "0100011" else '0';
	Btype    <= '1'  when opcode = "1100011"  else '0'; 
	load_mem <= '1' when opcode  = "0000011" else '0';
	
	
	op_out		<=	funct7(5) & funct3 & opcode;
	
	rd 	<= instr(11 downto  7) when is_u_type or is_j_type or is_i_type or is_r_type else (others => 'Z');
	rs1	<= instr(19 downto 15) when is_i_type or is_b_type or is_s_type or is_r_type else (others => 'Z');
	rs2	<= instr(24 downto 20) when is_b_type or is_s_type or is_r_type else instr(19 downto 15) when is_i_type else (others => 'Z');
	
	loadpc<= '1' when Bres = '1' else '0';
	
	
		set_imm:	process(instr, is_r_type, is_i_type, is_s_type, is_b_type, is_u_type, is_j_type)
		begin
			if(is_i_type) then
				imm(31 downto 12) <= (others => instr(31));
				
				imm(11 downto  0) <= instr(31 downto 20); -- usable part of imm 
				
			
			elsif(is_s_type) then
			
				imm(31 downto 12) <= (others => instr(31));
				
				imm(11 downto  5) <= instr(31 downto 25);      -- usable part of imm 
				
				imm( 4 downto  0) <= instr(11 downto  7);
			
				
			elsif(is_b_type) then
				imm(31 downto 13) <= (others => instr(31));
				
				imm(12) 		      <= instr(31);
				imm(10 downto  5) <= instr(30 downto 25);  	-- usable part of imm 
				
				imm( 4 downto  0) <= instr(11 downto  7);
				
				
			elsif(is_u_type) then
				imm(31 downto 12)	 <= instr(31 downto 12);	-- usable part of imm 
				imm(11 downto  0) <= (others => '0');
				
			elsif(is_j_type) then
				imm(20)			  <=  instr(31);					-- usable part of imm 
				imm(19 downto 12) <= instr(19 downto 12);
				imm(11)			  <= instr(20);
				imm(10 downto  1) <= instr(30 downto 21);
				
				imm(31 downto 21) <= (others=>'0'); 
				imm(0) <= '0';
			
			else
				imm <= (others => 'Z');
			end if;	
			
	end process;
	
end architecture;