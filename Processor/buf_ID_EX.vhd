Library ieee;
use ieee.std_logic_1164.all;

entity buf_ID_EX is 

port(
rst, clk : in std_logic;

--3 bits for Rdst
Rdst : in std_logic_vector(2 downto 0);
--32 bits for Rsrc1
Rsrc1 : in std_logic_vector(31 downto 0);
--32 bits for Rsrc2
Rsrc2 : in std_logic_vector(31 downto 0);
--32 bits for Imm
Imm : in std_logic_vector(31 downto 0);
--32 bits for PC
PC : in std_logic_vector(31 downto 0);
-- 3 bits for opcode
opcode : in std_logic_vector(2 downto 0);

--1 bit enables for mem read and write
mem_read_en, mem_write_en : in std_logic;
--1 bit enable for input port
InPort_en : in std_logic;

--pass the inputs to the output of the buffer
Rdst_o : out std_logic_vector(2 downto 0);
Rsrc1_o : out std_logic_vector(31 downto 0);
Rsrc2_o : out std_logic_vector(31 downto 0);
Imm_o : out std_logic_vector(31 downto 0);
PC_o : out std_logic_vector(31 downto 0);
opcode_o : out std_logic_vector(2 downto 0);
mem_read_en_o : out std_logic;
mem_write_en_o : out std_logic;
InPort_en_o : out std_logic;
);
end buf_ID_EX;

Architecture buf_arch of buf_ID_EX is
begin
Process(rst, clk)
begin
if (rst = '1') then
    --reset the outputs to 0
    Rdst_o <= (others => '0');
    Rsrc1_o <= (others => '0');
    Rsrc2_o <= (others => '0');
    Imm_o <= (others => '0');
    PC_o <= (others => '0');
    opcode_o <= (others => '0');
    mem_read_en_o <= '0';
    mem_write_en_o <= '0';
    InPort_en_o <= '0';
   
elsif rising_edge(clk) then
    --pass the inputs to the outputs
    Rdst_o <= Rdst;
    Rsrc1_o <= Rsrc1;
    Rsrc2_o <= Rsrc2;
    Imm_o <= Imm;
    PC_o <= PC;
    opcode_o <= opcode;
    mem_read_en_o <= mem_read_en;
    mem_write_en_o <= mem_write_en;
    InPort_en_o <= InPort_en;
end if;
end process;
end buf_arch;
