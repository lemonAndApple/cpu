`include"define.v"


module ram(
input wire clk_i,
input wire r_en,
input wire w_en,
input wire [63:0] addr_i, 
input wire [63:0] wdata_i, 
output wire [63:0] rdata_o,
output wire [79:0] instr,
output wire   imem_error_o
);

reg [7:0] mem[0:1023];

assign imem_error_o = (addr_i> 1023)? 1:0;


//fetch_stage
wire [63:0] PC_i;

assign PC_i=addr_i;

    // fetch 10 byte from instruction memory (small end method)
    assign  instr = {
	    mem[PC_i + 9], mem[PC_i + 8], mem[PC_i + 7],
	    mem[PC_i + 6], mem[PC_i + 5], mem[PC_i + 4],
	    mem[PC_i + 3], mem[PC_i + 2], mem[PC_i + 1],
	    mem[PC_i + 0]};


//memory access stage

//whether the read singal is efficient
assign rdata_o = (r_en == 1'b1)?({mem[addr_i+7],mem[addr_i+6],mem[addr_i+ 5],mem[addr_i+4],mem[addr_i+3],mem[addr_i+2],mem[addr_i+1], mem[addr_i+0]}):64'b0;


always @(posedge clk_i)begin

  if(w_en)begin
{mem[addr_i+7],mem[addr_i+6],mem[addr_i+5],mem[addr_i+4],mem[addr_i+3],mem[addr_i+2],mem[addr_i+1],mem[addr_i+0]}<=wdata_i;
   end
end

integer i;

initial begin
       for(i=0;i<1024;i=i+1)mem[i]=8'h00;

end



 initial  begin
//                            | # Modification of asum code to compute absolute values of entries.
//                            | # This version uses a conditional jump
//                            | # Execution begins at address 0 
//0x000:                      | 	.pos 0 
//0x000: 30f40002000000000000 | 	irmovq stack, %rsp  	# Set up stack pointer  
    mem[0] = 8'h30;
    mem[1] = 8'hf4;
    mem[2] = 8'h00;
    mem[3] = 8'h02;
    mem[4] = 8'h00;
    mem[5] = 8'h00;
    mem[6] = 8'h00;
    mem[7] = 8'h00;
    mem[8] = 8'h00;
    mem[9] = 8'h00;
//0x00a: 803800000000000000   | 	call main		# Execute main program
    mem[10] = 8'h80;
    mem[11] = 8'h38;
    mem[12] = 8'h00;
    mem[13] = 8'h00;
    mem[14] = 8'h00;
    mem[15] = 8'h00;
    mem[16] = 8'h00;
    mem[17] = 8'h00;
    mem[18] = 8'h00;
//0x013: 00                   | 	halt			# Terminate program 
    mem[19] = 8'h00;
//                            | 
//                            | # Array of 4 elements
//0x018:                      | 	.align 8 	
//0x018: 0d000d000d000000     | array:	.quad 0x00 00 00 0d000d000d
    mem[24] = 8'h0d;
    mem[25] = 8'h00;
    mem[26] = 8'h0d;
    mem[27] = 8'h00;
    mem[28] = 8'h0d;
    mem[29] = 8'h00;
    mem[30] = 8'h00;
    mem[31] = 8'h00;
//0x020: 40ff3fff3fffffff     | 	.quad 0xff ff ff 3f ff 3f ff 40  # -0x000000c000c000c0
    mem[32] = 8'h40;
    mem[33] = 8'hff;
    mem[34] = 8'h3f;
    mem[35] = 8'hff;
    mem[36] = 8'h3f;
    mem[37] = 8'hff;
    mem[38] = 8'hff;
    mem[39] = 8'hff;
//0x028: 000b000b000b0000     | 	.quad 0x00 00 0b000b000b00
    mem[40] = 8'h00;
    mem[41] = 8'h0b;
    mem[42] = 8'h00;
    mem[43] = 8'h0b;
    mem[44] = 8'h00;
    mem[45] = 8'h0b;
    mem[46] = 8'h00;
    mem[47] = 8'h00;
//0x030: 0060ff5fff5fffff     | 	.quad 0xff ff 5f ff 5f ff 6000  # -0x0000a000a000a000  
    mem[48] = 8'h00;
    mem[49] = 8'h60;
    mem[50] = 8'hff;
    mem[51] = 8'h5f;
    mem[52] = 8'hff;
    mem[53] = 8'h5f;
    mem[54] = 8'hff;
    mem[55] = 8'hff;
//                            | 
//0x038: 30f71800000000000000 | main:	irmovq array,%rdi	
    mem[56] = 8'h30;
    mem[57] = 8'hf7;
    mem[58] = 8'h18;
    mem[59] = 8'h00;
    mem[60] = 8'h00;
    mem[61] = 8'h00;
    mem[62] = 8'h00;
    mem[63] = 8'h00;
    mem[64] = 8'h00;
    mem[65] = 8'h00;
//0x042: 30f60400000000000000 | 	irmovq $4,%rsi
    mem[66] = 8'h30;
    mem[67] = 8'hf6;
    mem[68] = 8'h04;
    mem[69] = 8'h00;
    mem[70] = 8'h00;
    mem[71] = 8'h00;
    mem[72] = 8'h00;
    mem[73] = 8'h00;
    mem[74] = 8'h00;
    mem[75] = 8'h00;
//0x04c: 805600000000000000   | 	call absSum		# absSum(array, 4)
    mem[76] = 8'h80;
    mem[77] = 8'h56;
    mem[78] = 8'h00;
    mem[79] = 8'h00;
    mem[80] = 8'h00;
    mem[81] = 8'h00;
    mem[82] = 8'h00;
    mem[83] = 8'h00;
    mem[84] = 8'h00;
//0x055: 90                   | 	ret 
    mem[85] = 8'h90;
//                            | /* $begin abs-sum-jmp-ys */
//                            | # long absSum(long *start, long count)
//                            | # start in %rdi, count in %rsi
//0x056:                      | absSum:
//0x056: 30f80800000000000000 | 	irmovq $8,%r8           # Constant 8
    mem[86] = 8'h30;
    mem[87] = 8'hf8;
    mem[88] = 8'h08;
    mem[89] = 8'h00;
    mem[90] = 8'h00;
    mem[91] = 8'h00;
    mem[92] = 8'h00;
    mem[93] = 8'h00;
    mem[94] = 8'h00;
    mem[95] = 8'h00;
//0x060: 30f90100000000000000 | 	irmovq $1,%r9	        # Constant 1
    mem[96] = 8'h30;
    mem[97] = 8'hf9;
    mem[98] = 8'h01;
    mem[99] = 8'h00;
    mem[100] = 8'h00;
    mem[101] = 8'h00;
    mem[102] = 8'h00;
    mem[103] = 8'h00;
    mem[104] = 8'h00;
    mem[105] = 8'h00;
//0x06a: 6300                 | 	xorq %rax,%rax		# sum = 0
    mem[106] = 8'h63;
    mem[107] = 8'h00;
//0x06c: 6266                 | 	andq %rsi,%rsi		# Set condition codes
    mem[108] = 8'h62;
    mem[109] = 8'h66;
//0x06e: 709600000000000000   | 	jmp  test
    mem[110] = 8'h70;
    mem[111] = 8'h96;
    mem[112] = 8'h00;
    mem[113] = 8'h00;
    mem[114] = 8'h00;
    mem[115] = 8'h00;
    mem[116] = 8'h00;
    mem[117] = 8'h00;
    mem[118] = 8'h00;
//0x077:                      | loop:
//0x077: 50a70000000000000000 | 	mrmovq (%rdi),%r10	# x = *start
    mem[119] = 8'h50;
    mem[120] = 8'ha7;
    mem[121] = 8'h00;
    mem[122] = 8'h00;
    mem[123] = 8'h00;
    mem[124] = 8'h00;
    mem[125] = 8'h00;
    mem[126] = 8'h00;
    mem[127] = 8'h00;
    mem[128] = 8'h00;
//0x081: 63bb                 | 	xorq %r11,%r11          # Constant 0
    mem[129] = 8'h63;
    mem[130] = 8'hbb;
//0x083: 61ab                 | 	subq %r10,%r11		# -x
    mem[131] = 8'h61;
    mem[132] = 8'hab;
//0x085: 719000000000000000   | 	jle pos			# Skip if -x <= 0
    mem[133] = 8'h71;
    mem[134] = 8'h90;
    mem[135] = 8'h00;
    mem[136] = 8'h00;
    mem[137] = 8'h00;
    mem[138] = 8'h00;
    mem[139] = 8'h00;
    mem[140] = 8'h00;
    mem[141] = 8'h00;
//0x08e: 20ba                 | 	rrmovq %r11,%r10	# x = -x
    mem[142] = 8'h20;
    mem[143] = 8'hba;
//0x090:                      | pos:
//0x090: 60a0                 | 	addq %r10,%rax          # Add to sum
    mem[144] = 8'h60;
    mem[145] = 8'ha0;
//0x092: 6087                 | 	addq %r8,%rdi           # start++
    mem[146] = 8'h60;
    mem[147] = 8'h87;
//0x094: 6196                 | 	subq %r9,%rsi           # count--
    mem[148] = 8'h61;
    mem[149] = 8'h96;
//0x096:                      | test:
//0x096: 747700000000000000   | 	jne    loop             # Stop when 0
    mem[150] = 8'h74;
    mem[151] = 8'h77;
    mem[152] = 8'h00;
    mem[153] = 8'h00;
    mem[154] = 8'h00;
    mem[155] = 8'h00;
    mem[156] = 8'h00;
    mem[157] = 8'h00;
    mem[158] = 8'h00;
//0x09f: 90                   | 	ret
    mem[159] = 8'h90;
//                            | /* $end abs-sum-jmp-ys */
//                            | 
//                            | # The stack starts here and grows to lower addresses
//0x200:                      | 	.pos 0x200		
//0x200:                      | stack:	 
	
	end
endmodule
