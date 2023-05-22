`include "alu_consts.v"

module aludec (input [6:0] opc,
               input [6:0] funct7,
               input [2:0] funct3,
               output reg [3:0] alu_control,
               output inv_branch
              );
//
    assign inv_branch = (funct3 & 3'b110) == 0 ? funct3[0] : !funct3[0];
    
    always_latch
        case (opc)
            `OPC_BRANCH:
            case (funct3)
                3'b000, 3'b001: begin
                    //! NOTE: beq, bne
                    alu_control = `ALUOP_SUB;
                end
                3'b100, 3'b101:
                    //! NOTE: blt, bge
                    alu_control = `ALUOP_SLT;
                3'b110, 3'b111:
                    alu_control = `ALUOP_SLTU;
                default
                    alu_control = 4'bxxxx;
            endcase
            //
            `OPC_LUI, `OPC_AUIPC, `OPC_JAL, `OPC_JALR, `OPC_LOAD, `OPC_STORE, `OPC_SYSTEM:
                alu_control = `ALUOP_ADD;
            //
            `OPC_R_TYPE, `OPC_I_TYPE: begin
                logic is_funct7_zero = (funct7 == 0);
                case (funct3)
                    3'b000:
                        alu_control = (opc == `OPC_I_TYPE) || is_funct7_zero ? `ALUOP_ADD : `ALUOP_SUB;
                    3'b001:
                        alu_control = `ALUOP_SLL;
                    3'b010:
                        alu_control = `ALUOP_SLT;
                    3'b011:
                        alu_control = `ALUOP_SLTU;
                    3'b100:
                        alu_control = `ALUOP_XOR;
                    3'b101:
                        alu_control = is_funct7_zero ? `ALUOP_SRL : `ALUOP_SRA;
                    3'b110:
                        alu_control = `ALUOP_OR;
                    3'b111:
                        alu_control = `ALUOP_AND;
                    default:
                        alu_control = 4'bxxxx;
                endcase
            end
            //
            default:
                alu_control = 4'bxxxx;
        endcase
endmodule