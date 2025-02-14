library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package common is
    -- definition for a machine word
    subtype word is std_logic_vector(31 downto 0);
    subtype reg_addr_t is std_logic_vector(4 downto 0);

    subtype alu_func_t is std_logic_vector(3 downto 0);
    constant ALU_NONE : alu_func_t := "0000";
    constant ALU_ADD  : alu_func_t := "0001";
    constant ALU_ADDU : alu_func_t := "0010";
    constant ALU_SUB  : alu_func_t := "0011";
    constant ALU_SUBU : alu_func_t := "0100";
    constant ALU_SLT  : alu_func_t := "0101";
    constant ALU_SLTU : alu_func_t := "0110";
    constant ALU_AND  : alu_func_t := "0111";
    constant ALU_OR   : alu_func_t := "1000";
    constant ALU_XOR  : alu_func_t := "1001";
    constant ALU_SLL  : alu_func_t := "1010";
    constant ALU_SRA  : alu_func_t := "1011";
    constant ALU_SRL  : alu_func_t := "1100";

    subtype insn_type_t is std_logic_vector(3 downto 0);
    constant OP_ILLEGAL : insn_type_t := "0000";
    constant OP_LUI     : insn_type_t := "0001";
    constant OP_AUIPC   : insn_type_t := "0010";
    constant OP_JAL     : insn_type_t := "0011";
    constant OP_JALR    : insn_type_t := "0100";
    constant OP_BRANCH  : insn_type_t := "0101";
    constant OP_LOAD    : insn_type_t := "0110";
    constant OP_STORE   : insn_type_t := "0111";
    constant OP_ALU     : insn_type_t := "1000";
    constant OP_STALL   : insn_type_t := "1001";
    constant OP_SYSTEM  : insn_type_t := "1010";

    subtype branch_type_t is std_logic_vector(2 downto 0);
    constant BRANCH_NONE : branch_type_t := "000";
    constant BEQ         : branch_type_t := "001";
    constant BNE         : branch_type_t := "010";
    constant BLT         : branch_type_t := "011";
    constant BGE         : branch_type_t := "100";
    constant BLTU        : branch_type_t := "101";
    constant BGEU        : branch_type_t := "110";

    subtype load_type_t is std_logic_vector(2 downto 0);
    constant LOAD_NONE : load_type_t := "000";
    constant LB        : load_type_t := "001";
    constant LH        : load_type_t := "010";
    constant LW        : load_type_t := "011";
    constant LBU       : load_type_t := "100";
    constant LHU       : load_type_t := "101";

    subtype store_type_t is std_logic_vector(1 downto 0);
    constant STORE_NONE : store_type_t := "00";
    constant SB         : store_type_t := "01";
    constant SH         : store_type_t := "10";
    constant SW         : store_type_t := "11";

    subtype system_type_t is std_logic_vector(2 downto 0);
    constant SYSTEM_ECALL  : system_type_t := "000";
    constant SYSTEM_EBREAK : system_type_t := "001";
    constant SYSTEM_CSRRW  : system_type_t := "010";
    constant SYSTEM_CSRRS  : system_type_t := "011";
    constant SYSTEM_CSRRC  : system_type_t := "100";
    constant SYSTEM_CSRRWI : system_type_t := "101";
    constant SYSTEM_CSRRSI : system_type_t := "110";
    constant SYSTEM_CSRRCI : system_type_t := "111";
