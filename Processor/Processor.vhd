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
        opcode : in std_logic_vector(3 downto 0);
        
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
        opcode_o : out std_logic_vector(3 downto 0);
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
Q : in std_logic_vector (31 DOWNTO 0);
en : in std_logic;
output: out std_logic_vector (31 DOWNTO 0)
);
END component;

--Sign extend
component signExtend IS
PORT(
data_in : in std_logic_vector (15 DOWNTO 0);
data_out: out std_logic_vector (31 DOWNTO 0)
);
END component;


--Signals 
-------------------------buf_IF_ID----------------------------------
--------------------------------------------------------------------
signal buf_IF_ID_instruction : std_logic_vector(31 downto 0);
signal buf_IF_ID_PC : std_logic_vector(31 downto 0);
signal buf_IF_ID_instruction_o : std_logic_vector(31 downto 0);
signal buf_IF_ID_PC_o : std_logic_vector(31 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------buf_ID_EX----------------------------------
--------------------------------------------------------------------
signal buf_ID_EX_Rdst : std_logic_vector(2 downto 0);
signal buf_ID_EX_Rsrc1 : std_logic_vector(31 downto 0);
signal buf_ID_EX_Rsrc2 : std_logic_vector(31 downto 0);
signal buf_ID_EX_Imm : std_logic_vector(31 downto 0);
signal buf_ID_EX_PC : std_logic_vector(31 downto 0);
signal buf_ID_EX_opcode : std_logic_vector(3 downto 0);
signal buf_ID_EX_mem_read_en : std_logic;
signal buf_ID_EX_mem_write_en : std_logic;
signal buf_ID_EX_InPort_en : std_logic;
signal buf_ID_EX_writeback_en : std_logic;
signal buf_ID_EX_Rdst_o : std_logic_vector(2 downto 0);
signal buf_ID_EX_Rsrc1_o : std_logic_vector(31 downto 0);
signal buf_ID_EX_Rsrc2_o : std_logic_vector(31 downto 0);
signal buf_ID_EX_Imm_o : std_logic_vector(31 downto 0);
signal buf_ID_EX_PC_o : std_logic_vector(31 downto 0);
signal buf_ID_EX_opcode_o : std_logic_vector(3 downto 0);
signal buf_ID_EX_mem_read_en_o : std_logic;
signal buf_ID_EX_mem_write_en_o : std_logic;
signal buf_ID_EX_InPort_en_o : std_logic;
signal buf_ID_EX_writeback_en_o : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------buf_EX_MEM----------------------------------
--------------------------------------------------------------------
signal buf_EX_MEM_alu_result : std_logic_vector(31 downto 0);
signal buf_EX_MEM_Rdst : std_logic_vector(2 downto 0);
signal buf_EX_MEM_mem_read_en : std_logic;
signal buf_EX_MEM_mem_write_en : std_logic;
signal buf_EX_MEM_writeback_en : std_logic;
signal buf_EX_MEM_alu_result_o : std_logic_vector(31 downto 0);
signal buf_EX_MEM_Rdst_o : std_logic_vector(2 downto 0);
signal buf_EX_MEM_mem_read_en_o : std_logic;
signal buf_EX_MEM_mem_write_en_o : std_logic;
signal buf_EX_MEM_writeback_en_o : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------buf_MEM_WB----------------------------------
--------------------------------------------------------------------
signal buf_MEM_WB_alu_result : std_logic_vector(31 downto 0);
signal buf_MEM_WB_Rdst : std_logic_vector(2 downto 0);
signal buf_MEM_WB_mem_result : std_logic_vector(31 downto 0);
signal buf_MEM_WB_writeback_en : std_logic;
signal buf_MEM_WB_alu_result_o : std_logic_vector(31 downto 0);
signal buf_MEM_WB_Rdst_o : std_logic_vector(2 downto 0);
signal buf_MEM_WB_mem_result_o : std_logic_vector(31 downto 0);
signal buf_MEM_WB_writeback_en_o : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Memory-------------------------------------
--------------------------------------------------------------------
signal Memory_re : std_logic;
signal Memory_we : std_logic;
signal Memory_address : std_logic_vector(31 downto 0);
signal Memory_data_in : std_logic_vector(31 downto 0);
signal Memory_data_out : std_logic_vector(31 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Flag_Registers-----------------------------
--------------------------------------------------------------------
signal Flag_Registers_Z : std_logic;
signal Flag_Registers_En : std_logic;
signal Flag_Registers_N : std_logic;
signal Flag_Registers_C : std_logic;
signal Flag_Registers_Z_o : std_logic;
signal Flag_Registers_N_o : std_logic;
signal Flag_Registers_C_o : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Reg----------------------------------------
--------------------------------------------------------------------
signal Reg_En : std_logic;
signal Reg_data : std_logic_vector(31 downto 0);
signal Reg_data_o : std_logic_vector(31 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Adder--------------------------------------
--------------------------------------------------------------------
signal Adder_PC : std_logic_vector(31 downto 0);
signal Adder_C : std_logic_vector(31 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Mux----------------------------------------
--------------------------------------------------------------------
signal Mux_in_1 : std_logic_vector(31 downto 0);
signal Mux_in_0 : std_logic_vector(31 downto 0);
signal Mux_sel : std_logic;
signal Mux_out : std_logic_vector(31 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------ALU----------------------------------------
--------------------------------------------------------------------
signal ALU_data_1 : std_logic_vector(31 downto 0);
signal ALU_data_2 : std_logic_vector(31 downto 0);
signal ALU_sel : std_logic_vector(3 downto 0);
signal ALU_cin : std_logic;
signal ALU_enable : std_logic;
signal ALU_result : std_logic_vector(31 downto 0);
signal ALU_flags : std_logic_vector(2 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Tristate-----------------------------------
--------------------------------------------------------------------
signal Tristate_Q : std_logic_vector(31 downto 0);
signal Tristate_output : std_logic_vector(31 downto 0);
signal Tristate_en : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------signExtend---------------------------------
--------------------------------------------------------------------
signal signExtend_data_out : std_logic_vector(31 downto 0);
signal signExtend_data_in : std_logic_vector(15 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------



begin


end Processor_arch;

