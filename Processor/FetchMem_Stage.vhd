
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--fetch and memory stages
entity fetch_stage is 
port(
    clk,rst : in std_logic;
    Alu_result : in std_logic_vector(31 downto 0);
    Rdst : in std_logic_vector(2 downto 0);
    writeback_mux_en : in std_logic;
    decoder_en : in std_logic; 
    mem_read_en : in std_logic;
    mem_write_en : in std_logic;
    
    instruction_o : out std_logic_vector(31 downto 0);
    pc_o : out std_logic_vector(31 downto 0);
    Rdst_o : out std_logic_vector(2 downto 0);
    Alu_result_o : out std_logic_vector(31 downto 0);
    memory_result_o : out std_logic_vector(31 downto 0);
    writeback_mux_en_o : out std_logic;
    decoder_en_o : out std_logic
);
end fetch_stage;


architecture arch of fetch_stage is
    --buf_IF_ID
component buf_IF_ID is
    port(
        rst, clk : in std_logic;
        
        --32 bits for instruction
        instruction : in std_logic_vector(31 downto 0);
        --32 bits for PC
        PC : in std_logic_vector(31 downto 0);
        
        --output for both instruction and PC
        instruction_out : out std_logic_vector(31 downto 0);
        PC_out : out std_logic_vector(31 downto 0)
        
        );
end component; 

--buf_MEM_WB
component buf_MEM_WB is
    port(
        rst, clk : in std_logic;
        --Result of ALU as input
        alu_result : in std_logic_vector(31 downto 0);
        
        --3 bits for Rdst
        Rdst : in std_logic_vector(2 downto 0);
        
        --32 bits for memory result
        mem_result : in std_logic_vector(31 downto 0);
        --1 bit enable writeback
        writeback_en : in std_logic;
        decoder_wb_en: in std_logic;
        
        --outputs for all inputs
        Rdst_o : out std_logic_vector(2 downto 0);
        alu_result_o : out std_logic_vector(31 downto 0);
        mem_result_o : out std_logic_vector(31 downto 0);
        writeback_en_o : out std_logic;
        decoder_wb_en_o: out std_logic
        );
        
end component;


--Memory
component Memory IS
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
END component;


--PC register
component PC_Reg IS
PORT( Clk : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0) );
END component;

--Adder
component Adder is
    port(
        PC : in std_logic_vector(31 downto 0);
        c : out std_logic_vector(31 downto 0)
    );
end component;


--signals
signal we : std_logic;
signal re : std_logic;
signal address : std_logic_vector(19 downto 0);
signal data_in : std_logic_vector(31 downto 0);
signal data_out : std_logic_vector(31 downto 0);
signal PC : std_logic_vector(31 downto 0);
signal PC_plus_one : std_logic_vector(31 downto 0);
signal pc_data : std_logic_vector(31 downto 0);
signal pc_data_out : std_logic_vector(31 downto 0);
signal buf_IF_ID_instruction : std_logic_vector(31 downto 0);
signal buf_IF_ID_PC : std_logic_vector(31 downto 0);
signal buf_IF_ID_instruction_o : std_logic_vector(31 downto 0);
signal buf_IF_ID_PC_o : std_logic_vector(31 downto 0);

signal buf_MEM_WB_Rdst_o : std_logic_vector(2 downto 0);
signal buf_MEM_WB_alu_result_o : std_logic_vector(31 downto 0);
signal buf_MEM_WB_mem_result_o : std_logic_vector(31 downto 0);
signal buf_MEM_WB_writeback_en_o : std_logic;
signal buf_MEM_WB_decoder_en_o : std_logic;
signal mem_result : std_logic_vector(31 downto 0);

begin
--processes

process (clk,rst)
begin
-- address <= (others => '0'); 
-- re <= '1';
-- we <= '0';
-- pc_en <= '1';
-- if rising_edge(clk) then
-- if rst = '1' then
--     buf_IF_ID_instruction <= (others => '0');
--     buf_IF_ID_PC <= (others => '0');
--     we <= '0';
--     re <= '1';
    
--     address <= (others => '0'); 
--     pc_data <= data_out;
--     pc <= data_out;

-- elsif rst = '0' and mem_read_en = '0' and  mem_write_en = '0' then
--     re <= '1';
--     we <= '0';
--     pc_en <= '1';
    
--     address <= pc_data_out(19 downto 0); 
--     buf_IF_ID_instruction<= data_out;
--     buf_IF_ID_PC <= PC_data_out;
--     Pc_data <= pc_plus_one;
--     pc <= Pc_data_out;
-- else
-- end if;        
-- end if;

--if reset is 1
if rst = '1' then
    re <= '1';
    we <= '0';
    address <= (others => '0');
    PC <= data_out;
    PC_data <= data_out;
    elsif rst = '0' and mem_read_en = '0' and  mem_write_en = '0' and falling_edge(clk) then
    re <= '1';
    we <= '0';
    address <= PC_data_out(19 downto 0);
    PC_data <= PC_plus_one;
    PC <= PC_data_out;

end if;
end PROCESS;



--First stage
Memory_OBJ: Memory PORT MAP (
    clk, 
    we,
    re,
    address,
    data_in,
    data_out
);

ADDER_OBJ: Adder PORT MAP (
    PC,
    PC_Plus_One
);
 

PC_OBJ: PC_Reg Port Map (
    clk ,
    pc_data,
    pc_data_out
);


BUF_IF_ID_OBJ: buf_IF_ID PORT MAP (
    rst,
    clk,
    buf_IF_ID_instruction,
    buf_IF_ID_PC,
    buf_IF_ID_instruction_o,
    buf_IF_ID_PC_o
);


buf_MEM_WB_OBJ: buf_MEM_WB Port map(
    rst,
    clk,
    Alu_result,
    Rdst,
    mem_result,
    writeback_mux_en,
    decoder_en,
    buf_MEM_WB_Rdst_o,
    buf_MEM_WB_alu_result_o,
    buf_MEM_WB_mem_result_o,
    buf_MEM_WB_writeback_en_o,
    buf_MEM_WB_decoder_en_o

);

end arch;