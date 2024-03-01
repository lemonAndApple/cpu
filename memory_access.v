`include"define.v"
`include"ram.v"
module memory_access (
input wire clk_i,
input wire [3:0] M_icode_i,
input wire [63:0] M_valE_i,   //alu->valE,address
input wire [63:0] M_valA_i,    // write data->memory
//input wire [63:0] valP_i,
input wire [2:0] M_stat_i,
  
output wire [63:0] m_valM_o,    //read data from memory
//output wire dmem_error_o
output wire [2:0] m_stat_o
);


reg r_en;
reg w_en;
wire dmem_error;

reg [63:0] mem_addr;
reg[63:0] mem_data;
always @(*) begin

case(M_icode_i)

`IRMMOVQ :begin
r_en <=1'b0;
w_en <= 1'b1;
mem_addr <=M_valE_i;
mem_data<=M_valA_i;
end

`IMRMOVQ:begin
r_en <=1'b1;
w_en <=1'b0;
mem_addr<= M_valE_i;
mem_data<=64'b0;
end

`ICALL:begin
r_en <=1'b0;
w_en <=1'b1;
mem_addr<= M_valE_i;
mem_data<=M_valA_i;
end

`IPUSHQ:begin
r_en<=1'b0;
w_en<=1'b1;
mem_addr<=M_valE_i;
mem_data<=M_valA_i;
end

`IPOPQ:begin
r_en <=1'b1;
w_en <=1'b0;
mem_addr<=M_valA_i;
mem_data<=64'b0;
end

`IRET: begin
r_en <=1'b1;
w_en <=1'b0;
mem_addr<= M_valA_i;
mem_data<=64'b0;
end

default:begin
r_en<=0;
w_en<=0;
mem_addr<=64'b0;
mem_data<=64'b0;
end
                         //whether add default or not
endcase
end


wire [79:0]  temp;
ram memory_module(
.clk_i(clk_i), 
.r_en(r_en), 
.w_en(w_en), 
.addr_i(mem_addr), 
.wdata_i(mem_data), 
.rdata_o(m_valM_o), 
.imem_error_o(dmem_error),
.instr(temp)
);

assign m_stat_o=dmem_error?`SADR:M_stat_i;

endmodule

