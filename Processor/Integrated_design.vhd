
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


--Main entity
ENTITY Integrated_Design is 
Port(
    clk, rst : in std_logic;
    input_port : in std_logic_vector(31 downto 0);
    output_port : out std_logic_vector(31 downto 0);
    R0: out std_logic_vector(31 downto 0);
    R1: out std_logic_vector(31 downto 0);
    R2: out std_logic_vector(31 downto 0);
    R3: out std_logic_vector(31 downto 0);
    R4: out std_logic_vector(31 downto 0);
    R5: out std_logic_vector(31 downto 0);
    R6: out std_logic_vector(31 downto 0);
    R7: out std_logic_vector(31 downto 0);
    Cf: out std_logic;
    Nf: out std_logic;
    Zf: out std_logic
);
end Integrated_Design;


ARCHITECTURE Arch of Integrated_Design is

--List of all compontnets in the design

Component fetch_stage is 
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
end Component;

Component decoder_stage is
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
      adder_branch_mux_o : out std_logic;
      result_adder_branch_mux_with_old_pc : out std_logic;
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
end Component;

Component execute_stage is
    PORT(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        InPort : IN STD_LOGIC_VECTOR(31 downto 0);
        data_1_o : in std_logic_vector(31 downto 0);
        data_2_o : in std_logic_vector(31 downto 0);
        rdst_o : in std_logic_vector(2 downto 0);
        immediate_o : in std_logic_vector(31 downto 0);
        pc_o : in std_logic_vector(31 downto 0);
        alu_op_code : in std_logic_vector(3 downto 0);
        mem_read_o : in std_logic;
        mem_write_o : in std_logic; 
        input_o : in std_logic;
        writeback_mux_o : in std_logic;
        alu_en_o: in std_logic;
        output_o : in std_logic;
        adder_branch_mux_o : in std_logic;
        result_adder_branch_mux_with_old_pc : in std_logic;
        decoder_enable_wb_stage : in std_logic;
        Alu_result : out std_logic_vector(31 downto 0);
        Rdst : out std_logic_vector(2 downto 0);
        mem_read : out std_logic;
        mem_write : out std_logic;
        writeback_mux : out std_logic;
        decoder_enable : out std_logic;
        OutputPort : out STD_LOGIC_VECTOR(31 downto 0);
        C : out std_logic;
        N : out std_logic;
        Z : out std_logic
        );
end Component;

Component wb_stage is
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
end Component;


--Signals for the components

--Fetch - Mem -- Outputs
signal Fetch_Decode_instruction : std_logic_vector(31 downto 0);
signal Fetch_Decode_pc : std_logic_vector(31 downto 0);
signal MEM_WB_Rdst : std_logic_vector(2 downto 0);
signal MEM_WB_mem_result : std_logic_vector(31 downto 0);
signal MEM_WB_ALU_result : std_logic_vector(31 downto 0);
signal MEM_WB_writeback_mux : std_logic;
signal MEM_WB_decoder_enable : std_logic;


--Decode - Execute -- outputs
signal Decode_EX_data_1 : std_logic_vector(31 downto 0);
signal Decode_EX_data_2 : std_logic_vector(31 downto 0);
signal Decode_EX_rdst : std_logic_vector(2 downto 0);
signal Decode_EX_immediate : std_logic_vector(31 downto 0);
signal Decode_EX_pc : std_logic_vector(31 downto 0);
signal Decode_EX_alu_op_code : std_logic_vector(3 downto 0);
signal Decode_EX_mem_read : std_logic;
signal Decode_EX_mem_write : std_logic;
signal Decode_EX_input : std_logic;
signal Decode_EX_writeback_mux : std_logic;
signal Decode_EX_alu_en : std_logic;
signal Decode_EX_output : std_logic;
signal Decode_EX_adder_branch_mux : std_logic;
signal Decode_EX_result_adder_branch_mux_with_old_pc : std_logic;
signal Decode_EX_decoder_enable_wb_stage : std_logic;

--Execute - MEMORY -- outputs
signal EX_MEM_ALU_result : std_logic_vector(31 downto 0);
signal EX_MEM_Rdst : std_logic_vector(2 downto 0);
signal EX_MEM_wtieback_mux_en : std_logic;
signal EX_MEM_decoder_en : std_logic;
signal EX_MEM_mem_read_en : std_logic;
signal EX_MEM_mem_write_en : std_logic;

-- --Memory - Writeback -- outputs
-- signal MEM_WB_ALU_result : std_logic_vector(31 downto 0);
-- signal MEM_WB_Rdst : std_logic_vector(2 downto 0);
-- signal MEM_WB_writeback_mux : std_logic;
-- signal MEM_WB_decoder_en : std_logic;
-- signal MEM_WB_mem_result : std_logic_vector(31 downto 0);

--WriteBack -- Fetch -- outputs
Signal WB_Decode_writeback_result : std_logic_vector(31 downto 0);
Signal WB_Decode_rdst : std_logic_vector(2 downto 0);
Signal WB_Decode_decoder_en : std_logic;



begin
    FETCH_MEM_BUF: fetch_stage Port Map (
        clk,rst,
        EX_MEM_ALU_result,
        EX_MEM_Rdst,
        EX_MEM_wtieback_mux_en,
        EX_MEM_decoder_en,
        EX_MEM_mem_read_en,
        EX_MEM_mem_write_en,
        Fetch_Decode_instruction,
        Fetch_Decode_pc,
        MEM_WB_Rdst,
        MEM_WB_ALU_result,
        MEM_WB_mem_result,
        MEM_WB_writeback_mux,
        MEM_WB_decoder_enable
     );

    DECODE_EX_BUF: decoder_stage Port Map (
        clk,rst,
        Fetch_Decode_instruction,
        Fetch_Decode_pc,
        WB_Decode_decoder_en,
        WB_Decode_rdst,
        WB_Decode_writeback_result,
        Decode_EX_data_1,
        Decode_EX_data_2,
        Decode_EX_rdst,
        Decode_EX_immediate,
        Decode_EX_pc,
        Decode_EX_alu_op_code,
        Decode_EX_mem_read,
        Decode_EX_mem_write,
        Decode_EX_input,
        Decode_EX_writeback_mux,
        Decode_EX_alu_en,
        Decode_EX_output,
        Decode_EX_adder_branch_mux,
        Decode_EX_result_adder_branch_mux_with_old_pc,
        Decode_EX_decoder_enable_wb_stage,
        R0,
        R1,
        R2,
        R3,
        R4,
        R5,
        R6,
        R7
    );

    EX_MEM_BUF: execute_stage Port Map (
        clk,rst,
        input_port,
        Decode_EX_data_1,
        Decode_EX_data_2,
        Decode_EX_rdst,
        Decode_EX_immediate,
        Decode_EX_pc,
        Decode_EX_alu_op_code,
        Decode_EX_mem_read,
        Decode_EX_mem_write,
        Decode_EX_input,
        Decode_EX_writeback_mux,
        Decode_EX_alu_en,
        Decode_EX_output,
        Decode_EX_adder_branch_mux,
        Decode_EX_result_adder_branch_mux_with_old_pc,
        Decode_EX_decoder_enable_wb_stage,
        EX_MEM_ALU_result,
        EX_MEM_Rdst,
        EX_MEM_mem_read_en,
        EX_MEM_mem_write_en,
        EX_MEM_wtieback_mux_en,
        EX_MEM_decoder_en,
        output_port,
        Cf,
        Nf,
        Zf
    );

    MEM_WB_BUF: wb_stage Port Map (
        MEM_WB_mem_result,
        MEM_WB_ALU_result,
        MEM_WB_Rdst,
        MEM_WB_writeback_mux,
        MEM_WB_decoder_enable,
        WB_Decode_writeback_result,
        WB_Decode_rdst,
        WB_Decode_decoder_en
    );


end Arch;

