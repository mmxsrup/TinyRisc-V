`include "param_pc_mux.vh"

module control (
	input clk,
	input rst,

	// from datapath
	input memory_done_i,
	input [`SEL_PC_WIDTH - 1 : 0] pc_sel_i,
	input br_taken_i,
	input [31 : 0] ir_i,
	input [31 : 0] next_pc_i,

	// to datapath
	output fetch_stall_o,
	output [`SEL_PC_WIDTH - 1 : 0] pc_sel_o,
	output br_taken_o,
	output [31 : 0] next_pc_o
);
	
	parameter STATE_WIDTH = 1;
	parameter IDLE = 3'h0;
	parameter RUN = 3'h1;

	reg [STATE_WIDTH - 1 : 0] state;


	assign fetch_stall_o = 0;
	assign pc_sel_o = (state != IDLE) ? pc_sel_i : `SEL_PC_NONE;
	assign br_taken_o = br_taken_i;
	assign next_pc_o = next_pc_i;


	always @(posedge clk) begin
		if (rst) begin
			state <= IDLE;
		end else begin
			case (state)
				IDLE : state <= RUN;
				RUN : state <= RUN;
				default : state <= IDLE;
			endcase // state
		end
	end // always @(posedge clk)


endmodule // control
