LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY flagReg IS
PORT( Clk,Rst,En : IN std_logic;
c , n , z : IN std_logic;
c_o , n_o , z_o : OUT std_logic
);
END flagReg;

ARCHITECTURE flagReg_arch OF flagReg IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
c_o <= '0';
n_o <= '0';
z_o <= '0';
ELSIF rising_edge(Clk) and En = '1' THEN
c_o <= c;
n_o <= n;
z_o <= z;
END IF;
END PROCESS;
END flagReg_arch;