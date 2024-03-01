`timescale 1ns / 1ps
`include"define.v"

module F_test;
//selectpc
wire F_stall;
wire F_bubble;
wire[63:0] F_predPC;
//Fetch stage signal
reg [63:0]PC_i;
wire [2:0] f_stat;
wire [3:0]f_icode;
wire [3:0]f_ifun;
wire [3:0] f_rA;
wire [3:0] f_rB;
wire [63:0] f_valC;
wire [63:0] f_valP;
wire[63:0] f_predPC;
wire       D_stall;
wire       D_bubble;
wire [2:0] D_stat;
wire [63:0] D_pc;
wire [3:0] D_icode;
wire [3:0]D_ifun;
wire [3:0] D_rA;
wire [3:0] D_rB;
wire [63:0] D_valC;
wire [63:0]D_valP;
reg       clk;

/*select_pc select_stage(
.F_predPC_i(F_predPC),
.M_icode_i(M_icode),
.W_icode_i(W_icode),
.M_valA_i(M_valA),
.W_valM_i(W_valM),
.M_Cnd_i(M_Cnd),
.f_pc_o(PC_i)
);*/
fetch fetch_stage(
.PC_i(PC_i),
.icode_o(f_icode),
.ifun_o(f_ifun),
.rA_o(f_rA),
.rB_o(f_rB),
.valC_o(f_valC),
.valP_o(f_valP),
.predPC_o(f_predPC),
.stat_o(f_stat)
);
//fetch to D pipereg
assign D_stall=1'b0;
assign D_bubble=1'b0;
//fetch to D pipereg 

fetch_D_pipe_reg dreg( 
.clk_i(clk),
.D_stall_i(D_stall) ,
.D_bubble_i(D_bubble),
.f_stat_i(f_stat),
.f_pc_i(PC_i),
.f_icode_i(f_icode),
.f_ifun_i(f_ifun),
.f_rA_i(f_rA),
.f_rB_i(f_rB),
.f_valC_i(f_valC),
.f_valP_i(f_valP),
.D_stat_o(D_stat),
.D_pc_o(D_pc),
.D_icode_o(D_icode),
.D_ifun_o(D_ifun),
.D_rA_o(D_rA),
.D_rB_o(D_rB),
.D_valC_o(D_valC),
.D_valP_o(D_valP)
);
 
initial begin
    clk=0;
PC_i=10;
end

always 
#20 clk=~clk;
initial begin
    #500 $stop;
end

endmodule
