
vsim -gui work.integrated_design
# vsim -gui work.integrated_design 
# Start time: 08:32:12 on May 30,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.integrated_design(arch)
# Loading work.fetch_stage(arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
# Loading work.decoder_stage(decode_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.buf_id_ex(buf_arch)
# Loading work.execute_stage(execute_stage_arch)
# Loading work.alu(alu_arch)
# Loading work.flagreg(flagreg_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.wb_stage(wb_stage_arch)
# vsim -gui work.integrated_design 
# Start time: 08:29:58 on May 30,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.integrated_design(arch)
# Loading work.fetch_stage(arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
# Loading work.decoder_stage(decode_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.buf_id_ex(buf_arch)
# Loading work.execute_stage(execute_stage_arch)
# Loading work.alu(alu_arch)
# Loading work.flagreg(flagreg_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.wb_stage(wb_stage_arch)
add wave -position insertpoint  \
sim:/integrated_design/clk \
sim:/integrated_design/rst \
sim:/integrated_design/Interrupt \
sim:/integrated_design/input_port \
sim:/integrated_design/output_port \
sim:/integrated_design/R0 \
sim:/integrated_design/R1 \
sim:/integrated_design/R2 \
sim:/integrated_design/R3 \
sim:/integrated_design/R4 \
sim:/integrated_design/R5 \
sim:/integrated_design/R6 \
sim:/integrated_design/R7 \
sim:/integrated_design/Cf \
sim:/integrated_design/Nf \
sim:/integrated_design/Zf \
sim:/integrated_design/Fetch_Decode_instruction \
sim:/integrated_design/Fetch_Decode_pc \
sim:/integrated_design/MEM_WB_Rdst \
sim:/integrated_design/MEM_WB_mem_result \
sim:/integrated_design/MEM_WB_ALU_result \
sim:/integrated_design/MEM_WB_writeback_mux \
sim:/integrated_design/MEM_WB_decoder_enable \
sim:/integrated_design/Decode_EX_data_1 \
sim:/integrated_design/Decode_EX_data_2 \
sim:/integrated_design/Decode_EX_rdst \
sim:/integrated_design/Decode_EX_immediate \
sim:/integrated_design/Decode_EX_pc \
sim:/integrated_design/Decode_EX_alu_op_code \
sim:/integrated_design/Decode_EX_mem_read \
sim:/integrated_design/Decode_EX_mem_write \
sim:/integrated_design/Decode_EX_input \
sim:/integrated_design/Decode_EX_writeback_mux \
sim:/integrated_design/Decode_EX_alu_en \
sim:/integrated_design/Decode_EX_output \
sim:/integrated_design/Decode_EX_Jump_Sel \
sim:/integrated_design/Decode_EX_decoder_enable_wb_stage \
sim:/integrated_design/EX_MEM_ALU_result \
sim:/integrated_design/EX_MEM_Rdst \
sim:/integrated_design/EX_MEM_wtieback_mux_en \
sim:/integrated_design/EX_MEM_decoder_en \
sim:/integrated_design/EX_MEM_mem_read_en \
sim:/integrated_design/EX_MEM_mem_write_en \
sim:/integrated_design/EX_MEM_jump_enable \
sim:/integrated_design/EX_MEM_jump_target \
sim:/integrated_design/WB_Decode_writeback_result \
sim:/integrated_design/WB_Decode_rdst \
sim:/integrated_design/WB_Decode_decoder_en \
sim:/integrated_design/R0_signal \
sim:/integrated_design/R1_signal \
sim:/integrated_design/R2_signal \
sim:/integrated_design/R3_signal \
sim:/integrated_design/R4_signal \
sim:/integrated_design/R5_signal \
sim:/integrated_design/R6_signal \
sim:/integrated_design/R7_signal \
sim:/integrated_design/Cf_signal \
sim:/integrated_design/Nf_signal \
sim:/integrated_design/Zf_signal
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Zaka  Hostname: ZAKAS-DESKTOP  ProcessID: 6264
#           Attempting to use alternate WLF file "./wlft6vwy1c".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlft6vwy1c
force -freeze sim:/integrated_design/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/integrated_design/rst 1 0
force -freeze sim:/integrated_design/Interrupt 0 0
force -freeze sim:/integrated_design/input_port 16#00000005 0
run
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Zaka  Hostname: ZAKAS-DESKTOP  ProcessID: 6264
#           Attempting to use alternate WLF file "./wlfttdvakh".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlfttdvakh
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /integrated_design/FETCH_MEM_BUF/ADDER_OBJ
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /integrated_design/FETCH_MEM_BUF
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /integrated_design/FETCH_MEM_BUF/ADDER_OBJ
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /integrated_design/FETCH_MEM_BUF
force -freeze sim:/integrated_design/rst 0 0
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

