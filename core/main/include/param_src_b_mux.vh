`ifndef __param_src_b_mux__
`define __param_src_b_mux__


`define SEL_SRC_B_WIDTH 3

`define SEL_SRC_B_RS2    3'h1
`define SEL_SRC_B_IMM    3'h2
`define SEL_SRC_B_4      3'h3
`define SEL_SRC_B_12     3'h4
`define SEL_SRC_B_IMMS12 3'h5 // (imm << 12)
`define SEL_SRC_B_NONE   3'h0


`endif
