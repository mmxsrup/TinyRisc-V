`include "param_ram.vh"

module ram_interconnect
(
	input clk,
	input rst,

	// slave port0
	// write
	input [`AWIDTH - 1 : 0] s0_awaddr,
	input [`LWIDTH - 1 : 0] s0_awlen,
	input s0_awvalid,
	output s0_awready,
	input [`DWIDTH - 1 : 0] s0_wdata,
	output s0_wvalid,
	input s0_wready,
	output s0_wlast,
	// read
	input [`AWIDTH - 1 : 0] s0_araddr,
	input [`LWIDTH - 1 : 0] s0_arlen,
	input s0_arvalid,
	output s0_arready,
	output [`DWIDTH - 1 : 0] s0_rdata,
	output s0_rvalid,
	input s0_rready,
	output s0_rlast,


	// slave port1
	// write
	input [`AWIDTH - 1 : 0] s1_awaddr,
	input [`LWIDTH - 1 : 0] s1_awlen,
	input s1_awvalid,
	output s1_awready,
	input [`DWIDTH - 1 : 0] s1_wdata,
	output s1_wvalid,
	input s1_wready,
	output s1_wlast,
	// read
	input [`AWIDTH - 1 : 0] s1_araddr,
	input [`LWIDTH - 1 : 0] s1_arlen,
	input s1_arvalid,
	output s1_arready,
	output [`DWIDTH - 1 : 0] s1_rdata,
	output s1_rvalid,
	input s1_rready,
	output s1_rlast,


	// master port
	// write
	output [`AWIDTH - 1 : 0] m_awaddr,
	output [`LWIDTH - 1 : 0] m_awlen,
	output m_awvalid,
	input m_awready,
	output [`DWIDTH - 1 : 0] m_wdata,
	input m_wvalid,
	output m_wready,
	input m_wlast,
	// read
	output [`AWIDTH - 1 : 0] m_araddr,
	output [`LWIDTH - 1 : 0] m_arlen,
	output m_arvalid,
	input m_arready,
	input [`DWIDTH - 1 : 0] m_rdata,
	input m_rvalid,
	output m_rready,
	input m_rlast
);


	localparam SWIDTH = 2;
	localparam IDLE = 0;
	localparam SEL0 = 1;
	localparam SEL1 = 2;

	reg [SWIDTH - 1 : 0] state;


	// AW Channel
	assign m_awaddr = (state == SEL0) ? s0_awaddr : (state == SEL1) ? s1_awaddr : 0;
	assign m_awlen  = (state == SEL0) ? s0_awlen : (state == SEL1) ? s1_awlen : 0;
	assign m_awvalid = (state == SEL0) ? s0_awvalid : (state == SEL1) ? s1_awvalid : 0;
	assign s0_awready = (state == SEL0) ? m_awready : 0;
	assign s1_awready = (state == SEL1) ? m_awready : 0;

	// W Channel
	assign m_wdata = (state == SEL0) ? s0_wdata : (state == SEL1) ? s1_wdata : 0;
	assign s0_wvalid = (state == SEL0) ? m_wvalid : 0;
	assign s1_wvalid = (state == SEL1) ? m_wvalid : 0;
	assign m_wready = (state == SEL0) ? s0_wready : (state == SEL1) ? s1_wready : 0;
	assign s0_wlast = (state == SEL0) ? m_wlast : 0;
	assign s1_wlast = (state == SEL1) ? m_wlast : 0;

	// AR Channel
	assign m_araddr = (state == SEL0) ? s0_araddr : (state == SEL1) ? s1_araddr : 0;
	assign m_arlen = (state == SEL0) ? s0_arlen : (state == SEL1) ? s1_arlen : 0;
	assign m_arvalid = (state == SEL0) ? s0_arvalid : (state == SEL1) ? s1_arvalid : 0;
	assign s0_arready = (state == SEL0) ? m_arready : 0;
	assign s1_arready = (state == SEL1) ? m_arready : 0;

	// R Channel
	// assign m_rdata = (state == SEL0) ? s0_rdata : (state == SEL1) ? s1_rdata : 0;
	assign s0_rdata = (state == SEL0) ? m_rdata : 0;
	assign s1_rdata = (state == SEL1) ? m_rdata : 0;
	assign s0_rvalid = (state == SEL0) ? m_rvalid : 0;
	assign s1_rvalid = (state == SEL1) ? m_rvalid : 0;
	assign m_rready = (state == SEL0) ? s0_rready : (state == SEL1) ? s1_rready : 0;
	assign s0_rlast = (state == SEL0) ? m_rlast : 0;
	assign s1_rlast = (state == SEL1) ? m_rlast : 0;


	always @(posedge clk) begin
		if(rst) begin
			state <= IDLE;
		end else begin
			case (state)
				IDLE : begin
					if ((s0_awvalid && m_awready) || (s0_arvalid && m_arready)) state <= SEL0;
					if ((s1_awvalid && m_awready) || (s1_arvalid && m_arready)) state <= SEL1;
				end
				SEL0: begin
					if ((m_wlast && s0_wready) || (m_rlast && s0_rready)) state <= IDLE;
				end
				SEL1 : begin
					if ((m_wlast && s1_wready)|| (m_rlast && s1_rready)) state <= IDLE;
				end
			endcase // state
		end
	end

endmodule // arbiter
