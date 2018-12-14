module dcache #( // data cache
	parameter CACHE_SIZE = 4096
)(
	input clk,
	input rst,
	
	// from lsu
	input [31 : 0] addr,
	input wreq, // write request
	input rreq, // read request
	input [31 : 0] wdata, // write data
	input [3 : 0] byte_enable,

	// to controller
	output wvalid,
	output [31 : 0] rdata,
	output rvalid

	// from memory
	// TODO
);
	
	parameter STATE_SIZE = 3;
	parameter IDLE = 3'h1;
	parameter RUN  = 3'h2;
	parameter WRITE_BACK = 3'h3;
	parameter ALLOCATE = 3'h4;

	reg [STATE_SIZE - 1 : 0] state;

	reg v [0 : CACHE_SIZE - 1]; // valid
	reg d [0 : CACHE_SIZE - 1]; // dirty bit
	reg [11 : 0] tag [0 : CACHE_SIZE - 1];
	reg [31 : 0] cache_data [0 : CACHE_SIZE - 1];


	wire [17 : 0] addr_tag;
	wire [11 : 0] addr_index;
	wire hit;

	initial begin
		for (integer i = 0; i < CACHE_SIZE; i = i + 1) begin
			v[i] = 1;
			d[i] = 0;
			tag[i] = 0;
			cache_data[i] = i;
		end
		// TODO
		// $readmemh("dcache_data.hex", MEM);
	end

	assign addr_tag = addr[31 : 14];
	assign addr_index = addr[13 : 2];
	assign hit = (tag[addr_index] == addr_tag && v[addr_index]) ? 1 : 0;

	assign wvalid = (wreq && hit) ? 1 : 0;
	assign rvalid = (rreq && hit) ? 1 : 0;

	assign rdata = (hit && rreq) ? cache_data[addr_index] : 32'b0;

	always @(posedge clk) begin
		if (wreq) begin
			if (byte_enable[0]) cache_data[addr_index][7 : 0]	 <= wdata[7 : 0];
			if (byte_enable[1]) cache_data[addr_index][15 : 8]	 <= wdata[15 : 8];
			if (byte_enable[2]) cache_data[addr_index][23 : 16]	 <= wdata[23 : 16];
			if (byte_enable[3]) cache_data[addr_index][31 : 24]	 <= wdata[31 : 24];
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			for (integer i = 0; i < CACHE_SIZE; i = i + 1) begin
				d[i] <= 0;
			end
		end else begin
			if (hit && wreq) d[addr_index] <= 1;
		end
	end

	// state machine
	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
		end else begin

			case (state)
				IDLE : state <= RUN;
				RUN : begin
					if (wreq || rreq) begin // wrtie or read request
						if (hit) state <= RUN;
						else begin
							if (d[addr_index]) state <= WRITE_BACK;
							else state <= ALLOCATE;
						end
					end else begin // not request
						state <= RUN;
					end
				end
				WRITE_BACK : state <= WRITE_BACK; // TODO
				ALLOCATE : state <= ALLOCATE; // TODO
				default : state <= IDLE;
			endcase // case (state)

		end
	end // always @(posedge clk)


endmodule // dcache
