`include "consts.v"

//
module datapath (input clk, reset, hlt,
                 //
                 input mem_to_regD, mem_writeD, jump_srcD,
                 input [2:0] mem_sizeD,
                 input [1:0] alu_srcAD,
                 input [1:0] alu_srcBD,
                 //
                 input reg_writeD, jumpD,
                 input [3:0] alu_controlD,
                 input alusrc_a_zero,
                 output [31:0] pcF,
                 input [31:0] instrF,
                 output [31:0] alu_outM, write_dataM,
                 input [31:0] read_dataM,
                 input mem_writeD,
                 output mem_writeM,
                 input [2:0] mem_sizeD,
                 output [2:0] mem_sizeM,
                 input branchD, inv_branchD,
                 output [31:0] instrD
                );
    //
    wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch, jump_base, jump_pc, jmp_pc_final;
    wire [4:0] ra1;
    wire [31:0] srca, srcb;
    wire [31:0] imm;
    wire [31:0] srca, srcb;
    wire [31:0] result;
    //
    //always @(posedge clk)
    //    if (hlt)
    //        $finish;
    //
    ////! NOTE: next PC logic
    //flopr #(32) pcreg(clk, reset, pcnext, pc);
    //adder pcadd1 (pc, 32'b100, pcplus4);
    //adder pcadd2(pc, imm, pcbranch);
    ////
    //mux2 #(32) pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
    //mux2 #(32) jmpscrmux(pc, srca, jump_src, jump_base);
    //adder jmptar(jump_base, imm, jump_pc);
    //assign jmp_pc_final = jump_pc & ~1;
    //mux2 #(32) pcmux(pcnextbr, jmp_pc_final, jump, pcnext);
    ////
    //imm_sel imm_sel(instr, imm);
    //assign ra1 = instr[19:15] & ~{5{alusrc_a_zero}};
    //
    ////! NOTE: register file logic
    //regfile rf(clk, ra1, instr[24:20],
    //           writereg, instr[11:7],
    //           result, srca, writedata);
    ////
    //mux2 #(32) resmux(aluout, readdata, memtoreg, result);
    ////
    //// mux2 #(5) wrmux(instr[20:16], instr[15:11], regdst, writereg);
    //// signext se(instr[15:0], signimm);
    //
    ////! NOTE: ALU logic
    //mux4 #(32) srcbmux(writedata, imm, pcbranch, pcplus4, alusrc, srcb);
    //alu alu(srca, srcb, alucontrol, aluout, zero);
//
endmodule