LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY signExtend IS

PORT(

data_in : in std_logic_vector (15 DOWNTO 0);
data_out: out std_logic_vector (31 DOWNTO 0));

END signExtend;

ARCHITECTURE signExtend_arch OF signExtend IS
BEGIN
--new_size <= resize(signed(old_size_std_logic_vector), 32);
data_out <= std_logic_vector(resize(signed(data_in), data_out'length));

END signExtend_arch;