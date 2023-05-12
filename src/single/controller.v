module controller (input [6:0] opc, 
                   input [6:0]funct7,
                   input [2:0]funct3,
                   input is_zero,
                   output memtoreg, memwrite,
                   output [2:0] memsize,
                   output pcsrc, 
                   output [1:0] alusrc,
                   output regwrite,
                   output jump,
                   output [3:0] alucontrol,
                   output jump_src, alusrc_a_zero, hlt
                  );
    //
    logic branch;
    logic inv_branch;
    maindec md (opc, funct3, 
                memtoreg, memwrite, memsize,
                branch, alusrc, alusrc_a_zero, regwrite, jump, jumpsrc, hlt);
    //
    aludec ad (opc, funct3, funct7, alucontrol, inv_branch);
    //
    assign pcsrc = branch & (is_zero ^ inv_branch);
    //
endmodule