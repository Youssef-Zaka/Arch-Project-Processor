
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--fetch and memory stages
entity fetch_stage is 
port(
    clk,rst : in std_logic;
    Interrupt : in std_logic;
    Alu_result : in std_logic_vector(31 downto 0);
    Rdst : in std_logic_vector(2 downto 0);
    writeback_mux_en : in std_logic;
    decoder_en : in std_logic; 
    mem_read_en : in std_logic;
    mem_write_en : in std_logic;

    jump_en : in std_logic;
    jump_target : in std_logic_vector(31 downto 0);
    
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

signal SP : std_logic_vector(19 downto 0);
signal SP_minus_one : std_logic_vector(19 downto 0);

--variables

begin
--processes


process (clk,rst,Interrupt)
variable PC_Input : std_logic_vector(31 downto 0);
variable Adder_input : std_logic_vector(31 downto 0);
variable Memory_Address_input : std_logic_vector(19 downto 0);
variable Output_of_Memory : std_logic_vector(31 downto 0);
begin
    Output_of_Memory := data_out;
    PC_Input := PC_Plus_One;
    if Interrupt = '1' then
        we <= '1';
        Memory_Address_input := SP;
        data_in <= pc_data;

        we <= '0';
        --Memory
        Memory_Address_input := "00000000000000000001";
        Output_of_Memory := data_out;

        --PC register
        PC_Input := PC_Plus_One;

        --Adder
        -- output of memory - 1
        Adder_input :=  std_logic_vector(to_signed((to_integer(signed(Output_of_Memory)) - 1),32));

        --buf_IF_ID
        buf_IF_ID_instruction<= Output_of_Memory;
        buf_IF_ID_PC <= "00000000000000000000000000000001";
        

        SP_minus_one <= std_logic_vector(to_signed((to_integer(signed(SP)) - 1),20));
        SP <= SP_minus_one;

        
    end if;
    if rst = '1' then
        SP <= (others => '1');
        we <= '0';
        --Memory
        Memory_Address_input := (others => '0');
        Output_of_Memory := data_out;

        --PC register
        PC_Input := PC_Plus_One;

        --Adder
        -- output of memory - 1
        Adder_input :=  std_logic_vector(to_signed((to_integer(signed(Output_of_Memory)) - 1),32));

        --buf_IF_ID
        buf_IF_ID_instruction<= (others => '0');
        buf_IF_ID_PC <= (others => '0');
    end IF; 
    if rst = '0' and mem_read_en = '0' and mem_write_en = '0' and Interrupt = '0' then
        --PC register
        PC_Input := PC_Plus_One;

        --Adder
        Adder_input := pc_data;

        --Memory
        Memory_Address_input := pc_data (19 downto 0);
        we <= '0';
        
         --buf_IF_ID
         buf_IF_ID_instruction<= Output_of_Memory;
         buf_IF_ID_PC <= pc_data;
end if;

    if rst = '0' and mem_read_en = '0' and mem_write_en = '0' and Interrupt = '0' and jump_en = '1' then
     --Memory
     Memory_Address_input := jump_target(19 downto 0);
     Output_of_Memory := data_out;

     --PC register
     PC_Input := PC_Plus_One;

     --Adder
     -- output of memory - 1
     Adder_input :=  std_logic_vector(to_signed((to_integer(signed(Output_of_Memory)) - 1),32));

     --buf_IF_ID
     buf_IF_ID_instruction<= Output_of_Memory;
     buf_IF_ID_PC <= jump_target;    


    end if;

address <= Memory_Address_input;
PC <= Adder_input;
PC_data <= PC_Input;
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
mem_result <= data_out;

re <= '1';


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
instruction_o <= buf_IF_ID_instruction_o;
pc_o <= buf_IF_ID_PC_o;


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
Rdst_o <= buf_MEM_WB_Rdst_o;
alu_result_o <= buf_MEM_WB_alu_result_o;
memory_result_o <= buf_MEM_WB_mem_result_o;
writeback_mux_en_o <= buf_MEM_WB_writeback_en_o;
decoder_en_o <= buf_MEM_WB_decoder_en_o;

end architecture;