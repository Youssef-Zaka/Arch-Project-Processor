LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--Processor entity, the top level entry of this project 
entity Processor is
  port (
    clk : in std_logic;
    rst : in std_logic
  );
end Processor;

--Processor architecture
architecture Processor_arch of Processor is
--components of the processor 

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

--buf_ID_EX
component buf_ID_EX is
    port(
        rst, clk : in std_logic;

        --3 bits for Rdst
        Rdst : in std_logic_vector(2 downto 0);
        --32 bits for Rsrc1
        Rsrc1 : in std_logic_vector(31 downto 0);
        --32 bits for Rsrc2
        Rsrc2 : in std_logic_vector(31 downto 0);
        --32 bits for Imm
        Imm : in std_logic_vector(31 downto 0);
        --32 bits for PC
        PC : in std_logic_vector(31 downto 0);
        -- 3 bits for opcode
        opcode : in std_logic_vector(2 downto 0);
        
        --1 bit enables for mem read and write
        mem_read_en, mem_write_en : in std_logic;
        --1 bit enable for input port
        InPort_en : in std_logic;
        --1 bit enable writeback
        writeback_en : in std_logic;
        
        --pass the inputs to the output of the buffer
        Rdst_o : out std_logic_vector(2 downto 0);
        Rsrc1_o : out std_logic_vector(31 downto 0);
        Rsrc2_o : out std_logic_vector(31 downto 0);
        Imm_o : out std_logic_vector(31 downto 0);
        PC_o : out std_logic_vector(31 downto 0);
        opcode_o : out std_logic_vector(2 downto 0);
        mem_read_en_o : out std_logic;
        mem_write_en_o : out std_logic;
        InPort_en_o : out std_logic;
        writeback_en_o : out std_logic
        );
end component;

--buf_EX_MEM
component buf_EX_MEM is
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
        
        --outputs for all inputs
        Rdst_o : out std_logic_vector(2 downto 0);
        alu_result_o : out std_logic_vector(31 downto 0);
        mem_read_en_o, mem_write_en_o : out std_logic;
        writeback_en_o : out std_logic
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
        
        --outputs for all inputs
        Rdst_o : out std_logic_vector(2 downto 0);
        alu_result_o : out std_logic_vector(31 downto 0);
        mem_result_o : out std_logic_vector(31 downto 0);
        writeback_en_o : out std_logic
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

--Flag register
component Flag_Register IS
PORT( 
    Clk,Rst,En : IN std_logic;
    c , n , z : IN std_logic;
    c_o , n_o , z_o : OUT std_logic
);
END component;

--Register
component Reg IS
PORT( Clk,Rst,En : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0)
 );
END component;

--Adder
component Adder is
    port(
        PC : in std_logic_vector(31 downto 0);
        c : out std_logic_vector(31 downto 0)
    );
end component;

--Mux
component mux_generic IS 
Generic ( n : Integer:=32);
PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
        sel : IN  std_logic;
        out1 : OUT std_logic_vector (n-1 DOWNTO 0)
        );
END component;

--ALU
component ALU IS
	PORT (data_1,data_2 : in std_logic_vector (31 downto 0);
	      sel: in std_logic_vector (3 downto 0);
	      cin: in std_logic;
	      alu_enable: in std_logic;
	      result: out std_logic_vector (31 downto 0);
              flags: out std_logic_vector (2 downto 0)
              );
END component;

--TriState 
component triState IS
PORT(
Q : in std_logic_vector (2 DOWNTO 0);
en : in std_logic;
output: out std_logic_vector (2 DOWNTO 0)
);
END component;

--Sign extend
component signExtend IS
PORT(
data_in : in std_logic_vector (15 DOWNTO 0);
data_out: out std_logic_vector (31 DOWNTO 0)
);
END component;

begin


end Processor_arch;
