`include "define.v"
`include"ram.v"
module fetch(
    //input signal
    input wire [63:0]    PC_i,

    //output signal
    output wire [3:0]      icode_o,
    output wire [3:0]      ifun_o,
    output wire [3:0]      rA_o,
    output wire [3:0]      rB_o,
    output wire [63:0]     valC_o,
    output wire [63:0]     valP_o,
    /*output wire            instr_valid_o,
    output wire            imem_error_o*/
    output wire [63:0]     predPC_o,
    output wire [2:0]      stat_o
);

  //  reg [7:0]   instr_mem[0:1023];
    
    wire[79:0]  instr;
    wire        imem_error;
    wire        instr_valid;


    wire        need_regids;
    wire        need_valC;
  
    wire [63:0] temp;  
ram  f_ram(
	.clk_i(1'b0),
	.r_en(1'b0),
	.w_en(1'b0),
	.addr_i(PC_i),
	.wdata_i(64'b0),
	.rdata_o(temp),
	.instr(instr),
	.imem_error_o(imem_error)
	);

    //split current instruction(Byte 0)
    assign icode_o = instr[7:4];
    assign ifun_o  = instr[3:0];

    //check instruction code if > C, error
     assign instr_valid = (icode_o < 4'hC);

    //instruction set 
    assign need_regids = (icode_o == `ICMOVQ) || (icode_o == `IIRMOVQ) ||
	                 (icode_o == `IRMMOVQ) || (icode_o == `IMRMOVQ) ||
	                 (icode_o == `IOPQ)   || (icode_o == `IPUSHQ)  || 
			 (icode_o == `IPOPQ||icode_o==`IRRMOVQ);

    assign need_valC = (icode_o == `IIRMOVQ) || (icode_o == `IRMMOVQ) ||
                       (icode_o == `IMRMOVQ) || (icode_o == `IJXX)    ||
                       (icode_o == `ICALL);

    assign rA_o = need_regids ? instr[15:12] :  4'hF;
    assign rB_o = need_regids ? instr[11:8] :  4'hF;


   assign valC_o = !need_valC  ? 64'h0:
                  need_regids ? instr[79:16] : instr[71:8];

    assign valP_o = PC_i + 1 + 8*need_valC + need_regids;

    assign stat_o=imem_error?`SADR:(!instr_valid)?`SINS:(icode_o==`IHALT)?`SHLT:`SAOK;
  
    assign predPC_o=(icode_o==`IJXX||icode_o==`ICALL)?valC_o:valP_o;

endmodule

