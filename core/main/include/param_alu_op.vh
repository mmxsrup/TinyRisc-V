`ifndef __param_alu_op__
`define __param_alu_op__

`define ALU_OP_WIDTH 4

`define ALU_OP_ADD  4'h0
`define ALU_OP_SUB  4'h1
`define ALU_OP_AND  4'h2
`define ALU_OP_OR   4'h3
`define ALU_OP_XOR  4'h4
`define ALU_OP_SLL  4'h5
`define ALU_OP_SRA  4'h6
`define ALU_OP_SRL  4'h7
`define ALU_OP_SLT  4'h8
`define ALU_OP_SLTU 4'h9
`define ALU_OP_SEQ  4'hA
`define ALU_OP_SNE  4'hB
`define ALU_OP_SGE  4'hC
`define ALU_OP_SGEU 4'hD
`define ALU_OP_NONE 4'hE

`endif
