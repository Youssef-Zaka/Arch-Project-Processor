
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
    decoder_en_o : out std_logic;
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
PORT( Clk,Rst,En : IN std_logic;
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


begin
--processes
process 

  
end PROCESS;

--First stage
Memory_OBJ: Memory PORT MAP (
  
);

ADDER_OBJ: Adder PORT MAP (
 
);

PC_OBJ: PC_Reg Port Map (

);


BUF_IF_ID_OBJ: buf_IF_ID PORT MAP (

);


buf_MEM_WB_OBJ: buf_MEM_WB Port map(

);

end arch;