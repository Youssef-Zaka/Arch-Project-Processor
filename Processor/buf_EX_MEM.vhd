
-- buffer for ALU and memory
Library ieee;
use ieee.std_logic_1164.all;

entity buf_EX_MEM is 

port(
rst, clk : in std_logic;
--Result of ALU as input
alu_result : in std_logic_vector(31 downto 0);

--3 bits for Rdst
Rdst : in std_logic_vector(2 downto 0);

-- 1 bit enable for Input Port
InPort_en : in std_logic;

--1 bit enables for mem read and write
mem_read_en, mem_write_en : in std_logic;
--input port enable
InPort_en_o : out std_logic;

)


end buf_ID_EX;

Architecture buf_arch of buf_EX_MEM is
begin
Process(rst, clk)
begin
if (rst = '1') then
    
   
   
elsif rising_edge(clk) then
   
end if;
end process;
end buf_arch;

