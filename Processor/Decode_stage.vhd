LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--Processor entity, the top level entry of this project 
entity decoder_stage is
  port (
    clk : in std_logic;
    rst : in std_logic;
    instruction : in std_logic_vector(31 downto 0);
    pc : in std_logic_vector(31 downto 0);
    decoder_enable_s: in std_logic; -- following 3 coming form wb
    decoder_sel: in std_logic_vector(2 downto 0);
    writeback_result: in std_logic_vector(31 downto 0);
    data_1 : out std_logic_vector(31 downto 0);
    data_2 : out std_logic_vector(31 downto 0);
    rdst_o : out std_logic_vector(2 downto 0);
    immediate_o : out std_logic_vector(31 downto 0);
    pc_o : out std_logic_vector(31 downto 0);
    alu_op_code : out std_logic_vector(3 downto 0);
    mem_read_o : out std_logic;
    mem_write_o : out std_logic; 
    input_o : out std_logic;
    writeback_mux_o : out std_logic;
    alu_en_o: out std_logic;
    output_o : out std_logic;
    jump_sel_o : out std_logic_vector(2 downto 0);
    decoder_enable_wb_stage : out std_logic;
    R0_o: out std_logic_vector (31 downto 0);
    R1_o: out std_logic_vector (31 downto 0);
    R2_o: out std_logic_vector (31 downto 0);
    R3_o: out std_logic_vector (31 downto 0);
    R4_o: out std_logic_vector (31 downto 0);
    R5_o: out std_logic_vector (31 downto 0);
    R6_o: out std_logic_vector (31 downto 0);
    R7_o: out std_logic_vector (31 downto 0)
  );
end decoder_stage;

architecture decode_arch of decoder_stage is
  component mux_generic IS 
Generic ( n : Integer:=32);
PORT ( in0,in1 : IN std_logic_vector (n-1 DOWNTO 0);
        sel : IN  std_logic;
        out1 : OUT std_logic_vector (n-1 DOWNTO 0)
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
jump_select: out std_logic_vector (2 downto 0);
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
Jump_select : in std_logic_vector(2 downto 0);
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
Jump_select_o : out std_logic_vector(2 downto 0);
wb_reg_enable_o: out std_logic
);
end component;

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

component Reg IS
PORT( Clk,Rst,En : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0)
 );
END component;
-----------------------------------------------
---Signals:
signal mux_data_1_s : std_logic;  -- mux data_1  mbein Rsrc1 and Rdst, 0 for Rsrc1, 1 for Rsrc2
signal mux_data_2_s : std_logic;  -- mux data_2  mbein Rsrc2 and immediate, 0 for Rsrc1, 1 for Rsrc2
signal alu_op_code_s : std_logic_vector(3 downto 0);
signal alu_enable_s : std_logic;
signal input_port_enable_s: std_logic;
signal output_port_enable_s: std_logic;
signal mem_read_enable_s: std_logic;
signal mem_write_enable_s: std_logic;
signal mux_wb_s : std_logic; -- 0 for result, 1 for memory
signal jump_select_s: std_logic_vector(2 downto 0);
signal if_id_reset_s: std_logic; -- reset and enables for buffers
signal id_ex_reset_s: std_logic;
signal ex_mem_reset_s: std_logic;
signal mem_wb_reset_s: std_logic;
signal if_id_enable_s: std_logic;  -- for hlt instruction, disable all buffers
signal id_ex_enable_s: std_logic;
signal ex_mem_enable_s: std_logic;
signal mem_wb_enable_s: std_logic;
signal wb_reg_enable_s: std_logic;  -- in write back we may not want to write in any register like in setc

signal decoder_output: std_logic_vector(7 downto 0);

signal R0_out: std_logic_vector (31 downto 0);
signal R1_out: std_logic_vector (31 downto 0);
signal R2_out: std_logic_vector (31 downto 0);
signal R3_out: std_logic_vector (31 downto 0);
signal R4_out: std_logic_vector (31 downto 0);
signal R5_out: std_logic_vector (31 downto 0);
signal R6_out: std_logic_vector (31 downto 0);
signal R7_out: std_logic_vector (31 downto 0);

signal rdst_mux_s: std_logic_vector (31 downto 0);
signal rsrc1_mux_s: std_logic_vector (31 downto 0);
signal rsrc2_mux_s: std_logic_vector (31 downto 0);
signal rdst_rsrc1_mux_s: std_logic_vector (31 downto 0);
signal immediate_rsrc2_mux_s: std_logic_vector (31 downto 0);

signal signExtend_data_out: std_logic_vector (31 downto 0);

----------------------------------------------------
begin

CU: control_unit port map (
instruction(31 downto 25),
mux_data_1_s,
mux_data_2_s,
alu_op_code_s,
alu_enable_s,
input_port_enable_s,
output_port_enable_s,
mem_read_enable_s,
mem_write_enable_s,
mux_wb_s,
jump_select_s,
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
Instruction(24 downto 22),
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
instruction(21 downto 19),
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
instruction(18 downto 16),
rsrc2_mux_s
);

-- Sign Extension
se: signExtend port map(
  instruction(15 downto 0),
signExtend_data_out
);

-- 0 rscrc1, 1 rdst
-- 0 rscrc2, 1 immediate
rdst_rsrc1_mux_s <= rsrc1_mux_s when mux_data_1_s = '0' else rdst_mux_s;
immediate_rsrc2_mux_s<= rsrc2_mux_s when mux_data_2_s = '0' else signExtend_data_out;
 
buf_id: buf_ID_EX port map(
rst,
clk,
Instruction(24 downto 22),
rdst_rsrc1_mux_s,
immediate_rsrc2_mux_s,
signExtend_data_out,
pc,
alu_op_code_s,
mem_read_enable_s,
mem_write_enable_s,
input_port_enable_s,
mux_wb_s,
alu_enable_s,
output_port_enable_s,
jump_select_s,
wb_reg_enable_s,
rdst_o,
data_1,
data_2,
immediate_o,
pc_o,
alu_op_code,
mem_read_o,
mem_write_o,
input_o,
writeback_mux_o,
alu_en_o,
output_o,
jump_sel_o,
decoder_enable_wb_stage
);

R0_o <= R0_out;
R1_o <= R1_out;
R2_o <= R2_out;
R3_o <= R3_out;
R4_o <= R4_out;
R5_o <= R5_out;
R6_o <= R6_out;
R7_o <= R7_out;


end architecture;


