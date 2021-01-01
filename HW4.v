module IDecode(clk,
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
	output [12:0] ctrl_signal  		;
	output [31:0] immediate			;
    
	// wire/reg 
	reg [31:2] mem_addr_I        	;
	reg [12:0] ctrl_signal  		;
	reg [31:0] immediate			;
	
	// Connect to your HW3 module
	IFetch iFetch(.clk(clk), .rst_n(rst_n), .mem_addr_I(mem_addr_I), .mem_rdata_I(mem_rdata_I), .instruction_type(i_type), .instruction_format(i_format));

	always @(*) begin
		ctrl_signal = 13'b0;
		if(i_format[0]) begin
			ctrl_signal[11] = 1;
			ctrl_signal[5] = 1;
			immediate = $signed({r_data[31], r_data[19:12], r_data[20], r_data[30:21], 1'b0});
		end
		else if(i_format[1]) begin
			ctrl_signal[9] = 1;
			ctrl_signal[12] = i_type[19];
			immediate = $signed({r_data[31], r_data[7], r_data[30:25], r_data[11:8], 1'b0});
		end
		else if(i_format[2]) begin
			ctrl_signal[7] = 1;
			ctrl_signal[4] = 1;
			immediate = $signed({r_data[31:25], r_data[11:7]});
		end
		else if(i_format[3]) begin
			immediate = $signed({r_data[31:20]});
			if(i_type[21]) begin
				ctrl_signal[10] = 1;
				ctrl_signal[5] = 1;
			end
			else if(i_type[18]) ctrl_signal[8:4] = 5'h17;
			else ctrl_signal[5:4] = 3;
			if(i_type[16]) ctrl_signal[3:0] = 0;
			else if(i_type[11]) ctrl_signal[3:0] = 1;
			else if(i_type[15]) ctrl_signal[3:0] = 2;
			else if(i_type[14]) ctrl_signal[3:0] = 4;
			else if(i_type[10]) ctrl_signal[3:0] = 5;
			else if(i_type[9]) ctrl_signal[3:0] = 13;
			else if(i_type[13]) ctrl_signal[3:0] = 6;
			else ctrl_signal[3:0] = 7;
		end
		else if(i_format[4]) begin
			ctrl_signal[5] = 1;
			if(i_type[8]) ctrl_signal[3:0] = 0;
			else if(i_type[7]) ctrl_signal[3:0] = 8;
			else if(i_type[6]) ctrl_signal[3:0] = 1;
			else if(i_type[5]) ctrl_signal[3:0] = 2;
			else if(i_type[4]) ctrl_signal[3:0] = 4;
			else if(i_type[3]) ctrl_signal[3:0] = 5;
			else if(i_type[2]) ctrl_signal[3:0] = 13;
			else if(i_type[1]) ctrl_signal[3:0] = 6;
			else ctrl_signal[3:0] = 7;
		end
		else begin
			immediate = 12'b0;
			ctrl = 32'b0;
		end
	end

endmodule