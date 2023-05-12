module riscv (input clk, reset,
              output [31:0] pcF,
              input [31:0] instrF,
              output memwriteM, 
              output[2:0] memsizeM,
              output [31:0] aluoutM, writedataM,
              input [31:0] readdataM
             );
    //
    logic memtoregD, regwriteD, jumpD;
    logic alusrc_a_zeroD;
    logic jump_srcD, hltD, branchD, inv_branchD, memwriteD;
    //
    logic [1:0] alusrcAD, alusrcBD; 
    logic [3:0] alucontrolD;
    logic [31:0] instrD;
    logic [2:0] memsizeD;
    //
    controller c(instrD[6:0], 
                 instrD[31:25], 
                 instrD[14:12], 
                 memtoregD, 
                 memwriteD, 
                 memsizeD, 
                 alusrcAD,
                 alusrcBD, 
                 regwriteD, 
                 jumpD,
                 alucontrolD, 
                 jump_srcD, 
                 alusrc_a_zeroD, 
                 hltD,
                 branchD,
                 inv_branchD
                 );
    //
    datapath dp(clk, 
                reset, 
                hltD, 
                memtoregD, 
                jump_srcD,
                alusrcAD,
                alusrcBD, 
                regwriteD, 
                jumpD,
                alucontrolD, 
                alusrc_a_zeroD,
                pcF, 
                instrF,
                aluoutM, 
                writedataM, 
                readdataM,
                memwriteD, 
                memwriteM,
                memsizeD,
                memsizeM, 
                branchD,
                inv_branchD,
                instrD
               );
    //
    //! NOTE fixed unused 
    //
endmodule