//`include "IFetch.v"

module IDecode(
            // for mem_I
            mem_rdata_I,
			// for result output
			ctrl_signal,
			immediate
			);

    input  [31:0] mem_rdata_I       ;
	output [12:0] ctrl_signal  		;
	output [31:0] immediate			;
    
	// wire/reg
	reg  [12:0] ctrl_signal  		;
	reg  [31:0] immediate			;
	wire [ 6:0] opcode              ;
	wire [ 2:0] func3               ;
	wire [ 6:0] func7               ;

	assign opcode = mem_rdata_I[6:0];
	assign func3  = mem_rdata_I[14:12];
	assign func7  = mem_rdata_I[31:25];

	always @(*) begin
		ctrl_signal = 13'b0;
		immediate = 0;
		if(opcode == 7'h6f) begin
			ctrl_signal[11] = 1;
			ctrl_signal[5] = 1;
			immediate = $signed({mem_rdata_I[31], mem_rdata_I[19:12], mem_rdata_I[20], mem_rdata_I[30:21], 1'b0});
		end
		else if(opcode == 7'h63) begin
			ctrl_signal[9] = 1;
			ctrl_signal[12] = mem_rdata_I[12];
			ctrl_signal[3:0] = 8;
			immediate = $signed({mem_rdata_I[31], mem_rdata_I[7], mem_rdata_I[30:25], mem_rdata_I[11:8], 1'b0});
		end
		else if(opcode == 7'h23) begin
			ctrl_signal[7] = 1;
			ctrl_signal[4] = 1;
			ctrl_signal[5] = 0;
			immediate = $signed({mem_rdata_I[31:25], mem_rdata_I[11:7]});
		end
		else if(opcode == 7'h33) begin
			ctrl_signal[5] = 1;
			ctrl_signal[3] = mem_rdata_I[30];
			ctrl_signal[2:0] = func3;
		end
		else begin
			immediate = $signed({mem_rdata_I[31:20]});
			if(opcode == 7'h67) begin
				ctrl_signal[10] = 1;
				ctrl_signal[5] = 1;
			end
			else if(opcode == 7'h3) ctrl_signal[8:4] = 5'h17;
			else begin
				ctrl_signal[5:4] = 3;
				ctrl_signal[2:0] = func3;
				if(func3 == 3'b101) ctrl_signal[3] = mem_rdata_I[30];
			end
		end
	end

endmodule
