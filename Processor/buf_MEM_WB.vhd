
-- buffer for ALU and memory
Library ieee;
use ieee.std_logic_1164.all;

entity buf_MEM_WB is 

port(
rst, clk : in std_logic;
--Result of ALU as input
alu_result : in std_logic_vector(31 downto 0);

--3 bits for Rdst
Rdst : in std_logic_vector(2 downto 0);

--32 bits for memory result
mem_result : in std_logic_vector(31 downto 0);
--1 bit enable writeback
writeback_en : in std_logic;

--outputs for all inputs
Rdst_o : out std_logic_vector(2 downto 0);
alu_result_o : out std_logic_vector(31 downto 0);
mem_result_o : out std_logic_vector(31 downto 0);
writeback_en_o : out std_logic

);
end buf_MEM_WB;


Architecture buf_arch of  buf_MEM_WB is
begin
Process(rst, clk)
begin
if (rst = '1') then
    -- reset all outputs to 0
    Rdst_o <= (others => '0');
    alu_result_o <= (others => '0');
    mem_result_o <= (others => '0');
    writeback_en_o <= '0';
elsif rising_edge(clk) then
    --pass input to outputs
    Rdst_o <= Rdst;
    alu_result_o <= alu_result;
    mem_result_o <= mem_result;
    writeback_en_o <= writeback_en;
end if;
end process;
end buf_arch;

