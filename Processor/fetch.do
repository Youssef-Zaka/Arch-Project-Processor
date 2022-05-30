vsim -gui work.fetch_stage
# vsim -gui work.fetch_stage 
# Start time: 08:04:12 on May 30,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.fetch_stage(arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
add wave -position insertpoint  \
sim:/fetch_stage/clk \
sim:/fetch_stage/rst \
sim:/fetch_stage/Interrupt \
sim:/fetch_stage/Alu_result \
sim:/fetch_stage/Rdst \
sim:/fetch_stage/writeback_mux_en \
sim:/fetch_stage/decoder_en \
sim:/fetch_stage/mem_read_en \
sim:/fetch_stage/mem_write_en \
sim:/fetch_stage/jump_en \
sim:/fetch_stage/jump_target \
sim:/fetch_stage/instruction_o \
sim:/fetch_stage/pc_o \
sim:/fetch_stage/Rdst_o \
sim:/fetch_stage/Alu_result_o \
sim:/fetch_stage/memory_result_o \
sim:/fetch_stage/writeback_mux_en_o \
sim:/fetch_stage/decoder_en_o \
sim:/fetch_stage/we \
sim:/fetch_stage/re \
sim:/fetch_stage/address \
sim:/fetch_stage/data_in \
sim:/fetch_stage/data_out \
sim:/fetch_stage/PC \
sim:/fetch_stage/PC_plus_one \
sim:/fetch_stage/pc_data \
sim:/fetch_stage/pc_data_out \
sim:/fetch_stage/buf_IF_ID_instruction \
sim:/fetch_stage/buf_IF_ID_PC \
sim:/fetch_stage/buf_IF_ID_instruction_o \
sim:/fetch_stage/buf_IF_ID_PC_o \
sim:/fetch_stage/buf_MEM_WB_Rdst_o \
sim:/fetch_stage/buf_MEM_WB_alu_result_o \
sim:/fetch_stage/buf_MEM_WB_mem_result_o \
sim:/fetch_stage/buf_MEM_WB_writeback_en_o \
sim:/fetch_stage/buf_MEM_WB_decoder_en_o \
sim:/fetch_stage/mem_result \
sim:/fetch_stage/SP \
sim:/fetch_stage/SP_minus_one
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Zaka  Hostname: ZAKAS-DESKTOP  ProcessID: 6264
#           Attempting to use alternate WLF file "./wlftv2k1zh".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftv2k1zh
force -freeze sim:/fetch_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetch_stage/rst 1 0
force -freeze sim:/fetch_stage/Interrupt 0 0
force -freeze sim:/fetch_stage/Alu_result 16#00010010 0
force -freeze sim:/fetch_stage/Rdst 010 0
force -freeze sim:/fetch_stage/writeback_mux_en 1 0
force -freeze sim:/fetch_stage/decoder_en 1 0
force -freeze sim:/fetch_stage/mem_read_en 0 0
force -freeze sim:/fetch_stage/mem_write_en 0 0
force -freeze sim:/fetch_stage/jump_en 0 0
force -freeze sim:/fetch_stage/jump_target 16#00000030 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /fetch_stage/ADDER_OBJ
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /fetch_stage
force -freeze sim:/fetch_stage/rst 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/fetch_stage/jump_en 1 0
run
run
force -freeze sim:/fetch_stage/jump_en 0 0
run
run
run
run
run
run


