
`timescale 1ns / 1ps
`include "define.v"

module tb;

reg clk;
reg rst_n;

reg  [63:0]  PC;
wire [63:0]  npc;

wire [ 3:0]  icode;
wire [ 3:0]  ifun;
wire [ 3:0]  rA;
wire [ 3:0]  rB;
wire [63:0]  valC;
wire [63:0]  valP;

wire [63:0]  valA;
wire [63:0]  valB;

wire         stat;

wire [63:0]  valE_exe;
wire [63:0]  valM_mem;

wire [63:0]  valE_wb;
wire [63:0]  valM_wb;

wire [ 3:0]  Stat;

wire Cnd;

wire instr_valid; 
wire imem_error;
wire dmem_error;

fetch fetch_stage(
    .PC_i(PC),
    .icode_o(icode),
    .ifun_o(ifun),
    .rA_o(rA),
    .rB_o(rB),
    .valC_o(valC),
    .valP_o(valP),
    .instr_valid_o(instr_valid),
    .imem_error_o(imem_error)
);

decode_stage decode_module( 
    .clk_i(clk),
    .rst_n_i(rst_n),
    
    .icode_i(icode),
    //read
    .rA_i(rA),
    .rB_i(rB),

    //write
    .valE_i(valE_wb),
    .valM_i(valM_wb),

    .valA_o(valA),
    .valB_o(valB),

    .cnd_i(Cnd)
);

execute execute_stage(
    .clk_i(clk),
    .rst_n_i(rst_n),

    .icode_i(icode),
    .ifun_i(ifun),
    .valA_i(valA),
    .valB_i(valB),
    .valC_i(valC),

    .valE_o(valE_exe),
    .Cnd_o(Cnd)
);


memory_access mem_stage(
    .clk_i(clk),
    .icode_i(icode),

    .valE_i(valE_exe),  //address 

    .valA_i(valA),    
    .valP_i(valP),    

    .valM_o(valM_mem),   

    .dmem_error_o(dmem_err)
);

write_back wb_stage(
    
    .icode_i(icode),
    .valE_i(valE_exe),
    .valM_i(valM_mem),

    .instr_valid_i(instr_valid),
    .imem_error_i(imem_error),
    .dmem_error_i(dmem_error),
 
    .valE_o(valE_wb),
    .valM_o(valM_wb),

    .stat_o(Stat)
);


update_PC upc_stage(
    .clk_i(clk),
    .rst_n_i(rst_n),

    .instr_valid_i(instr_valid),
    .cnd_i(Cnd),

    .icode_i(icode),

    .valP_i(valP),
    .valC_i(valC),
    .valM_i(valM_wb),
    .new_pc(npc)
);


initial begin
    clk = 0;
    PC = 0;
end

always 
    #20 clk = ~clk;

initial 
   forever @ (posedge clk) #2 PC = npc;

initial begin
    #500 $stop;
end

initial begin
    forever @ (posedge clk) #3 begin
    //$display("infomation %d", $time);
    $display("PC=%d\t, icode=%h\t, ifun=%h\t, rA=%h\t, rB=%h\t, valC=%h\t, valP=%h,\n valA=%h\t, valB=%h\t, valE_exe=%h\t, valM_mem=%h\n valE_wb=%h\t, valM_wb=%h\t, npc=%h\t",
              PC, icode, ifun, rA, rB, valC, valP,
              valA, valB, valE_exe, valM_mem, 
              valE_wb, valM_wb, npc
             ); 
    end
end
endmodule 
