library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity alu is
	port(
		opcode      : in  std_logic_vector(6 downto 0);
        funct3      : in  std_logic_vector(2 downto 0);
        funct7      : in  std_logic;                        --bit 30 of the opcode 
        rs1_in      : in  std_logic_vector(31 downto 0);  
        rs2_in      : in  std_logic_vector(31 downto 0);
        imm_in      : in  std_logic_vector(31 downto 0);
		  
        alu_result  : out std_logic_vector(31 downto 0);
        zero_flag   : out std_logic
		
	);
end entity;



	architecture Behavioral of alu is

    signal rs1      : signed(31 downto 0);
    signal rs2      : signed(31 downto 0);
    signal imm      : signed(31 downto 0);
    signal result   : signed(31 downto 0);

begin

    -- converting input to signed signals
    rs1 <= signed(rs1_in);
    rs2 <= signed(rs2_in);
    imm <= signed(imm_in);

    process(opcode, funct3, funct7, rs1, rs2, imm,rs1_in, rs2_in, imm_in)
    begin
        case opcode is
            when "0110011" => -- R-type instructions
                case funct3 is
                    when "000" => -- ADD, SUB
                        if funct7 = '0' then
                            result <= rs1 + rs2; -- ADD
                        else
                            result <= rs1 - rs2; -- SUB
                        end if;
                    when "001" => -- SLL
                        result <= shift_left(rs1, to_integer(unsigned(rs2_in(4 downto 0))));
                    when "010" => -- SLT
                        if rs1 < rs2 then
                            result <= to_signed(1, 32);
                        else
                            result <= to_signed(0, 32);
                        end if;
                    when "011" => -- SLTU
                        if unsigned(rs1_in) < unsigned(rs2_in) then
                            result <= to_signed(1, 32);
                        else
                            result <= to_signed(0, 32);
                        end if;
                    when "100" => -- XOR
                        result <= rs1 xor rs2;
                    when "101" => -- SRL, SRA
                        if funct7 = '0' then
                            result <= signed(shift_right(unsigned(rs1_in), to_integer(unsigned(rs2_in(4 downto 0))))); -- SRL		 
                        else
                            result <= shift_right(rs1, to_integer(unsigned(rs2_in(4 downto 0)))); -- SRA			 
                        end if;
                    when "110" => -- OR
                        result <= rs1 or rs2;
                    when "111" => -- AND
                        result <= rs1 and rs2;
                    when others =>
                        result <= (others => '0');
                end case;
            when "0010011" => -- I-type instructions 
                case funct3 is
                    when "000" => -- ADDI
                        result <= rs1 + imm;
                    when "010" => -- SLTI
                        if rs1 < imm then
                            result <= to_signed(1, 32);
                        else
                            result <= to_signed(0, 32);
                        end if;
                    when "011" => -- SLTIU
                        if unsigned(rs2_in) < unsigned(imm) then
                            result <= to_signed(1, 32);
                        else
                            result <= to_signed(0, 32);
                        end if;
                    when "100" => -- XORI
                        result <= rs1 xor imm;
                    when "110" => -- ORI
                        result <= rs1 or imm;
                    when "111" => -- ANDI
                        result <= rs1 and imm;
                    when "001" => -- SLLI
                        result <= shift_left(rs1, to_integer(unsigned(imm_in(4 downto 0))));
                    when "101" => -- SRLI, SRAI
                        if funct7 = '0' then
                            result <= signed(shift_right(unsigned(rs1_in), to_integer(unsigned(imm_in(4 downto 0))))); -- SRLI
                        else
                            result <= shift_right(rs1, to_integer(unsigned(imm_in(4 downto 0)))); -- SRAI
                        end if;
                    when others =>
                        result <= (others => '0');
                end case;
            when "0000011" =>           -- Load instructions (LW, LH, LB,....)
                result <= rs1 + imm;    -- Calculate address for load
            when "0100011" =>           -- Store instructions (SW, SH, SB, etc.)
                result <= rs1 + imm;    -- Calculate address for store
            when others =>
                result <= (others => '0');
        end case;
    end process;

    --  outputs
    alu_result <= std_logic_vector(result);
    zero_flag <= '1' when result = 0 else '0';

end architecture;