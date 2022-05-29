
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PC_Reg IS
PORT( Clk: IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0) );
END PC_Reg;

ARCHITECTURE regArch OF PC_Reg IS
BEGIN
PROCESS (Clk)
BEGIN
IF rising_edge(Clk) then
data_out <= data;
END IF;
END PROCESS;
END regArch;
