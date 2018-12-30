`ifndef __param_pc_mux__
`define __param_pc_mux__

`define SEL_PC_WIDTH 3

`define SEL_PC_NONE 3'h0
`define SEL_PC_ADD4 3'h1
`define SEL_PC_JAL 3'h2
`define SEL_PC_JALR 3'h3
`define SEL_PC_MTVEC 3'h4
`define SEL_PC_MEPC 3'h5

`endif
