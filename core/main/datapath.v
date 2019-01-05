`include "param_pc_mux.vh"

module datapath (
	input clk,
	input rst,

	// from controller
	input c_fetch_stall,
	input [`SEL_PC_WIDTH - 1 : 0] c_pc_sel,
	input c_br_taken,
	input [31 : 0] c_next_pc,

	// to controller
	output memory_done,
	output [`SEL_PC_WIDTH - 1 : 0] pc_sel,
	output br_taken,
	output [31 : 0] ir,
	output [31 : 0] next_pc,

	input [31 : 0] icache_data,
	input icache_valid,
	output [31 : 0] icache_addr,
	output icache_req,

	input dcache_wvalid,
	input [31 : 0] dcache_rdata,
	input dcache_rvalid,
	output [31 : 0] dcache_addr,
	output dcache_wreq,
	output dcache_rreq,
	output [31 : 0] dcache_wdata,
	output [3 : 0] dcache_byte_enable
);
		
	wire [4 : 0] rs1_num;
	wire [4 : 0] rs2_num;
	wire [31 : 0] rs1_data;
	wire [31 : 0] rs2_data;
	// wire [4 : 0] wb_rd_num;
	wire [31 : 0] wb_rd_data;
	wire wb_enable;
	wire [11 : 0] csr_addr;
	wire [31 : 0] csr_rdata;
	wire [31 : 0] csr_wdata;
	wire csr_wb;
	wire [31 : 0] mtvec;
	wire [31 : 0] mepc;

	// from fetch to decode_execute
	wire [31 : 0] F_DE_ir_w;

	wire [31 : 0] DE_F_imm;

	// from decode_execute to memory_writeback
	wire [6 : 0] DE_MW_opcode_w;
	wire [2 : 0] DE_MW_func3_w;
	wire DE_MW_wb_reg_w;
	wire [4 : 0] DE_MW_rd_num_w;
	wire [31 : 0] DE_MW_rd_data_w;

	wire [31 : 0] dcache_out;

	reg [31 : 0] pc;

	initial begin
		pc = 32'h0;
	end

	regfile regfile (
		.clk(clk), .rst(rst),
		.w_enable(wb_enable),
		.rs1_num(rs1_num), .rs2_num(rs2_num), .rd_num(DE_MW_rd_num_w),
		.rd_data(wb_rd_data), .rs1_data(rs1_data), .rs2_data(rs2_data)
	);

	csr_file csr_file (
		.clk(clk), .rst(rst),
		.w_enable(csr_wb),
		.addr(csr_addr), .wdata(csr_wdata),
		.rdata(csr_rdata),
		.mtvec(mtvec), .mepc(mepc)
	);


	// Fetch Stage (1st Stage)	
	fetch fetch (
		.clk(clk), .rst(rst),
		.pc(pc),
		.stall(c_fetch_stall), // from controller
		.rs1(rs1_data), // from regfile
		.imm(DE_F_imm), .pc_sel(c_pc_sel), .taken(c_br_taken), // from decode_execute
		.mtvec(mtvec), .mepc(mepc), // from csr_file
		.ir_code(F_DE_ir_w), .next_pc(next_pc),
		.icache_data(icache_data), .icache_valid(icache_valid),
		.icache_addr(icache_addr), .icache_req(icache_req)
	);


	// Decode and Execute Stage (2nd Stage)
	decode_execute decode_execute (
		.ir(F_DE_ir_w), .pc(pc),
		.rs1_data(rs1_data), .rs2_data(rs2_data), // from regfile
		.csr_rdata(csr_rdata), // from csr_file
		.rs1_num(rs1_num), .rs2_num(rs2_num), // to regfile
		.opcode(DE_MW_opcode_w), .func3(DE_MW_func3_w),
		.wb_reg(DE_MW_wb_reg_w), .rd_num(DE_MW_rd_num_w), .rd_data(DE_MW_rd_data_w),
		.imm(DE_F_imm), .pc_sel(pc_sel), .br_taken(br_taken), // to fetch
		.csr_addr(csr_addr), .csr_wdata(csr_wdata), .csr_wb(csr_wb) // to csr_file
	);


	memory memory (
		.clk(clk), .rst(rst),
		.opcode(DE_MW_opcode_w), .func3(DE_MW_func3_w), .alu_out(DE_MW_rd_data_w), .rs2(rs2_data),
		.dcache_addr(dcache_addr), .dcache_wreq(dcache_wreq), .dcache_rreq(dcache_rreq), .dcache_wdata(dcache_wdata), .dcache_byte_enable(dcache_byte_enable),
		.dcache_wvalid(dcache_wvalid), .dcache_rdata(dcache_rdata), .dcache_rvalid(dcache_rvalid),
		.rdata(dcache_out), .done(memory_done)
	);


	writeback writeback (
		.opcode(DE_MW_opcode_w),
		.alu_out(DE_MW_rd_data_w), .wb_reg(DE_MW_wb_reg_w),
		.dcache_out(dcache_out), .done(memory_done),
		.wb_rd_data(wb_rd_data), .wb_enable(wb_enable)
	);


	always @(posedge clk) begin
		if(rst) begin
			pc <= 32'h0;
		end else begin
			pc <= c_next_pc;
		end
	end


endmodule // datapath
