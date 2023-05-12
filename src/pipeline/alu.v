`include "alu_consts.v"

module alu(input [31:0] a, b,
           input [3:0] ALU_op,
           output reg[31:0] ALU_out,
           output reg zero);

  logic [4:0] shamt = b[4:0];
  // always @(*) begin
  always_latch begin 
                case (ALU_op)
                         `ALUOP_ADD:
                             ALU_out = a + b;
                         `ALUOP_SUB:
                             ALU_out = a - b;
                         `ALUOP_AND:
                             ALU_out = a & b;
                         `ALUOP_OR:
                             ALU_out = a | b;
                         `ALUOP_XOR:
                             ALU_out = a ^ b;
                         `ALUOP_SLTU:
                             ALU_out = {{31{1'b0}}, a < b};
                         `ALUOP_SLT:
                             ALU_out = {{31{1'b0}}, $signed(a) < $signed(b)};
                         `ALUOP_SLL:
                             ALU_out = a << shamt;
                         `ALUOP_SRL:
                             ALU_out = a >> shamt;
                         `ALUOP_SRA:
                             ALU_out = $signed(a) >>> shamt;
                        //! NOTE: by default do nothing
                         default: ;
                endcase 
                zero = (ALU_out == 0);
              end
endmodule