Library ieee;
use ieee.std_logic_1164.all;

entity decoder is 

port(
sel : in std_logic_vector(2 downto 0);
enable: in std_logic;
F : out std_logic_vector(7 downto 0));
end entity;

ARCHITECTURE decoder_arch OF decoder IS

BEGIN

F <= ("00000001") when sel = "000" and enable = '1'
else ("00000010") when sel = "001" and enable = '1'
else ("00000100") when sel = "010" and enable = '1'
else ("00001000") when sel = "011" and enable = '1'
else ("00010000") when sel = "100" and enable = '1'
else ("00100000") when sel = "101" and enable = '1'
else ("01000000") when sel = "110" and enable = '1'
else ("10000000") when sel = "111" and enable = '1'
else ("00000000");

END architecture;

