`timescale 1ns / 1ps
`include "define.v"

module fetch_tb;

reg  [63:0]  PC_i;
reg clk_i;
reg rst_n_i;
    
wire [3:0]    icode_o;
wire [3:0]    ifun_o;
wire [3:0]    rA_o;
wire [3:0]    rB_o;
wire [63:0]   valC_o;
wire [63:0]   valP_o;
wire          instr_valid_o;
wire          imem_error_o;
wire [63:0]  valA_o;
wire [63:0]  valB_o;

wire signed[63:0] valE_o;
wire Cnd_o;


fetch fetch_tb(
    .PC_i(PC_i),
    .icode_o(icode_o),
    .ifun_o(ifun_o),
    .rA_o(rA_o),
    .rB_o(rB_o),
    .valC_o(valC_o),
    .valP_o(valP_o),
    .instr_valid_o(instr_valid_o),
    .imem_error_o(imem_error_o)
);

decode_stage decode_module(
.icode_i(icode_o),
.rA_i(rA_o),
.rB_i(rB_o),
.valA_o(valA_o),
.valB_o(valB_o)
);

execute execute_module(
.clk_i(clk_i),
.rst_n_i(rst_n_i),
.icode_i(icode_o),
.ifun_i(ifun_o),
.valA_i(valA_o),
.valB_i(valB_o),
.valC_i(valC_o),
.valE_o(valE_o),
.Cnd_o(Cnd_o)
);

    initial  begin    
	PC_i = 0;
	#10 PC_i = 10;
	#10 PC_i = 20;
	#10 PC_i = 22;
	#10 PC_i = 32;
    #10 PC_i = 42;
    #10 PC_i = 44;	
	#10 PC_i = 46;
	#10 PC_i = 55;
	#10 PC_i = 64;
    #10 PC_i = 65;
    #10 PC_i = 66;
	#10 PC_i = 265;
    #10 PC_i = 1024;
	end
	
	initial
	    $monitor("PC=%d\t, icode=%h\t, ifun=%h\t, rA=%h\t, rB=%h\t,valA=%h\t,valB=%h\t, valC=%h\t, valE=%d\t,valP=%d\t, instr_valid=%h\t, imem_error=%h\t",
		      PC_i, icode_o, ifun_o, rA_o, rB_o,valA_o,valB_o, valC_o,valE_o, valP_o, instr_valid_o, imem_error_o);
		
endmodule  

