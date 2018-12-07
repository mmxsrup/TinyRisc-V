module icache #(
	parameter CACHE_SIZE = 4096
) (
	input clk,
	input rst,
	
	// from fetch
	input [31 : 0] addr,
	input req,
	// to fetch
	output [31 : 0] data,
	output valid

	// from main memory
	// TODO
);
	
	parameter STATE_SIZE = 2;
	parameter IDLE = 2'b00;
	parameter RUN  = 2'b01;
	parameter MISS = 2'b10;

	reg [STATE_SIZE - 1 : 0] state;

	reg [11 : 0] tag [0 : CACHE_SIZE - 1];
	reg [31 : 0] cache_data [0 : CACHE_SIZE - 1];

	wire [17 : 0] addr_tag;
	wire [11 : 0] addr_index;
	wire hit;

	initial begin
		for (integer i = 0; i < CACHE_SIZE; i = i + 1) begin
			tag[i] = 0;
			cache_data[i] = i;
		end
		// TODO
		// $readmemh("icache_data.hex", MEM);
	end

	assign addr_tag = addr[31 : 14];
	assign addr_index = addr[13 : 2];
	assign hit = (tag[addr_index] == addr_tag);

	assign valid = hit;
	assign data = (hit) ? cache_data[addr_index] : 32'b0;

	// state machine
	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
		end else begin

			case (state)
				IDLE : state <= RUN;
				RUN  : begin
					if (req) begin // read request
						if (hit) begin // HIT
							state <= RUN;
						end else begin // MISS
							state <= MISS;
						end
					end else begin
						state <= RUN;
					end
				end
				MISS : begin // TODO
					state <= MISS;
				end
				default : begin
					state <= IDLE;
				end
			endcase // case (state)

		end
	end // always @(posedge clk)

endmodule // icache
