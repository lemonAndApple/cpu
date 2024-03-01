`include "define.v"

module decode_tb;

// input wire clk_i;
 wire [3:0]  icode_i;
 wire [3:0]  rA_i;
 wire [3:0]  rB_i;
 wire [63:0]  valA_o;
 wire [63:0]  valB_o;

assign icode_i=4'h6;
assign rA_i=4'h1;
assign rB_i=4'h2;

decode_stage decode_module(
.icode_i(icode_i),
.rA_i(rA_i),
.rB_i(rB_i),
.valA_o(valA_o),
.valB_o(valB_o)
);

initial 


 $monitor(" icode=%h\t,  rA=%h\t, rB=%h\t, valA=%h\t, valB=%h\t",
		icode_i,rA_i,rB_i,valA_o,valB_o);


endmodule
