module HW4(clk,
            rst_n,
            // for mem_I
            mem_addr_I,
            mem_rdata_I,
			// for result output
			ctrl_signal,
			immediate
			);

    input  	      clk, rst_n        ;
    output [31:2] mem_addr_I        ;
    input  [31:0] mem_rdata_I       ;
	output [11:0] ctrl_signal  ;
	output [31:0] immediate;
    
	// wire/reg 
	reg [31:0] inter, r_data, w_data;
	reg [11:0] ctrl;
	wire [22:0]i_type;
	wire [4:0]i_format;
	
	assign ctrl_signal = ctrl;
	assign immediate = inter;
	
	// Connect to your HW3 module
	HW3 instruction_decoder(.clk(clk), .rst_n(rst_n), .mem_addr_I(mem_addr_I), .mem_rdata_I(mem_rdata_I), .instruction_type(i_type), .instruction_format(i_format));

	always @(*) begin
		inter = 32'b0;
		ctrl = 12'b0;
		w_data = mem_rdata_I;
		if(i_format[0]) begin
			ctrl[11] = 1;
			ctrl[5] = 1;
			inter = $signed({r_data[31], r_data[19:12], r_data[20], r_data[30:21], 1'b0});
		end
		else if(i_format[1]) begin
			ctrl[9] = 1;
			inter = $signed({r_data[31], r_data[7], r_data[30:25], r_data[11:8], 1'b0});
		end
		else if(i_format[2]) begin
			ctrl[7] = 1;
			ctrl[4] = 1;
			inter = $signed({r_data[31:25], r_data[11:7]});
		end
		else if(i_format[3]) begin
			inter = $signed({r_data[31:20]});
			if(i_type[21]) begin
				ctrl[10] = 1;
				ctrl[5] = 1;
			end
			else if(i_type[18]) ctrl[8:4] = 5'h17;
			else ctrl[5:4] = 3;
			if(i_type[16]) ctrl[3:0] = 0;
			else if(i_type[11]) ctrl[3:0] = 1;
			else if(i_type[15]) ctrl[3:0] = 2;
			else if(i_type[14]) ctrl[3:0] = 4;
			else if(i_type[10]) ctrl[3:0] = 5;
			else if(i_type[9]) ctrl[3:0] = 13;
			else if(i_type[13]) ctrl[3:0] = 6;
			else ctrl[3:0] = 7;
		end
		else if(i_format[4]) begin
			ctrl[5] = 1;
			if(i_type[8]) ctrl[3:0] = 0;
			else if(i_type[7]) ctrl[3:0] = 8;
			else if(i_type[6]) ctrl[3:0] = 1;
			else if(i_type[5]) ctrl[3:0] = 2;
			else if(i_type[4]) ctrl[3:0] = 4;
			else if(i_type[3]) ctrl[3:0] = 5;
			else if(i_type[2]) ctrl[3:0] = 13;
			else if(i_type[1]) ctrl[3:0] = 6;
			else ctrl[3:0] = 7;
		end
		else begin
			inter = 12'b0;
			ctrl = 32'b0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(!(rst_n)) begin
			r_data <= 32'b0;
		end
		else begin
			r_data <= w_data;
		end
	end

endmodule