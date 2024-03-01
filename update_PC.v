`include"define.v"
module update_PC(

input wire rst_n_i,
input wire clk_i,
input wire instr_valid_i,
input wire cnd_i,

input wire [3:0] icode_i,

input wire [63:0] valC_i,
input wire[63:0] valM_i,
input wire [63:0] valP_i,
output reg[63:0] new_pc

);


always@(*) begin

case(icode_i)

`ICALL:begin
new_pc=valC_i;
end

`IJXX:begin
new_pc=(cnd_i)?valC_i:valP_i;
end

`IRET:begin
new_pc=valM_i;
end

default:begin
new_pc=valP_i;
end
endcase
end
endmodule