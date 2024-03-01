`include"define.v"

module memory_tb;

 wire clk_i;
 wire [3:0] icode_i;
 wire [63:0] valE_i;  //alu->valE,address
 wire [63:0] valA_i;    // write data->memory
wire [63:0] valP_i;    
 wire [63:0] valM_o;    //read data from memory
 wire dmem_error_o;

memory_access memory_module(
.clk_i(clk_i),
.icode_i(icode_i),
.valE_i(valE_i),
.valA_i(valA_i),
.valP_i(valP_i),
.valM_o(valM_o),
.dmem_error_o(dmem_error_o)
);

assign icode_i=4'h5;
assign valA_i=64'h2;
assign valE_i=64'h3;
assign valP_i=64'h4;

initial 
 $monitor("valM=%d\t, ERROR=%h\t",
		valM_o,dmem_error_o);


endmodule