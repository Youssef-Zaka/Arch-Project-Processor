
-- buffer for ALU and memory
Library ieee;
use ieee.std_logic_1164.all;

entity buf_EX_MEM is 

port(
rst, clk : in std_logic;
--Result of ALU as input
alu_result : in std_logic_vector(31 downto 0);

--3 bits for Rdst
Rdst : in std_logic_vector(2 downto 0);


--1 bit enables for mem read and write
mem_read_en, mem_write_en : in std_logic;
--1 bit enable writeback
writeback_en : in std_logic;
decoder_wb_en: in std_logic;

jump_enable : in std_logic;
jump_target : in std_logic_vector(31 downto 0);

--outputs for all inputs
Rdst_o : out std_logic_vector(2 downto 0);
alu_result_o : out std_logic_vector(31 downto 0);
mem_read_en_o, mem_write_en_o : out std_logic;
writeback_en_o : out std_logic;
decoder_wb_en_o: out std_logic;
jump_enable_o : out std_logic;
jump_target_o : out std_logic_vector(31 downto 0)

);
end buf_EX_MEM;

Architecture buf_arch of buf_EX_MEM is
begin
Process(rst, clk)
begin
if (rst = '1') then
    -- reset all outputs to 0
    
    mem_read_en_o <= '0';
    mem_write_en_o <= '0';
    Rdst_o <= (others => '0');
    alu_result_o <= (others => '0');
    writeback_en_o <= '0';
    decoder_wb_en_o <= '0';
    jump_enable_o <= '0';
    jump_target_o <= (others => '0');
   
elsif rising_edge(clk) then
    --pass input to outputs

    mem_read_en_o <= mem_read_en;
    mem_write_en_o <= mem_write_en;
    Rdst_o <= Rdst;
    alu_result_o <= alu_result;
    writeback_en_o <= writeback_en;
    decoder_wb_en_o <= decoder_wb_en;
    jump_enable_o <= jump_enable;
    jump_target_o <= jump_target;
end if;
end process;
end buf_arch;

