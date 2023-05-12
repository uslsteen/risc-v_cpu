`include "alu_consts.v"

module aludec (input [6:0] opc,
               input [6:0] funct7,
               input [2:0] funct3,
               output reg [3:0] alucontrol,
               output inv_branch
              );
//
    always_latch
        case (opc)
            `OPC_BRANCH:
            case (funct3)
                3'b000, 3'b001: begin
                    inv_branch = funct3 = 3'b001;
                    //! NOTE: beq, bne
                    alucontrol = `ALUOP_SUB;
                end
                3'b100, 3'b101:
                    //! NOTE: blt, bge
                    alucontrol = `ALUOP_SLT;
                3'b110, 3'b111:
                    alucontrol = `ALUOP_SLTU;
                default
                    alucontrol = 4'bxxxx;
            endcase
            //
            `OPC_LUI, `OPC_AUIPC, `OPC_JAL, `OPC_JALR, `OPC_LOAD, `OPC_STORE, `OPC_SYSTEM:
                alucontrol = `ALUOP_ADD;
            //
            `OPC_R_TYPE, `OPC_I_TYPE: begin
                logic is_funct7_zero = (funct7 == 0);
                case (funct3)
                    3'b000:
                        alucontrol = (opcode == `OPC_I_TYPE) || is_funct7_zero ? `ALUOP_ADD : `ALUOP_SUB;
                    3'b001:
                        alucontrol = `ALUOP_SLL;
                    3'b010:
                        alucontrol = `ALUOP_SLT;
                    3'b011:
                        alucontrol = `ALUOP_SLTU;
                    3'b100:
                        alucontrol = `ALUOP_XOR;
                    3'b101:
                        alucontrol = is_funct7_zero ? `ALUOP_SRL : `ALUOP_SRA;
                    3'b110:
                        alucontrol = `ALUOP_OR;
                    3'b111:
                        alucontrol = `ALUOP_AND;
                    default:
                        alucontrol = 4'bxxxx;
                endcase
            end
            //
            default:
                alucontrol = 4'bxxxx;
        endcase
endmodule