LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY triState IS

PORT(

Q : in std_logic_vector (2 DOWNTO 0);
en : in std_logic;
output: out std_logic_vector (2 DOWNTO 0));

END triState;

ARCHITECTURE triState_arch OF triState IS
BEGIN

output <= Q WHEN en = '1'
ELSE (others => 'Z') WHEN en = '0';

END triState_arch;