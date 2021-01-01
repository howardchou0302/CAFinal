module IFetch(clk,
            rst_n,
            // for mem_I
            mem_addr_I,
            mem_rdata_I,
			// for result output
			instruction_type,
			instruction_format
			);

input         clk, rst_n        ;
output [31:2] mem_addr_I        ;
input  [31:0] mem_rdata_I       ;
output [22:0] instruction_type  ;
output [ 4:0] instruction_format;

reg [31:2] mem_addr_I           ;
reg [22:0] instruction_type     ;
reg [ 4:0] instruction_format   ;
wire [ 6:0] opcode              ;
wire [ 2:0] func3               ;
wire [ 6:0] func7               ;

assign opcode = mem_rdata_I[6:0];
assign func3  = mem_rdata_I[14:12];
assign func7  = mem_rdata_I[31:25];

always @(*) begin
    if (opcode == 7'h6f) begin
        instruction_format = 5'b00001;
        instruction_type = 23'h400000;
    end
    else if(opcode == 7'h63) begin
        instruction_format = 5'b00010;
        if(func3 == 3'b0) instruction_type = 23'h100000;
        else instruction_type = 23'h80000;
    end
    else if(opcode == 7'h23) begin
        instruction_format = 5'b00100;
        instruction_type = 23'h20000;
    end
    else if(opcode == 7'h33) begin
        instruction_format = 5'b10000;
        if(func3 == 3'b0) begin
            if(func7 == 7'b0) instruction_type = 23'h100;
            else instruction_type = 23'h80;
        end
        else if(func3 == 3'b1) instruction_type = 23'h40;
        else if(func3 == 3'b10) instruction_type = 23'h20;
        else if(func3 == 3'b100) instruction_type = 23'h10;
        else if(func3 == 3'b101) begin
            if(func7 == 7'b0) instruction_type = 23'h8;
            else instruction_type = 23'h4;
        end
        else if(func3 == 3'b110) instruction_type = 23'h2;
        else instruction_type = 23'h1;
    end
    else begin
        instruction_format = 5'b01000;
        if(opcode == 7'h67) instruction_type = 23'h200000;
        else if(opcode == 7'h3) instruction_type = 23'h40000;
        else if(func3 == 3'b0) instruction_type = 23'h10000;
        else if(func3 == 3'b1) instruction_type = 23'h800;
        else if(func3 == 3'b10) instruction_type = 23'h8000;
        else if(func3 == 3'b100) instruction_type = 23'h4000;
        else if(func3 == 3'b101) begin
            if(func7 == 7'b0) instruction_type = 23'h400;
            else instruction_type = 23'h200;
        end
        else if(func3 == 3'b110) instruction_type = 23'h2000;
        else instruction_type = 23'h1000;
    end
end

endmodule