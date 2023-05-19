`include "alu_consts.v"

module alu(input [31:0] a, b,
           input [3:0] alu_op,
           output reg[31:0] alu_out,
           output reg zero);

  logic [4:0] shamt = b[4:0];
  // always @(*) begin
  always_latch begin 
                case (alu_op)
                         `ALUOP_ADD:
                             alu_out = a + b;
                         `ALUOP_SUB:
                             alu_out = a - b;
                         `ALUOP_AND:
                             alu_out = a & b;
                         `ALUOP_OR:
                             alu_out = a | b;
                         `ALUOP_XOR:
                             alu_out = a ^ b;
                         `ALUOP_SLTU:
                             alu_out = {{31{1'b0}}, a < b};
                         `ALUOP_SLT:
                             alu_out = {{31{1'b0}}, $signed(a) < $signed(b)};
                         `ALUOP_SLL:
                             alu_out = a << shamt;
                         `ALUOP_SRL:
                             alu_out = a >> shamt;
                         `ALUOP_SRA:
                             alu_out = $signed(a) >>> shamt;
                        //! NOTE: by default do nothing
                         default: ;
                endcase 
                zero = (alu_out == 0);
              end
endmodule