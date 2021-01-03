module ALU(data1, 
           data2,
           ALUOp, 
           zero, 
           result);

input  [63:0]  data1;
input  [63:0]  data2;
input  [ 3:0]  ALUOp;
output [63:0] result;
output zero;

reg [63:0] result;

assign zero = (result == 0);

always @(*) begin
    case (ALUOp)
        4'b0: result = $signed(data1) + $signed(data2);
        4'b1000: result = $signed(data1) - $signed(data2);
        4'b1: result = data1 << data2[5:0];
        4'b10: result = ($signed(data1) < $signed(data2));
        4'b100: result = data1 ^ data2;
        4'b101: result = data1 >> data2[5:0];
        4'b1101: result = data1 >>> data2[5:0];
        4'b110: result = data1 | data2; 
        4'b111: result = data1 & data2;
        default: result = data1 + data2;
    endcase
end

endmodule