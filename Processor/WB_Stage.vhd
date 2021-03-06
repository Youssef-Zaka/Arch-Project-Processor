LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


--Execute stage entity declaration
ENTITY wb_stage is
PORT(
    mem_result: in std_logic_vector(31 downto 0);
    ALU_result: in std_logic_vector(31 downto 0);
    rdst: in std_logic_vector(2 downto 0);
    wb_enable : IN STD_LOGIC;
    decoder_enable: IN STD_LOGIC;

    writeback_result : out std_logic_vector(31 downto 0);
    rdst_o : out std_logic_vector(2 downto 0);
    decoder_enable_o: out STD_LOGIC
    );

end wb_stage;

architecture wb_stage_arch of wb_stage is 

--signals

begin

writeback_result <= ALU_result when wb_enable = '0'
else mem_result;

rdst_o <= rdst;

decoder_enable_o <= decoder_enable;

end architecture;
