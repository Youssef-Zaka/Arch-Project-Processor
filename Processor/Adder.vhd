
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
--entity Adder that takes a 32 bit number and adds 1 to it and returns the result

entity Adder is
port(
    PC : in std_logic_vector(31 downto 0);
    c : out std_logic_vector(31 downto 0)
);
end entity;

architecture arch of Adder is
begin

    c <= std_logic_vector(to_signed((to_integer(signed(PC)) + 1),32));
 
end arch;


