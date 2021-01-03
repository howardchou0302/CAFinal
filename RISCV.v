// Your code
//`include "IDecode.v"
//`include "ALU.v"
//`include "Inv.v"

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

    reg    [63:0] Regs[31:0]            ;
    reg    [31:2] PC                    ;
    wire   [31:2] jump                  ;
    wire   [ 4:0] Rs1, Rs2, Rd          ;
    wire   [12:0] ctrl                  ;
    wire   [31:0] imm, inv_rdata        ;
    wire          zero                  ;
    wire   [63:0] data1, data2, result  ;
    wire   [63:0] w_reg, mem2reg, addr  ;
    wire   [63:0] inv_r, inv_w          ;
    integer i;

    Inv32 inv(mem_rdata_I, inv_rdata);

    IDecode iDecode(.clk(clk), 
    .rst_n(rst_n), 
    .mem_rdata_I(inv_rdata),
    .ctrl_signal(ctrl),
    .immediate(imm));

    ALU alu(
        .data1(data1),
        .data2(data2),
        .result(result),
        .ALUOp(ctrl[3:0]),
        .zero(zero)
    );

    Inv64 invR(mem_rdata_D, inv_r);
    Inv64 invW(Regs[Rs2], inv_w);

    assign Rd  = inv_rdata[11: 7] ;
    assign Rs1 = inv_rdata[19:15] ;
    assign Rs2 = inv_rdata[24:20] ;
    assign data1 = Regs[Rs1];
    assign data2 = ctrl[4] ? $signed({imm}) : Regs[Rs2];
    assign addr = mem_addr_I + 1;
    assign w_reg = (ctrl[11] || ctrl[10]) ? $unsigned({addr, 2'b0}) : mem2reg;
    assign jump = (ctrl[11] || (ctrl[9] && (ctrl[12] == zero))) ? mem_addr_I + imm[31:2] : addr;
    assign mem2reg = ctrl[6] ? inv_r: result;
    
    
    always @(*) begin
        case(ctrl[10])
            1'b0: PC = jump;
            1'b1: PC = data1[31:2] + imm[31:2];
        endcase
        mem_addr_D = result[31:2];
        mem_wen_D = ctrl[7];
        mem_wdata_D = inv_w;
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            for(i = 0; i < 32; i = i+1) begin 
                Regs[i] <= 64'b0;
            end
            mem_addr_I <= 30'b0;
        end
        else begin
            mem_addr_I <= PC;
            if(Rd && ctrl[5]) Regs[Rd] <= w_reg;
            else begin end
        end
    end

endmodule
