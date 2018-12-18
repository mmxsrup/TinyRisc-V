module tb_core ();

	localparam STEP = 10;

	reg clk;
	reg rst;
	

	core core (
		.clk(clk), .rst(rst)
	);

	
	always begin
		clk = 1; #(STEP / 2);
		clk = 0; #(STEP / 2);
	end

	initial begin
		rst = 0;
		#(STEP * 10) rst = 1;
		#(STEP * 10) rst = 0;

		#(STEP * 100) $stop;
	end

endmodule // tb_core
