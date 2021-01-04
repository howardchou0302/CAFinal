module Inv32(Ins_i, Ins_o);

input  [31:0] Ins_i;
output [31:0] Ins_o;

assign Ins_o[31:24] = Ins_i[ 7: 0];
assign Ins_o[23:16] = Ins_i[15: 8];
assign Ins_o[15: 8] = Ins_i[23:16];
assign Ins_o[ 7: 0] = Ins_i[31:24];

endmodule

module Inv64(Ins_i, Ins_o);

input  [63:0] Ins_i;
output [63:0] Ins_o;

assign Ins_o[63:56] = Ins_i[ 7: 0];
assign Ins_o[55:48] = Ins_i[15: 8];
assign Ins_o[47:40] = Ins_i[23:16];
assign Ins_o[39:32] = Ins_i[31:24];
assign Ins_o[31:24] = Ins_i[39:32];
assign Ins_o[23:16] = Ins_i[47:40];
assign Ins_o[15: 8] = Ins_i[55:48];
assign Ins_o[ 7: 0] = Ins_i[63:56];

endmodule