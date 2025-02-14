library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity instr_memory is
    generic (
        DATA_WIDTH  : natural := 32;
        ADDR_WIDTH  : natural := 8;
        MEM_DEPTH   : natural := 100;
        INIT_FILE   : string  := "imm_test.txt"
    );

    port (
        if_adr      : in std_logic_vector(31 downto 0);  -- Program Counter input
        if_adr_valid: in std_logic;                      -- Valid PC request

        ic_inst     : out std_logic_vector(31 downto 0); -- Fetched instruction
        ic_stall    : out std_logic                      -- Stall signal (default: 0)
    );

end entity;

architecture Behavioral of instr_memory is
	   
    type memType is array (0 to MEM_DEPTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);

    -- Function to convert hexadecimal string to std_logic_vector
    function str_to_slv(str : string) return std_logic_vector is
        alias str_norm : string(1 to str'length) is str;
        variable char_v : character;
        variable val_of_char_v : natural;
        variable res_v : std_logic_vector(4 * str'length - 1 downto 0);
    begin
        for str_norm_idx in str_norm'range loop
            char_v := str_norm(str_norm_idx);
            case char_v is
                when '0' to '9' => val_of_char_v := character'pos(char_v) - character'pos('0');
                when 'A' to 'F' => val_of_char_v := character'pos(char_v) - character'pos('A') + 10;
                when 'a' to 'f' => val_of_char_v := character'pos(char_v) - character'pos('a') + 10;
                when others => report "str_to_slv: Invalid characters for convert" severity ERROR;
            end case;
            res_v(res_v'left - 4 * str_norm_idx + 4 downto res_v'left - 4 * str_norm_idx + 1) :=
            std_logic_vector(to_unsigned(val_of_char_v, 4));
        end loop;
        return res_v;
    end function;
	
    -- Function to read instructions from hex file
    impure function memInit(fileName : string) return memType is
        variable mem_tmp : memType;
        file filePtr : text;
        variable line_instr : line;
        variable instr_str : string(1 to 8);
        variable inst_num : integer := 0;
        variable instr_init : std_logic_vector(31 downto 0);
    begin
        file_open(filePtr, fileName, READ_MODE);
        while (inst_num < MEM_DEPTH and not endfile(filePtr)) loop
            readline (filePtr, line_instr);
            read (line_instr, instr_str);
            instr_init := str_to_slv(instr_str);
            mem_tmp(inst_num) := instr_init;
            inst_num := inst_num + 1;
        end loop;
        file_close(filePtr);
        return mem_tmp;
    end function;

    signal mem : memType := memInit(INIT_FILE);

begin

    process(if_adr, if_adr_valid)
    variable word_address : integer;
    begin
        if (if_adr_valid = '1') then
            word_address := to_integer(unsigned(if_adr(ADDR_WIDTH-1 downto 2)));   -- 4-byte aligned address
            ic_inst <= mem(word_address);  -- Read instruction from memory 
        else
            ic_inst <= (others => '0'); 
        end if;
    end process;

    ic_stall <= '0';
end Behavioral;
