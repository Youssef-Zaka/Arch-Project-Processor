
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PC_Reg IS
PORT( Clk,Rst,En : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0) );
END PC_Reg;

ARCHITECTURE regArch OF PC_Reg IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
data_out <= (others=>'0');
ELSIF rising_edge(Clk) and En = '1' THEN
data_out <= data;
END IF;
END PROCESS;
END regArch;
