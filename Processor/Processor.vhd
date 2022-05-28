LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--Processor entity, the top level entry of this project 
entity Processor is
  port (
    clk : in std_logic;
    rst : in std_logic;
    inPort: in std_logic_vector(31 downto 0)
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
Rsrc1 : in std_logic_vector(31 downto 0); -- el mfrood dah data_1 
--32 bits for Rsrc2
Rsrc2 : in std_logic_vector(31 downto 0); -- el mfrood dah data_2
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

--added

alu_en: in std_logic;
OutPort_en: in std_logic;
add_branch_mux: in std_logic;
muxresult_oldpc_mux : in std_logic;
wb_reg_enable: in std_logic;  


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
writeback_en_o : out std_logic;
alu_en_o: out std_logic;
OutPort_en_o: out std_logic;
add_branch_mux_o: out std_logic;
muxresult_oldpc_mux_o : out std_logic;
wb_reg_enable_o: out std_logic
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
        decoder_wb_en: in std_logic;
        
        --outputs for all inputs
        Rdst_o : out std_logic_vector(2 downto 0);
        alu_result_o : out std_logic_vector(31 downto 0);
        mem_read_en_o, mem_write_en_o : out std_logic;
        writeback_en_o : out std_logic;
        decoder_wb_en_o: out std_logic
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

--Flag register
component Flag_Register IS
PORT( 
    Clk,Rst,En : IN std_logic;
    c , n , z : IN std_logic;
    c_o , n_o , z_o : OUT std_logic
);
END component;

--PC register
component PC_Reg IS
PORT( Clk,Rst,En : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0) );
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
	PORT (rst : IN std_logic;
            data_1,data_2 : in std_logic_vector (31 downto 0);
	      sel: in std_logic_vector (3 downto 0);
	      cin: in std_logic;
	      alu_enable: in std_logic;
	      result: out std_logic_vector (31 downto 0);
          flag_enable: out std_logic;
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

-- Control Unit
component Control_Unit IS
PORT( opcode : IN std_logic_vector(6 downto 0); -- size op code is 7 bits
mux_data_1 : out std_logic;  -- mux data_1  mbein Rsrc1 and Rdst, 0 for Rsrc1, 1 for Rsrc2
mux_data_2 : out std_logic;  -- mux data_2  mbein Rsrc2 and immediate, 0 for Rsrc1, 1 for Rsrc2
alu_op_code : out std_logic_vector(3 downto 0);
alu_enable : out std_logic;
input_port_enable: out std_logic;
output_port_enable: out std_logic;
mem_read_enable: out std_logic;
mem_write_enable: out std_logic;
mux_wb :out std_logic; -- 0 for result, 1 for memory
mux_pc_adder_and_branch: out std_logic; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch: out std_logic; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset: out std_logic; -- reset and enables for buffers
id_ex_reset: out std_logic;
ex_mem_reset: out std_logic;
mem_wb_reset: out std_logic;
if_id_enable: out std_logic;  -- for hlt instruction, disable all buffers
id_ex_enable: out std_logic;
ex_mem_enable: out std_logic;
mem_wb_enable: out std_logic;
wb_reg_enable: out std_logic  -- in write back we may not want to write in any register like in setc
);
END component;

--mux 3x8
component mux_3x8 IS
PORT ( in0,in1,in2,in3,in4,in5,in6,in7 : IN std_logic_vector (31 DOWNTO 0);
	       sel : IN  std_logic_vector(2 downto 0);
	       out1 : OUT std_logic_vector (31 DOWNTO 0));
END component;

component decoder is
port(
sel : in std_logic_vector(2 downto 0);
enable: in std_logic;
F : out std_logic_vector(7 downto 0));
End component;


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
signal buf_ID_EX_alu_en : std_logic;
signal buf_ID_EX_outputport_en : std_logic;
signal buf_ID_EX_add_branch_mux : std_logic;
signal buf_ID_EX_muxresult_oldpc_mux : std_logic;
signal buf_ID_EX_wb_reg_enable : std_logic;

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
signal buf_ID_EX_alu_en_o : std_logic;
signal buf_ID_EX_outputport_en_o : std_logic;
signal buf_ID_EX_add_branch_mux_o : std_logic;
signal buf_ID_EX_muxresult_oldpc_mux_o : std_logic;
signal buf_ID_EX_wb_reg_enable_o : std_logic;
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
signal buf_EX_MEM_wb_reg_enable_o : std_logic;
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
signal buf_MEM_WB_decoder_en_o : std_logic;
--------------------------------------------------------------------
--------------------------------------------------------------------
-------------------------Memory-------------------------------------
--------------------------------------------------------------------
signal Memory_re : std_logic;
signal Memory_we : std_logic;
signal Memory_address : std_logic_vector(19 downto 0);
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
-------------------------PC_Reg-------------------------------------
--------------------------------------------------------------------
signal PC_Reg_En : std_logic;
signal PC_Reg_data : std_logic_vector(31 downto 0);
signal PC_Reg_data_o : std_logic_vector(31 downto 0);
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
signal ALU_flag_enable : std_logic;
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
--signal signExtend_data_in : std_logic_vector(15 downto 0);
--------------------------------------------------------------------
--------------------------------------------------------------------
--CU Signals --------------------------------------------------------
---------------------------------------------------------------------
signal mux_data_1_s : std_logic;  -- mux data_1  mbein Rsrc1 and Rdst, 0 for Rsrc1, 1 for Rsrc2
signal mux_data_2_s : std_logic;  -- mux data_2  mbein Rsrc2 and immediate, 0 for Rsrc1, 1 for Rsrc2
signal alu_op_code_s : std_logic_vector(3 downto 0);
signal alu_enable_s : std_logic;
signal input_port_enable_s: std_logic;
signal output_port_enable_s: std_logic;
signal mem_read_enable_s: std_logic;
signal mem_write_enable_s: std_logic;
signal mux_wb_s : std_logic; -- 0 for result, 1 for memory
signal mux_pc_adder_and_branch_s: std_logic; -- 0 is pc adder, 1 is branching
signal mux_PcOld_mux_adderAndBranch_s: std_logic; -- 1 is old pc, 0 is result of mux branch and pc adder
signal if_id_reset_s: std_logic; -- reset and enables for buffers
signal id_ex_reset_s: std_logic;
signal ex_mem_reset_s: std_logic;
signal mem_wb_reset_s: std_logic;
signal if_id_enable_s: std_logic;  -- for hlt instruction, disable all buffers
signal id_ex_enable_s: std_logic;
signal ex_mem_enable_s: std_logic;
signal mem_wb_enable_s: std_logic;
signal wb_reg_enable_s: std_logic;  -- in write back we may not want to write in any register like in setc
----------------------------------------------------------------------
----------------------------------------------------------------------
-----------------------------Decoder Sinals---------------------------
signal decoder_enable_s: std_logic;
signal decoder_sel: std_logic_vector(2 downto 0);
signal decoder_output: std_logic_vector(7 downto 0);
----------------------------------------------------------------------
---------------------------Registers' Signals ------------------------
----------------------------------------------------------------------
signal writeback_result: std_logic_vector(31 downto 0); -- wb stage result
signal R0_out: std_logic_vector (31 downto 0);
signal R1_out: std_logic_vector (31 downto 0);
signal R2_out: std_logic_vector (31 downto 0);
signal R3_out: std_logic_vector (31 downto 0);
signal R4_out: std_logic_vector (31 downto 0);
signal R5_out: std_logic_vector (31 downto 0);
signal R6_out: std_logic_vector (31 downto 0);
signal R7_out: std_logic_vector (31 downto 0);
----------------------------------------------------------------------
--------------------Stage 2 mux signals-------------------------------
-----------------------------------------------------------------------
signal rdst_mux_s: std_logic_vector (31 downto 0);
signal rsrc1_mux_s: std_logic_vector (31 downto 0);
signal rsrc2_mux_s: std_logic_vector (31 downto 0);
signal rdst_rsrc1_mux_s: std_logic_vector (31 downto 0);
signal immediate_rsrc2_mux_s: std_logic_vector (31 downto 0);
----------------------------------------------------------------------
----------------------------------------------------------------------
----micilanious signals ----------------------------------------------
----------------------------------------------------------------------
signal OutputPort: std_logic_vector(31 downto 0);
signal state : std_logic_vector(2 downto 0):= "000";



----------------------------------------------------------------------
begin


   --processes 

   PROCESS
   BEGIN
   wait until (rising_edge(Clk));
       IF rst = '1' THEN
           Memory_address <= (others => '0');
           PC_Reg_data <= Memory_data_out;
           Adder_PC <= std_logic_vector(to_signed((to_integer(signed(Memory_data_out)) - 1),32));
           buf_IF_ID_instruction <= (others => '0');
           buf_IF_ID_PC <= (others => '0');
       ELSE
           Memory_address <= PC_Reg_data_o(19 downto 0);
           PC_Reg_data <= Adder_C;
           Adder_PC <= PC_Reg_data_o;
           buf_IF_ID_instruction <= MEMORY_data_out;
           buf_IF_ID_PC <= PC_Reg_data_o;
       END IF;
   END PROCESS;

   --First stage
   Memory_OBJ: Memory PORT MAP (
       clk,
       Memory_we,
       Memory_re,
       Memory_address,
       Memory_data_in,
       Memory_data_out
   );
   
   Memory_we <= '0';
   Memory_re <= '1';


   ADDER_OBJ: Adder PORT MAP (
       Adder_PC,
       Adder_C
   );
   
   
   PC_OBJ: PC_Reg Port Map (
       clk,rst,
       PC_Reg_En,
       Adder_C,
       PC_Reg_data_o
   );
   PC_Reg_En <= '1';


   BUF_IF_ID_OBJ: buf_IF_ID PORT MAP (
       rst,
       clk,
       buf_IF_ID_instruction,
       buf_IF_ID_PC,
       buf_IF_ID_instruction_o,
       buf_IF_ID_PC_o
   );

-------------------------------------------------------------------------------
-- Second stage (Decode) 
-------------------------------------------------------------------------------

CU: control_unit port map (
buf_IF_ID_instruction_o(31 downto 25),
mux_data_1_s,
mux_data_2_s,
alu_op_code_s,
alu_enable_s,
input_port_enable_s,
output_port_enable_s,
mem_read_enable_s,
mem_write_enable_s,
mux_wb_s,
mux_pc_adder_and_branch_s,
mux_PcOld_mux_adderAndBranch_s,
if_id_reset_s,
id_ex_reset_s,
ex_mem_reset_s,
mem_wb_reset_s,
if_id_enable_s,
id_ex_enable_s,
ex_mem_enable_s,
mem_wb_enable_s,
wb_reg_enable_s
);

-- Decoder

dec: decoder port map(
decoder_sel,-- gbhm mn wb
decoder_enable_s,  -- gbhm mn wb
decoder_output
);

--R0
R0: reg port map(
Clk,
Rst,
decoder_output(0),
writeback_result,
R0_out
);

--R1
R1: reg port map(
Clk,
Rst,
decoder_output(1),
writeback_result,
R1_out
);

--R2
R2: reg port map(
Clk,
Rst,
decoder_output(2),
writeback_result,
R2_out
);

--R3
R3: reg port map(
Clk,
Rst,
decoder_output(3),
writeback_result,
R3_out
);

--R4
R4: reg port map(
Clk,
Rst,
decoder_output(4),
writeback_result,
R4_out
);

--R5
R5: reg port map(
Clk,
Rst,
decoder_output(5),
writeback_result,
R5_out
);

--R6
R6: reg port map(
Clk,
Rst,
decoder_output(6),
writeback_result,
R6_out
);

--R7
R7: reg port map(
Clk,
Rst,
decoder_output(7),
writeback_result,
R7_out
);

--Rdst_mux : 
Rdst_mux: mux_3x8 port map (
R0_out,
R1_out,
R2_out,
R3_out,
R4_out,
R5_out,
R6_out,
R7_out,
buf_IF_ID_instruction_o(24 downto 22),
rdst_mux_s
);

--Rsrc1_mux : 
Rsrc1_mux: mux_3x8 port map (
R0_out,
R1_out,
R2_out,
R3_out,
R4_out,
R5_out,
R6_out,
R7_out,
buf_IF_ID_instruction_o(21 downto 19),
rsrc1_mux_s
);

--Rsrc2_mux : 
Rsrc2_mux: mux_3x8 port map (
R0_out,
R1_out,
R2_out,
R3_out,
R4_out,
R5_out,
R6_out,
R7_out,
buf_IF_ID_instruction_o(18 downto 16),
rsrc2_mux_s
);

-- Sign Extension
se: signExtend port map(
buf_IF_ID_instruction_o(15 downto 0),
signExtend_data_out
);

-- mux rdst m3 rsrc1
rdst_rsc1: mux_generic Generic Map(32) port map(
rdst_mux_s,
rsrc1_mux_s,
mux_data_1_s,
rdst_rsrc1_mux_s
);

-- mux rscr2 m3 immediate
imm_rsc2: mux_generic Generic Map(32) port map(
rsrc2_mux_s,
signExtend_data_out,
mux_data_2_s,
immediate_rsrc2_mux_s
);

-- buffer ID_EX
PROCESS
    BEGIN
    wait until (rising_edge(Clk));
        IF rst = '1' THEN
            buf_ID_EX_Rdst <= (others=>'0');
            buf_ID_EX_Rsrc1 <= (others=>'0');
            buf_ID_EX_Rsrc2 <= (others=>'0');
            buf_ID_EX_IMM <= (others=>'0');
            buf_ID_EX_PC <= (others=>'0');
            buf_ID_EX_opcode <= (others=>'0');
            buf_ID_EX_mem_read_en <='0';
            buf_ID_EX_mem_write_en <='0';
            buf_ID_EX_InPort_en <='0';
            buf_ID_EX_writeback_en <='0';
            buf_ID_EX_alu_en <='0';
            buf_ID_EX_outputport_en <='0';
            buf_ID_EX_add_branch_mux <='0';
            buf_ID_EX_muxresult_oldpc_mux <='0';
            buf_ID_EX_wb_reg_enable <='0';
        ELSE
            buf_ID_EX_Rdst <= buf_IF_ID_instruction_o(24 downto 22);
            buf_ID_EX_Rsrc1 <= rdst_rsrc1_mux_s;
            buf_ID_EX_Rsrc2 <= immediate_rsrc2_mux_s;
            buf_ID_EX_IMM <= signExtend_data_out;
            buf_ID_EX_PC <= buf_IF_ID_PC_o;
            buf_ID_EX_opcode <= alu_op_code_s;
            buf_ID_EX_mem_read_en <= mem_read_enable_s;
            buf_ID_EX_mem_write_en <=mem_write_enable_s;
            buf_ID_EX_InPort_en <=input_port_enable_s;
            buf_ID_EX_writeback_en <=mux_wb_s;
            buf_ID_EX_alu_en <=alu_enable_s;
            buf_ID_EX_outputport_en <=output_port_enable_s;
            buf_ID_EX_add_branch_mux <=mux_pc_adder_and_branch_s;
            buf_ID_EX_muxresult_oldpc_mux <=mux_PcOld_mux_adderAndBranch_s;
            buf_ID_EX_wb_reg_enable <= wb_reg_enable_s;
        END IF;
    END PROCESS;


buf_id: buf_ID_EX port map(
rst,
clk,
buf_ID_EX_Rdst,
buf_ID_EX_Rsrc1,
buf_ID_EX_Rsrc2,
buf_ID_EX_Imm,
buf_ID_EX_PC,
buf_ID_EX_opcode,
buf_ID_EX_mem_read_en,
buf_ID_EX_mem_write_en,
buf_ID_EX_InPort_en,
buf_ID_EX_writeback_en,
buf_ID_EX_alu_en,
buf_ID_EX_outputport_en,
buf_ID_EX_add_branch_mux,
buf_ID_EX_muxresult_oldpc_mux,
buf_ID_EX_wb_reg_enable,
buf_ID_EX_Rdst_o,
buf_ID_EX_Rsrc1_o,
buf_ID_EX_Rsrc2_o,
buf_ID_EX_Imm_o,
buf_ID_EX_PC_o,
buf_ID_EX_opcode_o,
buf_ID_EX_mem_read_en_o,
buf_ID_EX_mem_write_en_o,
buf_ID_EX_InPort_en_o,
buf_ID_EX_writeback_en_o,
buf_ID_EX_alu_en_o,
buf_ID_EX_outputport_en_o,
buf_ID_EX_add_branch_mux_o,
buf_ID_EX_muxresult_oldpc_mux_o,
buf_ID_EX_wb_reg_enable_o
);

---------------------------------------------------------
---------------------------------------------------------

-------------------------------------------------------------------------------
-- Third stage (ALU) 
-------------------------------------------------------------------------------
ALU_OBJ: ALU port map(
    rst,
    buf_ID_EX_Rsrc1_o,
    buf_ID_EX_Rsrc2_o,
    buf_ID_EX_opcode_o,
    Flag_Registers_C_o,
    buf_ID_EX_alu_en_o,
    ALU_result,
    ALU_flag_enable,
    --carry - zero - negative
    ALU_flags
 );

 buf_EX_MEM_alu_result <= ALU_result when buf_ID_EX_InPort_en_o = '0'
                          else inPort;

Flag_register_OBJ: Flag_Register port map(
    clk, rst, ALU_flag_enable,
    ALU_flags(2),
    ALU_flags(0),
    ALU_flags(1),
    Flag_Registers_C_o,
    Flag_Registers_N_o,
    Flag_Registers_Z_o
);

Tristate_OBJ: triState Port Map (
    buf_EX_MEM_alu_result,
    buf_ID_EX_outputport_en_o,
    Tristate_output
);

OutputPortRegister: reg Port Map (
    clk, rst, buf_ID_EX_outputport_en_o,
    Tristate_output,
    OutputPort
);

buf_EX: buf_EX_MEM port map(
    rst,
    clk,
    buf_EX_MEM_alu_result,
    buf_ID_EX_Rdst_o,
    buf_ID_EX_mem_read_en_o,
    buf_ID_EX_mem_write_en_o,
    buf_ID_EX_writeback_en_o,
    buf_ID_EX_wb_reg_enable_o,
    buf_EX_MEM_Rdst_o,
    buf_EX_MEM_alu_result_o,
    buf_EX_MEM_mem_read_en_o,
    buf_EX_MEM_mem_write_en_o,
    buf_EX_MEM_writeback_en_o,
    buf_EX_MEM_wb_reg_enable_o
);
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Fourth stage (MEM) 
-------------------------------------------------------------------------------







buf_MEM_WB_OBJ: buf_MEM_WB port map(
    rst,
    clk,
    buf_EX_MEM_alu_result_o,
    buf_EX_MEM_Rdst_o,
    Memory_data_out,
    buf_EX_MEM_writeback_en_o,
    buf_EX_MEM_wb_reg_enable_o,
    buf_MEM_WB_Rdst_o,
    buf_MEM_WB_alu_result_o,
    buf_MEM_WB_mem_result_o,
    buf_MEM_WB_writeback_en_o,
    buf_MEM_WB_decoder_en_o
);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Fifth stage (MEM) 
-------------------------------------------------------------------------------
writeback_result <=  buf_MEM_WB_alu_result_o when buf_MEM_WB_writeback_en_o = '0'
                          else buf_MEM_WB_mem_result_o;
decoder_sel <= buf_MEM_WB_Rdst_o;
decoder_enable_s <= buf_MEM_WB_decoder_en_o;




-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
end Processor_arch;

