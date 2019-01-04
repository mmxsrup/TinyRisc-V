module tb_ram ();

	localparam STEP = 10;
	parameter DWIDTH = 32;
	parameter AWIDTH = 32;
	parameter LWIDTH = 2;
	parameter WORDS = 16384;

	reg clk;
	reg rst;

	// write
	reg [AWIDTH - 1 : 0] awaddr;
	reg [LWIDTH - 1 : 0] awlen;
	reg awvalid;
	wire awready;
	reg [DWIDTH - 1 : 0] wdata;
	wire wvalid;
	reg wready;
	wire wlast;

	// read
	reg [AWIDTH - 1 : 0] araddr;
	reg [LWIDTH - 1 : 0] arlen;
	reg arvalid;
	wire arready;
	wire [DWIDTH - 1 : 0] rdata;
	wire rvalid;
	reg rready;
	wire rlast;

	ram ram (
		.clk(clk), .rst(rst),
		.awaddr(awaddr), .awlen(awlen), .awvalid(awvalid), .awready(awready),
		.wdata(wdata), .wvalid(wvalid), .wready(wready), .wlast(wlast),
		.araddr(araddr), .arlen(arlen), .arvalid(arvalid), .arready(arready),
		.rdata(rdata), .rvalid(rvalid), .rready(rready), .rlast(rlast)
	);
	
	always begin
		clk = 1; #(STEP / 2);
		clk = 0; #(STEP / 2);
	end

	initial begin
		rst = 0;
		awaddr = 0; awlen = 0; awvalid = 0;
		wdata = 0; wready = 0;
		araddr = 0; arlen = 0; arvalid = 0;
		rready = 0;
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		#(STEP); awaddr = 32'h0; awlen = 2; awvalid = 1; wready = 1;
		#(STEP); while (awready == 0) #(STEP);
		awvalid = 0;
		wdata = 32'hdeadbeef; #(STEP);
		wdata = 32'hbeefcafe; #(STEP);


		#(STEP); araddr = 32'h0; arlen = 3; arvalid = 1; rready = 1;
		#(STEP); while (arready == 0) #(STEP);
		arvalid = 0;
		rready = 1; #(STEP);

		#(STEP * 100);

		$finish;
		
	end

endmodule // tb_core
