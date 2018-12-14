`include "param_alu_op.vh"	
`include "param_src_a_mux.vh"
`include "param_src_b_mux.vh"

module tb_dcache ();

	localparam STEP = 10;

	reg clk;
	reg rst;

	reg [31 : 0] addr;
	reg wreq;
	reg rreq;
	reg [31 : 0] wdata;
	reg [3 : 0] byte_enable;

	wire wvalid;
	wire [31 : 0] rdata;
	wire rvalid;


	dcache dcache (
		.clk(clk), .rst(rst),
		.addr(addr), .wreq(wreq), .rreq(rreq),
		.wdata(wdata), .byte_enable(byte_enable),
		.wvalid(wvalid), .rdata(rdata), .rvalid(rvalid)
	);


	always begin
		clk = 0; #(STEP / 2);
		clk = 1; #(STEP / 2);
	end

	initial begin
		rst = 0;
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 0; rreq = 1;
			#(STEP)
			$display("[R] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 1; rreq = 0; wdata = 32'hff; byte_enable = 4'b0001;
			#(STEP)
			$display("[W] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 0; rreq = 1;
			#(STEP)
			$display("[R] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 1; rreq = 0; wdata = 32'hdead; byte_enable = 4'b0011;
			#(STEP)
			$display("[W] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 0; rreq = 1;
			#(STEP)
			$display("[R] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 1; rreq = 0; wdata = 32'hdeadbeef; byte_enable = 4'b1111;
			#(STEP)
			$display("[W] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		for (integer i = 0; i < 4; i = i + 1) begin
			addr = i << 2; wreq = 0; rreq = 1;
			#(STEP)
			$display("[R] rdata:%h, wvalid:%b, rvalid:%b", rdata, wvalid, rvalid);
		end

		#(STEP * 100) $stop;
	end


endmodule // tb_dcache
