vsim -gui work.decoder_stage
# vsim -gui work.decoder_stage 
# Start time: 08:04:17 on May 30,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.decoder_stage(decode_arch)
# Loading work.control_unit(cuarch)
# Loading work.decoder(decoder_arch)
# Loading work.reg(regarch)
# Loading work.mux_3x8(when_else_mux_3x8)
# Loading work.signextend(signextend_arch)
# Loading work.buf_id_ex(buf_arch)
add wave -position insertpoint sim:/decoder_stage/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Zaka  Hostname: ZAKAS-DESKTOP  ProcessID: 6264
#           Attempting to use alternate WLF file "./wlftexcekt".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftexcekt
force -freeze sim:/decoder_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decoder_stage/rst 1 0
run
force -freeze sim:/decoder_stage/rst 0 0
force -freeze sim:/decoder_stage/instruction 16#00000000 0
force -freeze sim:/decoder_stage/pc 16#1234578 0
force -freeze sim:/decoder_stage/decoder_enable_s 0 0
force -freeze sim:/decoder_stage/decoder_sel 001 0
force -freeze sim:/decoder_stage/writeback_result 16#12345678 0
run
force -freeze sim:/decoder_stage/instruction 00000101110000100000000000000000 0
run
force -freeze sim:/decoder_stage/instruction 01010000100111000000000000123456 0
# ** Error: (vsim-4026) Value "'2'" does not represent a literal of the enumeration type.
# ** Error: (vsim-4011) Invalid force value: 01010000100111000000000000123456 0.
# 
force -freeze sim:/decoder_stage/instruction 01010000100111000000000000000001 0
run
force -freeze sim:/decoder_stage/instruction 01010011010010000001001000110100 0
run
run