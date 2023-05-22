`include "opcodes.v"
`include "consts.v"

module maindec(input logic[6:0] opc,
               input logic[2:0] funct3,
               output logic mem_to_reg, mem_write,
               output logic[2:0] mem_size,
               output logic branch,
               output logic[1:0] alu_srcA,
               output logic[1:0] alu_srcB,
               output logic reg_write,
               output logic jump,
               output logic jump_src,
               output logic is_end
              );

    always_comb
        case(opc)
            `OPC_AUIPC: begin
                alu_srcA = `ALU_SRCA_PC;
                alu_srcB = `ALU_SRCB_IMM;
                reg_write = 1;
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                mem_write = 0;
                branch = 0;
                jump = 0;
                jump_src = 0;
                is_end = 0;
            end
            `OPC_LUI, `OPC_I_TYPE: begin
                alu_srcA = `ALU_SRCA_REG;
                alu_srcB = `ALU_SRCB_IMM;
                reg_write = 1;
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                mem_write = 0;
                branch = 0;
                jump = 0;
                jump_src = 0;
                is_end = 0;
            end
            `OPC_R_TYPE, `OPC_BRANCH: begin
                alu_srcA = `ALU_SRCA_REG;
                alu_srcB = `ALU_SRCB_REG;
                reg_write = (opc == `OPC_R_TYPE);
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                mem_write = 0;
                branch = (opc == `OPC_BRANCH);
                jump = 0;
                jump_src = 0;
                is_end = 0;
            end
            `OPC_JAL, `OPC_JALR: begin
                jump_src = (opc == `OPC_JALR);
                alu_srcA = `ALU_SRCA_PC;
                alu_srcB = `ALU_SRCB_FOUR;
                jump = 1;
                reg_write = 1;
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                mem_write = 0;
                branch = 0;
                is_end = 0;
            end
            `OPC_LOAD, `OPC_STORE: begin
                alu_srcA = `ALU_SRCA_REG;
                alu_srcB = `ALU_SRCB_IMM;
                reg_write = (opc == `OPC_LOAD);
                mem_to_reg = (opc == `OPC_LOAD);
                mem_size = funct3;
                mem_write = (opc == `OPC_STORE);
                branch = 0;
                jump = 0;
                jump_src = 0;
                is_end = 0;
            end
            `OPC_SYSTEM: begin
                is_end = 1;
                alu_srcA = 2'bxx;
                alu_srcB = 2'bxx;
                mem_write = 0;
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                branch = 0;
                reg_write = 0;
                jump = 0;
                jump_src = 0;
            end
            default: begin
                is_end = 0;
                alu_srcA = 2'bxx;
                alu_srcB = 2'bxx;
                mem_write = 0;
                mem_size = 3'bxxx;
                mem_to_reg = 0;
                branch = 0;
                reg_write = 0;
                jump = 0;
                jump_src = 0;
                $display("ERROR: unknown opcode %d", opc);
            end
        endcase
    endmodule
