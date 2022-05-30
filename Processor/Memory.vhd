LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;	
use std.textio.all;


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
	impure function init_ram_bin return mem_type is
		file text_file : text open read_mode is "../assembler/BranchNOP.txt";
		variable text_line : line;
		variable ram_content : mem_type;
		variable bv : bit_vector(ram_content(0)'range);
	  begin
		for i in 0 to 2 ** 20 - 1 loop
		  readline(text_file, text_line);
		  read(text_line, bv);
		  ram_content(i) := To_StdLogicVector(bv);
		end loop;
		return ram_content;
	end function;
	--signal declaration
	SIGNAL Memory : mem_type := init_ram_bin;
	
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
