LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Control_Unit IS
PORT( opcode : IN std_logic_vector(6 downto 0); -- size op code is 7 bits
mux_data_1 : out std_logic;  -- mux data_1  mbein Rsrc1 and Rdst, 0 for Rsrc1, 1 for Rsrc2
mux_data_2 : out std_logic;  -- mux data_2  mbein Rsrc2 and immediate, 0 for Rsrc2, 1 for immediate
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
END Control_Unit;

ARCHITECTURE cuarch OF Control_Unit IS
BEGIN
PROCESS (opcode)
BEGIN

-- NOP

if (opcode = "0000000") then 
mux_data_1 <= '0';
mux_data_2 <= '0';
alu_op_code <= "0110";
alu_enable <= '0';
input_port_enable <= '0';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0';
mux_PcOld_mux_adderAndBranch <= '0';
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '1';
id_ex_enable <= '1';
ex_mem_enable <= '1';
mem_wb_enable <= '1';
wb_reg_enable <= '0';
end if;

-- HLT

if (opcode = "0000001") then 
mux_data_1 <= '0';
mux_data_2 <= '0';
alu_op_code <= "0110";
alu_enable <= '0';
input_port_enable <= '0';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '1'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '0';
id_ex_enable <= '0';
ex_mem_enable <= '0';
mem_wb_enable <= '0';
wb_reg_enable <= '0';
end if;

-- setc

if (opcode = "0000010") then 
mux_data_1 <= '0';
mux_data_2 <= '0';
alu_op_code <= "0111";
alu_enable <= '1';
input_port_enable <= '0';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '0'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '0';
id_ex_enable <= '0';
ex_mem_enable <= '0';
mem_wb_enable <= '0';
wb_reg_enable <= '0';
end if;

-- NOT

if (opcode = "0100000") then 
mux_data_1 <= '1';
mux_data_2 <= '0';
alu_op_code <= "0000"; -- opcode not
alu_enable <= '1';
input_port_enable <= '0';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '0'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '1';
id_ex_enable <= '1';
ex_mem_enable <= '1';
mem_wb_enable <= '1';
wb_reg_enable <= '1';
end if;

-- INC

if (opcode = "0100001") then 
mux_data_1 <= '1';
mux_data_2 <= '0';
alu_op_code <= "0001"; -- opcode not
alu_enable <= '1';
input_port_enable <= '0';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '0'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '1';
id_ex_enable <= '1';
ex_mem_enable <= '1';
mem_wb_enable <= '1';
wb_reg_enable <= '1';
end if;

-- out

if (opcode = "1100001") then 
mux_data_1 <= '1';
mux_data_2 <= '0';
alu_op_code <= "0101"; -- opcode not
alu_enable <= '1';
input_port_enable <= '0';
output_port_enable <= '1';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '0'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '1';
id_ex_enable <= '1';
ex_mem_enable <= '1';
mem_wb_enable <= '1';
wb_reg_enable <= '0';
end if;

-- IN

if (opcode = "0100011") then 
mux_data_1 <= '1';
mux_data_2 <= '0';
alu_op_code <= "0101";
alu_enable <= '1';
input_port_enable <= '1';
output_port_enable <= '0';
mem_read_enable <= '0';
mem_write_enable <= '0';
mux_wb <= '0';
mux_pc_adder_and_branch <= '0'; -- 0 is pc adder, 1 is branching
mux_PcOld_mux_adderAndBranch <= '0'; -- 1 is old pc, 0 is result of mux branch and pc adder
if_id_reset <= '0';
id_ex_reset <= '0';
ex_mem_reset <= '0';
mem_wb_reset <= '0';
if_id_enable <= '1';
id_ex_enable <= '1';
ex_mem_enable <= '1';
mem_wb_enable <= '1';
wb_reg_enable <= '0';
end if;

END PROCESS;
END Architecture;
