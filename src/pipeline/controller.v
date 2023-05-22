module controller (input [6:0] opc, 
                   input [6:0] funct7,
                   input [2:0] funct3,
                   output mem_to_regD, mem_writeD,
                   output [2:0] mem_sizeD,
                   output [1:0] alu_srcAD,
                   output [1:0] alu_srcBD,
                   output logic reg_writeD,
                   output logic jumpD,
                   output [3:0] alu_controlD,
                   output logic jump_srcD, endD, branchD, inv_branchD
                  );
    //
    maindec md (.opc(opc),
                .funct3(funct3),
                .mem_to_reg(mem_to_regD),
                .mem_write(mem_writeD),
                .mem_size(mem_sizeD),
                .branch(branchD),
                .alu_srcA(alu_srcAD),
                .alu_srcB(alu_srcBD),
                .reg_write(reg_writeD),
                .jump(jumpD),
                .jump_src(jump_srcD),
                .is_end(endD)
               );
    //
    aludec ad (.opc(opc),
               .funct7(funct7),
               .funct3(funct3),
               .alu_control(alu_controlD),
               .inv_branch(inv_branchD)
              );
    //
endmodule