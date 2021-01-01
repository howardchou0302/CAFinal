// Your code

module RISCV(clk,
            rst_n,
            // for mem_D
            mem_wen_D,
            mem_addr_D,
            mem_wdata_D,
            mem_rdata_D,
            // for mem_I
            mem_addr_I,
            mem_rdata_I);
    input             clk, rst_n        ;
    input      [31:0] mem_rdata_I       ;
    input      [63:0] mem_rdata_D       ;
    output reg [31:2] mem_addr_I        ;
    output reg        mem_wen_D         ;
    output reg [31:2] mem_addr_D        ;
    output reg [63:0] mem_wdata_D       ;

    reg    [63:0] Registers[31:0]   ;
    reg    [31:2] addr_I            ;
    reg           wen_D             ;
    reg    [31:2] addr_D            ;
    reg    [63:0] wdata_D           ;
    wire   [ 4:0] Rs1, Rs2, Rd      ;
    wire   [12:0] ctrl              ;
    wire   [31:0] imm               ;
    integer i;

    IDecode iDecode(.clk(clk), 
    .rst_n(rst_n), 
    .mem_addr_I(addr_I),
    .mem_rdata_I(mem_rdata_I),
    .ctrl_signal(ctrl),
    .immediate(imm));

    assign Rd  = mem_rdata_I[11: 7] ;
    assign Rs1 = mem_rdata_I[19:15] ;
    assign Rs2 = mem_rdata_I[24:20] ;
    
    always @(*) begin
        if(ctrl[11]) begin
            
        end
        else if(ctrl[10]) begin
            
        end
        else if(ctrl[9]) begin
            
        end
        else addr_I = addr_I + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i = 0; i < 32; i = i+1) Registers[i] <= 64'b0;
            mem_addr_I <= 30'b0;
            mem_addr_D <= 30'b0;
            mem_wen_D <= 0;
            mem_wdata_D <= 0;
        end
        else begin
            mem_addr_D <= addr_D;
            mem_addr_I <= addr_I;
            mem_wdata_D <= wdata_D;
            mem_wen_D <= wen_D;
        end
    end


endmodule
