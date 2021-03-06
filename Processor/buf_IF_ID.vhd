Library ieee;
use ieee.std_logic_1164.all;

entity buf_IF_ID is 

port(
rst, clk : in std_logic;

--32 bits for instruction
instruction : in std_logic_vector(31 downto 0);
--32 bits for PC
PC : in std_logic_vector(31 downto 0);

--output for both instruction and PC
instruction_out : out std_logic_vector(31 downto 0);
PC_out : out std_logic_vector(31 downto 0)

);

end entity;

Architecture buf_arch of buf_IF_ID is
begin
Process(rst, clk)
begin
if (rst = '1') then
    instruction_out <= (others => '0');
    PC_out <= (others => '0');
elsif rising_edge(clk) then
    instruction_out <= instruction;
    PC_out <= PC;
end if;
end process;
end Architecture;
