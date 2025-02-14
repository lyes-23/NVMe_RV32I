LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE alu_arch OF alu_tb IS
    -- Signals
    SIGNAL opcode      : std_logic_vector(6 downto 0);
    SIGNAL funct3      : std_logic_vector(2 downto 0);
    SIGNAL funct7      : std_logic;
    SIGNAL rs1_in      : std_logic_vector(31 downto 0);
    SIGNAL rs2_in      : std_logic_vector(31 downto 0);
    SIGNAL imm_in      : std_logic_vector(31 downto 0);

    SIGNAL alu_result  : std_logic_vector(31 downto 0);
    SIGNAL zero_flag   : std_logic;

    -- Component declaration
    COMPONENT alu
        PORT (
            opcode      : IN std_logic_vector(6 downto 0);
            funct3      : IN std_logic_vector(2 downto 0);
            funct7      : IN std_logic;
            rs1_in      : IN std_logic_vector(31 downto 0);
            rs2_in      : IN std_logic_vector(31 downto 0);
            imm_in      : IN std_logic_vector(31 downto 0);
            alu_result  : OUT std_logic_vector(31 downto 0);
            zero_flag   : OUT std_logic
        );
    END COMPONENT;

BEGIN
    -- Instantiate the ALU
    uut: alu
        PORT MAP (
            opcode      => opcode,
            funct3      => funct3,
            funct7      => funct7,
            rs1_in      => rs1_in,
            rs2_in      => rs2_in,
            imm_in      => imm_in,
            alu_result  => alu_result,
            zero_flag   => zero_flag
        );

    -- Test process
    PROCESS
    BEGIN
        -- Test ADD (R-type: opcode = "0110011", funct3 = "000", funct7 = '0')
        opcode <= "0110011";
        funct3 <= "000";
        funct7 <= '0';
        rs1_in <= x"00000002";
        rs2_in <= x"00000003";
        imm_in <= (others => '0'); -- Not used for R-type
        wait for 10 ns;

        -- Test SUB (R-type: opcode = "0110011", funct3 = "000", funct7 = '1')
        opcode <= "0110011";
        funct3 <= "000";
        funct7 <= '1';
        rs1_in <= x"00000005";
        rs2_in <= x"00000003";
        wait for 10 ns;

        -- Test AND (R-type: opcode = "0110011", funct3 = "111")
        opcode <= "0110011";
        funct3 <= "111";
        funct7 <= '0'; -- Irrelevant for AND
        rs1_in <= x"0000000F";
        rs2_in <= x"000000F0";
        wait for 10 ns;

        -- Test OR (R-type: opcode = "0110011", funct3 = "110")
        opcode <= "0110011";
        funct3 <= "110";
        funct7 <= '0'; -- Irrelevant for OR
        rs1_in <= x"0000000F";
        rs2_in <= x"000000F0";
        wait for 10 ns;

        -- Test XOR (R-type: opcode = "0110011", funct3 = "100")
        opcode <= "0110011";
        funct3 <= "100";
        funct7 <= '0'; -- Irrelevant for XOR
        rs1_in <= x"0000000F";
        rs2_in <= x"000000F0";
        wait for 10 ns;

        -- Stop simulation
        WAIT;
    END PROCESS;

END alu_arch;
