LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU IS
	PORT (data_1,data_2 : in std_logic_vector (31 downto 0);
	      sel: in std_logic_vector (3 downto 0);
	      cin: in std_logic;
	      alu_enable: in std_logic;
	      result: out std_logic_vector (31 downto 0);
              flags: out std_logic_vector (2 downto 0));
END ALU;

ARCHITECTURE alu_arch OF ALU IS
	
	signal carry_flag: std_logic;
	signal zero_flag: std_logic;
	signal negative_flag: std_logic;
	
	BEGIn
	process (data_1,data_2,cin)
	variable temp : Integer;
	begin
	
	if (alu_enable = '1') then
--------------------------------------------------------------

	if (sel = "0000") then -- not operation 000
	result <= (Not (data_1));

	if (data_1 = (x"11111111")) then  -- zero flag if
	zero_flag <= '1';
	else
	zero_flag<= '0'; 
	end if;
	
	if (to_integer(signed(Not (data_1))) < 0)then
	negative_flag <= '1';
	else
	negative_flag <= '0';
	end if;
	
	flags <= cin & zero_flag & negative_flag;
	end if;

-------------------------------------------------------------
	
	if (sel = "0001") then  -- increment 001

	result <= std_logic_vector(to_signed((to_integer(signed(data_1)) + 1),32));
	
	temp := (to_integer(signed(data_1)) + 1);

	if (temp = 0) then
	zero_flag <= '1';
	carry_flag <= '1';
	else
	zero_flag<= '0'; 
	carry_flag <= '0';
	end if;
	
	if (temp < 0)then
	negative_flag <= '1';
	else
	negative_flag <= '0';
	end if;
	
	flags <= carry_flag & zero_flag & negative_flag;
	end if;
	
--------------------------------------------------------------

	if (sel = "0010") then  -- add 010
	result <= std_logic_vector(to_signed((to_integer(signed(data_1)))+(to_integer(signed(data_2))),32));
	
	temp:= (to_integer(signed(data_1))) + (to_integer(signed(data_2)));
	
	if (temp = 0) then
	zero_flag <= '1';
	else
	zero_flag<= '0'; 
	end if;
	
	if (temp < 0)then
	negative_flag <= '1';
	else
	negative_flag <= '0';
	end if;
	
	flags <= cin & zero_flag & negative_flag;
	end if;

------------------------------------------------------------------

	if (sel = "0011") then  -- sub 011
	
	result <= std_logic_vector(to_signed((to_integer(signed(data_1)))-(to_integer(signed(data_2))),32));
	
	temp:= (to_integer(signed(data_1))) - (to_integer(signed(data_2)));
	
	if (temp = 0) then
	zero_flag <= '1';
	else
	zero_flag<= '0'; 
	end if;
	
	if (temp < 0)then
	negative_flag <= '1';
	else
	negative_flag <= '0';
	end if;
	
	flags <= cin & zero_flag & negative_flag;
	end if;

-------------------------------------------------------------------

	if (sel = "0100") then  -- and 100
	result <= data_1 and data_2 ;
	temp:= to_integer(signed(data_1 and data_2));
	
	if (temp = 0) then
	zero_flag <= '1';
	else
	zero_flag<= '0'; 
	end if;
	
	if (temp < 0)then
	negative_flag <= '1';
	else
	negative_flag <= '0';
	end if;
	
	flags <= cin & zero_flag & negative_flag;
	end if;

---------------------------------------------------------------------

	if (sel = "0101") then  -- pass first argument 0101
	result <= data_1;
	end if;

----------------------------------------------------------------------

	if (sel = "0110") then  -- nop 0110
	result <= (others=>'0');
	end if;

-----------------------------------------------------------------------
	
	if (sel = "0111") then  -- setc 0111
	result <= (others=>'0');
	flags <= '1' & "00";
	end if;

------------------------------------------------------------------------

	
	end if; -- if enable
	end process;
end Architecture;
