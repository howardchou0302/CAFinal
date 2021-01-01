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
    input         clk, rst_n        ;
    input  [31:0] mem_rdata_I       ;
    input  [63:0] mem_rdata_D       ;
    output [31:2] mem_addr_I        ;
    output        mem_wen_D         ;
    output [31:2] mem_addr_D        ;
    output [63:0] mem_wdata_D       ;

    reg    [63:0] Registers[31:0]   ;
    
    



endmodule
