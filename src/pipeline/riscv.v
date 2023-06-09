module riscv (input clk, reset,
              output [31:0] pcF,
              input  [31:0] instrF,
              output        mem_writeM, 
              output [2:0]  mem_sizeM,
              output [31:0] alu_outM, write_dataM,
              input  [31:0] read_dataM
             );
    //
    logic mem_to_regD, reg_writeD, jumpD;
    logic jump_srcD, endD, branchD, inv_branchD, mem_writeD;
    //
    logic [1:0] alu_srcAD, alu_srcBD; 
    logic [3:0] alu_controlD;
    logic [31:0] instrD;
    logic [2:0] mem_sizeD;
    //
    controller c(.opc(instrD[6:0]), 
                 .funct7(instrD[31:25]), 
                 .funct3(instrD[14:12]), 
                 .mem_to_regD(mem_to_regD), 
                 .mem_writeD(mem_writeD), 
                 .mem_sizeD(mem_sizeD), 
                 .alu_srcAD(alu_srcAD),
                 .alu_srcBD(alu_srcBD), 
                 .reg_writeD(reg_writeD), 
                 .jumpD(jumpD),
                 .alu_controlD(alu_controlD), 
                 .jump_srcD(jump_srcD), 
                 .endD(endD),
                 .branchD(branchD),
                 .inv_branchD(inv_branchD)
                 );
    //
    datapath dp(.clk(clk), 
                .reset(reset), 
                .endD(endD), 
                .mem_to_regD(mem_to_regD), 
                .mem_writeD(mem_writeD), 
                .jump_srcD(jump_srcD),
                .mem_sizeD(mem_sizeD),
                .alu_srcAD(alu_srcAD),
                .alu_srcBD(alu_srcBD), 
                .reg_writeD(reg_writeD), 
                .jumpD(jumpD),
                .alu_controlD(alu_controlD), 
                .pcF(pcF),
                .instrF(instrF),
                .alu_outM(alu_outM), 
                .write_dataM(write_dataM), 
                .read_dataM(read_dataM),
                .mem_writeM(mem_writeM),
                .mem_sizeM(mem_sizeM), 
                .branchD(branchD),
                .inv_branchD(inv_branchD),
                .instrD(instrD)
                );
    //
    //! NOTE fixed unused 
    wire unused_warning_fix = &{1'b0,
                                instrD[24:15],
                                instrD[11:7],
                                1'b0};
    //
endmodule