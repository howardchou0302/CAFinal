module Inv(Ins_i, Ins_o);

input  [31:0] Ins_i;
output [31:0] Ins_o;

assign Ins_o[31:24] = Ins_i[ 7: 0];
assign Ins_o[23:16] = Ins_i[15: 8];
assign Ins_o[15: 8] = Ins_i[23:16];
assign Ins_o[ 7: 0] = Ins_i[31:24];

endmodule