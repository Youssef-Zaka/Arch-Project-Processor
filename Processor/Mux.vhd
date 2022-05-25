LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_generic IS 
	Generic ( n : Integer:=32);
	PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
			sel : IN  std_logic;
			out1 : OUT std_logic_vector (n-1 DOWNTO 0));
END mux_generic;


ARCHITECTURE when_else_mux OF mux_generic is
	BEGIN
		
  out1 <= 	in0 when sel = '0'
	else	in1 when sel = '1'; 
END when_else_mux;