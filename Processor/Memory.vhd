LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Memory IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
        re  : IN std_logic;
        --20 bit address
		address : IN  std_logic_vector(19 DOWNTO 0);
        --32 bit data
        data_in : IN  std_logic_vector(31 DOWNTO 0);
        --32 bit data out
        data_out : OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY Memory;

ARCHITECTURE syncrama OF Memory IS

    --Memory Type
    TYPE mem_type IS ARRAY(0 TO 2 ** 20 - 1) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL Memory : mem_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF we = '1' THEN
						Memory(to_integer(unsigned(address))) <= data_in;
					END IF;
				END IF;
		END PROCESS;
		data_out <= Memory(to_integer(unsigned(address))) When re = '1'
        else (others => '0');
       
END syncrama;
