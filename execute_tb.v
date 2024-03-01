
`include"define.v"

module execute_tb;

 wire clk_i;
 wire rst_n_i;
 wire [3:0] icode_i;
 wire [3:0] ifun_i;

wire signed[63:0] valA_i;
wire signed[63:0] valB_i;
wire signed[63:0] valC_i;
wire signed[63:0] valE_o;

 wire Cnd_o;

execute execute_module(
.clk_i(clk_i),
.rst_n_i(rst_n_i),
.icode_i(icode_i),
.ifun_i(ifun_i),
.valA_i(valA_i),
.valB_i(valB_i),
.valC_i(valC_i),
.valE_o(valE_o),
.Cnd_o(Cnd_o)
);

assign clk_i=0;
assign rst_n_i=0;
assign icode_i=4'h8;
assign ifun_i=4'h0;
assign valA_i=64'h4;
assign valB_i=64'h3;
assign valC_i=64'h1;

initial 


 $monitor(" icode=%h\t, valA=%h\t, valB=%h\t, valE=%d\t, Cnd=%h\t",
		icode_i,valA_i,valB_i,valE_o,Cnd_o);

endmodule