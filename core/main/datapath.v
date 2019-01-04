`include "param_pc_mux.vh"
`include "param_ram.vh"

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


	// write
	output [`AWIDTH - 1 : 0] i_ram_awaddr,
	output [`LWIDTH - 1 : 0] i_ram_awlen,
	output i_ram_awvalid,
	input i_ram_awready,
	output [`DWIDTH - 1 : 0] i_ram_wdata,
	input i_ram_wvalid,
	output i_ram_wready,
	input i_ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] i_ram_araddr,
	output [`LWIDTH - 1 : 0] i_ram_arlen,
	output i_ram_arvalid,
	input i_ram_arready,
	input [`DWIDTH - 1 : 0] i_ram_rdata,
	input i_ram_rvalid,
	output i_ram_rready,
	input i_ram_rlast,


	// write
	output [`AWIDTH - 1 : 0] d_ram_awaddr,
	output [`LWIDTH - 1 : 0] d_ram_awlen,
	output d_ram_awvalid,
	input d_ram_awready,
	output [`DWIDTH - 1 : 0] d_ram_wdata,
	input d_ram_wvalid,
	output d_ram_wready,
	input d_ram_wlast,
	// read
	output [`AWIDTH - 1 : 0] d_ram_araddr,
	output [`LWIDTH - 1 : 0] d_ram_arlen,
	output d_ram_arvalid,
	input d_ram_arready,
	input [`DWIDTH - 1 : 0] d_ram_rdata,
	input d_ram_rvalid,
	output d_ram_rready,
	input d_ram_rlast
);
		
	wire [4 : 0] rs1_num;
	wire [4 : 0] rs2_num;
	wire [31 : 0] rs1_data;
	wire [31 : 0] rs2_data;
	wire [4 : 0] wb_rd_num;
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

	reg [31 : 0] pc;

	initial begin
		pc = 32'h0;
	end

	regfile regfile (
		.clk(clk), .rst(rst),
		.w_enable(wb_enable),
		.rs1_num(rs1_num), .rs2_num(rs2_num), .rd_num(wb_rd_num), 
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
		.ram_awaddr(i_ram_awaddr), .ram_awlen(i_ram_awlen), .ram_awvalid(i_ram_awvalid), .ram_awready(i_ram_awready),
		.ram_wdata(i_ram_wdata), .ram_wvalid(i_ram_wvalid), .ram_wready(i_ram_wready), .ram_wlast(i_ram_wlast),
		.ram_araddr(i_ram_araddr), .ram_arlen(i_ram_arlen), .ram_arvalid(i_ram_arvalid), .ram_arready(i_ram_arready),
		.ram_rdata(i_ram_rdata), .ram_rvalid(i_ram_rvalid), .ram_rready(i_ram_rready), .ram_rlast(i_ram_rlast)
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


	// Memory Access and Write Back Stage (3rd Stage)
	memory_writeback memory_writeback (
		.clk(clk), .rst(rst),
		.opcode(DE_MW_opcode_w), .func3(DE_MW_func3_w),
		.wb_reg(DE_MW_wb_reg_w), .rd_num(DE_MW_rd_num_w), .alu_out(DE_MW_rd_data_w), .rs2_data(rs2_data),
		.wb_enable(wb_enable), .wb_rd_num(wb_rd_num), .wb_rd_data(wb_rd_data), // to regfile
		.done(memory_done), // to controller
		.ram_awaddr(d_ram_awaddr), .ram_awlen(d_ram_awlen), .ram_awvalid(d_ram_awvalid), .ram_awready(d_ram_awready),
		.ram_wdata(d_ram_wdata), .ram_wvalid(d_ram_wvalid), .ram_wready(d_ram_wready), .ram_wlast(d_ram_wlast),
		.ram_araddr(d_ram_araddr), .ram_arlen(d_ram_arlen), .ram_arvalid(d_ram_arvalid), .ram_arready(d_ram_arready),
		.ram_rdata(d_ram_rdata), .ram_rvalid(d_ram_rvalid), .ram_rready(d_ram_rready), .ram_rlast(d_ram_rlast)
	);


	always @(posedge clk) begin
		if(rst) begin
			pc <= 32'h0;
		end else begin
			pc <= c_next_pc;
		end
	end


endmodule // datapath
