LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


--Execute stage entity declaration
ENTITY execute_stage is
PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    InPort : IN STD_LOGIC_VECTOR(31 downto 0);
    data_1 : in std_logic_vector(31 downto 0);
    data_2 : in std_logic_vector(31 downto 0);
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
    OutputPort : out STD_LOGIC_VECTOR(31 downto 0)
    );
    end execute_stage;


--architecture execute_stage_arch of execute_stage is
--begin
--end execute_stage_arch;

architecture    execute_stage_arch of execute_stage is 
--Flag register
component flagReg IS
PORT( 
    Clk,Rst,En : IN std_logic;
    c , n , z : IN std_logic;
    c_o , n_o , z_o : OUT std_logic
);
END component;

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

--TriState 
component triState IS
PORT(
Q : in std_logic_vector (31 DOWNTO 0);
en : in std_logic;
output: out std_logic_vector (31 DOWNTO 0)
);
END component;

--Register
component Reg IS
PORT( Clk,Rst,En : IN std_logic;
data: IN std_logic_vector (31 downto 0) ;
data_out: OUT std_logic_vector (31 downto 0)
 );
END component;


--ALU
component ALU IS
	PORT (data_1,data_2 : in std_logic_vector (31 downto 0);
	      sel: in std_logic_vector (3 downto 0);
	      cin: in std_logic;
	      alu_enable: in std_logic;
	      result: out std_logic_vector (31 downto 0);
          flag_enable: out std_logic;
              flags: out std_logic_vector (2 downto 0)
              );
END component;


--signals
signal Cin : std_logic;
signal N_flag : std_logic;
signal Z_flag : std_logic;
signal flagsEn : std_logic;
signal flags : std_logic_vector(2 downto 0);
signal ResultfromALu: std_logic_vector(31 downto 0);
signal data_out_reg : std_logic_vector(31 downto 0);
signal Alu_result_bef_buf : std_logic_vector(31 downto 0);

begin

    ALU_OBJ: ALU port map(data_1, data_2, alu_op_code, Cin, alu_en_o, ResultfromALu, flagsEn, flags); 
    Flag_Register_OBJ: flagReg port map(clk,rst,flagsEn, flags(2),flags(0),flags(1), Cin, N_flag, Z_flag);


    Alu_result_bef_buf <= ResultfromALu when input_o = '0' else InPort;
    
    OutReg: reg port map (clk,rst,output_o,Alu_result_bef_buf, data_out_reg);

    buf: buf_EX_MEM port map(rst, clk, Alu_result_bef_buf, rdst_o, mem_read_o, mem_write_o, writeback_mux_o,decoder_enable_wb_stage, Rdst, Alu_result, mem_read, mem_write, writeback_mux, decoder_enable);

    OutputPort <= data_out_reg;

end execute_stage_arch;
