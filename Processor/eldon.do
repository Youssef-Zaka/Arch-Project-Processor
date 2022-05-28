vsim -gui work.processor
# vsim -gui work.processor 
# Start time: 13:45:13 on May 28,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor_arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.mux_generic(when_else_mux)
# Loading work.buf_id_ex(buf_arch)
# Loading work.alu(alu_arch)
# ** Warning: (vsim-3473) Component instance "Flag_register_OBJ : Flag_Register" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor File: C:/Users/Zaka/Desktop/Courses/Arch/Arch Project Processor/Processor/Processor.vhd
# Loading work.tristate(tristate_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
# vsim -gui work.processor 
# Start time: 12:54:19 on May 28,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor_arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.mux_generic(when_else_mux)
# Loading work.buf_id_ex(buf_arch)
# Loading work.alu(alu_arch)
# ** Warning: (vsim-3473) Component instance "Flag_register_OBJ : Flag_Register" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor File: C:/Users/Zaka/Desktop/Courses/Arch/Arch Project Processor/Processor/Processor.vhd
# Loading work.tristate(tristate_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
# vsim -gui work.processor 
# Start time: 12:44:56 on May 28,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor_arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.mux_generic(when_else_mux)
# Loading work.buf_id_ex(buf_arch)
# Loading work.alu(alu_arch)
# ** Warning: (vsim-3473) Component instance "Flag_register_OBJ : Flag_Register" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor File: C:/Users/Zaka/Desktop/Courses/Arch/Arch Project Processor/Processor/Processor.vhd
# Loading work.tristate(tristate_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
# vsim -gui work.processor 
# Start time: 12:23:21 on May 28,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.processor(processor_arch)
# Loading work.memory(syncrama)
# Loading work.adder(arch)
# Loading work.pc_reg(regarch)
# Loading work.buf_if_id(buf_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.mux_generic(when_else_mux)
# Loading work.buf_id_ex(buf_arch)
# Loading work.alu(alu_arch)
# ** Warning: (vsim-3473) Component instance "Flag_register_OBJ : Flag_Register" is not bound.
#    Time: 0 ps  Iteration: 0  Instance: /processor File: C:/Users/Zaka/Desktop/Courses/Arch/Arch Project Processor/Processor/Processor.vhd
# Loading work.tristate(tristate_arch)
# Loading work.buf_ex_mem(buf_arch)
# Loading work.buf_mem_wb(buf_arch)
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst
add wave -position insertpoint  \
sim:/processor/buf_IF_ID_instruction \
sim:/processor/buf_IF_ID_PC \
sim:/processor/buf_IF_ID_instruction_o \
sim:/processor/buf_IF_ID_PC_o
add wave -position insertpoint  \
sim:/processor/Memory_address \
sim:/processor/Memory_data_in \
sim:/processor/Memory_data_out
add wave -position insertpoint  \
sim:/processor/PC_Reg_data \
sim:/processor/PC_Reg_data_o
add wave -position insertpoint  \
sim:/processor/Adder_PC \
sim:/processor/Adder_C
add wave -position insertpoint  \
sim:/processor/ALU_data_1 \
sim:/processor/ALU_data_2
add wave -position insertpoint  \
sim:/processor/buf_MEM_WB_alu_result_o \
sim:/processor/buf_MEM_WB_mem_result_o
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
add wave -position insertpoint  \
sim:/processor/R0_out \
sim:/processor/R1_out \
sim:/processor/R2_out \
sim:/processor/R3_out \
sim:/processor/R4_out \
sim:/processor/R5_out \
sim:/processor/R6_out \
sim:/processor/R7_out
add wave -position insertpoint  \
sim:/processor/inPort \
sim:/processor/buf_IF_ID_instruction \
sim:/processor/buf_IF_ID_PC \
sim:/processor/buf_IF_ID_instruction_o \
sim:/processor/buf_IF_ID_PC_o \
sim:/processor/buf_ID_EX_Rdst_o \
sim:/processor/buf_ID_EX_Rsrc1_o \
sim:/processor/buf_ID_EX_Rsrc2_o \
sim:/processor/buf_ID_EX_Imm_o \
sim:/processor/buf_ID_EX_PC_o \
sim:/processor/buf_ID_EX_opcode_o \
sim:/processor/buf_ID_EX_mem_read_en_o \
sim:/processor/buf_ID_EX_mem_write_en_o \
sim:/processor/buf_ID_EX_InPort_en_o \
sim:/processor/buf_ID_EX_writeback_en_o \
sim:/processor/buf_ID_EX_alu_en_o \
sim:/processor/buf_ID_EX_outputport_en_o \
sim:/processor/buf_ID_EX_add_branch_mux_o \
sim:/processor/buf_ID_EX_muxresult_oldpc_mux_o \
sim:/processor/buf_ID_EX_wb_reg_enable_o \
sim:/processor/buf_EX_MEM_alu_result \
sim:/processor/buf_EX_MEM_Rdst \
sim:/processor/buf_EX_MEM_mem_read_en \
sim:/processor/buf_EX_MEM_mem_write_en \
sim:/processor/buf_EX_MEM_writeback_en \
sim:/processor/buf_EX_MEM_alu_result_o \
sim:/processor/buf_EX_MEM_Rdst_o \
sim:/processor/buf_EX_MEM_mem_read_en_o \
sim:/processor/buf_EX_MEM_mem_write_en_o \
sim:/processor/buf_EX_MEM_writeback_en_o \
sim:/processor/buf_EX_MEM_wb_reg_enable_o \
sim:/processor/buf_MEM_WB_alu_result \
sim:/processor/buf_MEM_WB_Rdst \
sim:/processor/buf_MEM_WB_mem_result \
sim:/processor/buf_MEM_WB_writeback_en \
sim:/processor/buf_MEM_WB_alu_result_o \
sim:/processor/buf_MEM_WB_Rdst_o \
sim:/processor/buf_MEM_WB_mem_result_o \
sim:/processor/buf_MEM_WB_writeback_en_o \
sim:/processor/buf_MEM_WB_decoder_en_o \
sim:/processor/Memory_re \
sim:/processor/Memory_we \
sim:/processor/Memory_address \
sim:/processor/Memory_data_in \
sim:/processor/Memory_data_out \
sim:/processor/Flag_Registers_Z \
sim:/processor/Flag_Registers_En \
sim:/processor/Flag_Registers_N \
sim:/processor/Flag_Registers_C \
sim:/processor/Flag_Registers_Z_o \
sim:/processor/Flag_Registers_N_o \
sim:/processor/Flag_Registers_C_o \
sim:/processor/Reg_En \
sim:/processor/Reg_data \
sim:/processor/Reg_data_o \
sim:/processor/PC_Reg_En \
sim:/processor/PC_Reg_data \
sim:/processor/PC_Reg_data_o \
sim:/processor/Adder_PC \
sim:/processor/Adder_C \
sim:/processor/Mux_in_1 \
sim:/processor/Mux_in_0 \
sim:/processor/Mux_sel \
sim:/processor/Mux_out \
sim:/processor/ALU_data_1 \
sim:/processor/ALU_data_2 \
sim:/processor/ALU_sel \
sim:/processor/ALU_cin \
sim:/processor/ALU_enable \
sim:/processor/ALU_flag_enable \
sim:/processor/ALU_result \
sim:/processor/ALU_flags \
sim:/processor/Tristate_Q \
sim:/processor/Tristate_output \
sim:/processor/Tristate_en \
sim:/processor/signExtend_data_out \
sim:/processor/mux_data_1_s \
sim:/processor/mux_data_2_s \
sim:/processor/alu_op_code_s \
sim:/processor/alu_enable_s \
sim:/processor/input_port_enable_s \
sim:/processor/output_port_enable_s \
sim:/processor/mem_read_enable_s \
sim:/processor/mem_write_enable_s \
sim:/processor/mux_wb_s \
sim:/processor/mux_pc_adder_and_branch_s \
sim:/processor/mux_PcOld_mux_adderAndBranch_s \
sim:/processor/if_id_reset_s \
sim:/processor/id_ex_reset_s \
sim:/processor/ex_mem_reset_s \
sim:/processor/mem_wb_reset_s \
sim:/processor/if_id_enable_s \
sim:/processor/id_ex_enable_s \
sim:/processor/ex_mem_enable_s \
sim:/processor/mem_wb_enable_s \
sim:/processor/wb_reg_enable_s \
sim:/processor/decoder_enable_s \
sim:/processor/decoder_sel \
sim:/processor/decoder_output \
sim:/processor/writeback_result \
sim:/processor/R0_out \
sim:/processor/R1_out \
sim:/processor/R2_out \
sim:/processor/R3_out \
sim:/processor/R4_out \
sim:/processor/R5_out \
sim:/processor/R6_out \
sim:/processor/R7_out \
sim:/processor/rdst_mux_s \
sim:/processor/rsrc1_mux_s \
sim:/processor/rsrc2_mux_s \
sim:/processor/rdst_rsrc1_mux_s \
sim:/processor/immediate_rsrc2_mux_s \
sim:/processor/OutputPort \
sim:/processor/state
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/ADDER_OBJ
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /processor/Memory_OBJ
force -freeze sim:/processor/rst 0 0
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


