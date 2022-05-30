vsim -gui work.wb_stage
# vsim -gui work.wb_stage 
# Start time: 07:59:35 on May 30,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.wb_stage(wb_stage_arch)
add wave -position insertpoint sim:/wb_stage/*
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: Zaka  Hostname: ZAKAS-DESKTOP  ProcessID: 6264
#           Attempting to use alternate WLF file "./wlft0mt01v".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlft0mt01v
force -freeze sim:/wb_stage/mem_result 16#10101010 0
force -freeze sim:/wb_stage/ALU_result 16#00000001 0
force -freeze sim:/wb_stage/rdst 010 0
force -freeze sim:/wb_stage/wb_enable 0 0
force -freeze sim:/wb_stage/decoder_enable 1 0
run
force -freeze sim:/wb_stage/wb_enable 1 0
force -freeze sim:/wb_stage/decoder_enable_o 0 0
run
