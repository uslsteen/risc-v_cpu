module riscv (input clk, reset,
              output [31:0] pc,
              input [31:0] instr,
              output memwrite, 
              output[2:0] memsize,
              output [31:0] aluout, writedata,
              input [31:0] readdata
             );
    //
    wire memtoreg, regwrite, jump;
    logic pcsrc, zero, alusrc_a_zero;
    logic jump_src, hlt;
    wire [1:0] alusrc;
    wire [3:0] alucontrol;
    //
    controller c(instr[6:0], instr[14:12], instr[31:25], zero, 
                 memtoreg, memwrite, memsize, pcsrc,
                 alusrc, regwrite, jump,
                 alucontrol, jump_src, alusrc_a_zero, hlt);
    //
    datapath dp(clk, reset, hlt, memtoreg, pcsrc, jump_src,
                alusrc, regwrite, jump,
                alucontrol, alusrc_a_zero,
                zero, pc, instr,
                aluout, writedata, readdata);
    
endmodule