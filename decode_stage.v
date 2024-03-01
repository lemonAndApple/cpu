`include"define.v"

module decode_stage(
input wire clk_i,
input wire [3:0] D_icode_i,
input wire [3:0] D_rA_i,
input wire [3:0] D_rB_i,
input wire [63:0] D_valP_i,
input wire [3:0] e_dstE_i,
input wire [63:0] e_valE_i,
input wire [3:0] M_dstM_i,
input wire [63:0] m_valM_i,
input wire [3:0]M_dstE_i,
input wire [63:0]M_valE_i,
input wire [3:0] W_dstM_i,
input wire [63:0] W_valM_i,
input wire [3:0] W_dstE_i,
input wire [63:0] W_valE_i,
output wire [63:0] d_valA_o,
output wire[63:0] d_valB_o,
output wire [3:0] d_dstE_o,
output wire [3:0] d_dstM_o,
output wire [3:0] d_srcA_o,
output wire[3:0]d_srcB_o

);

/*reg [3:0] srcA;
reg [3:0] srcB;

reg [4:0] dstE;
reg [4:0] dstM;*/

wire [63:0] d_rvalA;
wire [63:0] d_rvalB;
reg [63:0] regfile [0:14];

integer i;
initial begin
//inite

for(i=0;i<15;i=i+1)
begin 
regfile[i]=64'b0;
end

end

assign d_srcA_o=(D_icode_i==`IRRMOVQ||D_icode_i==`IRMMOVQ||D_icode_i==`IOPQ||D_icode_i==`IPUSHQ)?D_rA_i:(D_icode_i ==`IPOPQ||D_icode_i==`IRET)?`RESP:`RNONE;

assign d_srcB_o=(D_icode_i==`IOPQ || D_icode_i==`IRMMOVQ ||D_icode_i==`IMRMOVQ)? D_rB_i:(D_icode_i==`ICALL||D_icode_i ==`IPUSHQ ||D_icode_i ==`IRET)?`RESP:`RNONE;

assign d_dstE_o=(D_icode_i==`IRRMOVQ||D_icode_i ==`IIRMOVQ||D_icode_i==`IOPQ)?D_rB_i:(D_icode_i==`IPUSHQ||D_icode_i ==`IPOPQ||D_icode_i ==`ICALL||D_icode_i==`IRET)?`RESP:`RNONE;

assign d_dstM_o=(D_icode_i==`IMRMOVQ||D_icode_i==`IPOPQ)?D_rA_i:`RNONE;

assign d_rvalA=(d_srcA_o==`RNONE)?64'b0:regfile[d_srcA_o];

assign d_rvalB =(d_srcB_o==`RNONE)?64'b0:regfile[d_srcB_o];

//assign d_valA_o=d_rvalA;

//assign d_valB_o=d_rvalB;

/*wire [63:0] fwdA_valA;
wire [63:0] fwdB_valB;


sel_fwd  sel_fwdA(
.D_icode_i(D_icode_i),
.D_valP_i(D_valP_i),
.d_srcA_i(d_srcA_o),
.e_dstE_i(e_dstE_i),
.e_valE_i(e_valE_i),
.M_dstM_i(M_dstM_i),
.m_valM_i(m_valM_i),
.M_dstE_i(M_dstE_i),
.M_valE_i(M_valE_i),
.W_dstM_i(W_dstM_i),
.W_valM_i(W_valM_i),
.W_dstE_i(W_dstE_i),
.W_valE_i(W_valE_i),
.d_rvalA_i(d_rvalA),
.fwdA_valA_o(fwdA_valA)
);


fwdB  sel_fwdB(
.d_srcB_i(d_srcB_o),
.e_dstE_i(e_dstE_i),
.e_valE_i(e_valE_i),
.M_dstM_i(M_dstM_i),
.m_valM_i(m_valM_i),
.M_dstE_i(M_dstE_i),
.M_valE_i(M_valE_i),
.W_dstM_i( W_dstM_i),
.W_valM_i(W_valM_i),
.W_dstE_i(W_dstE_i),
.W_valE_i(W_valE_i),
.d_rvalB_i(d_rvalB),
.fwdB_valB_o(fwdB_valB)
);



assign d_valA_o=(d_rvalA==0)?d_rvalA:fwdA_valA;
assign d_valB_o=(d_rvalB==0)?d_rvalB:fwdB_valB;*/

assign d_valA_o = (D_icode_i == `ICALL || D_icode_i == `IJXX) ? D_valP_i :
                  (d_srcA_o == e_dstE_i) ? e_valE_i :
                  (d_srcA_o == M_dstM_i) ? m_valM_i :
                  (d_srcA_o == M_dstE_i) ? M_valE_i :
                  (d_srcA_o == W_dstM_i) ? W_valM_i :
                  (d_srcA_o == W_dstE_i) ? W_valE_i : d_rvalA;

assign d_valB_o = (d_srcB_o == e_dstE_i) ? e_valE_i :
                  (d_srcB_o == M_dstM_i) ? m_valM_i :
		  (d_srcB_o == M_dstE_i) ? M_valE_i : 
	          (d_srcB_o == W_dstM_i) ? W_valM_i : 
		  (d_srcB_o == W_dstE_i) ? W_valE_i : d_rvalB;

always@(posedge clk_i)begin

if(W_dstE_i!=4'hf) begin
regfile[W_dstE_i]<=W_valE_i;
end

if(W_dstM_i!=4'hf)begin
regfile[W_dstM_i]<=W_valM_i;
end

end
endmodule