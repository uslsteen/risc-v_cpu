`define FORWARD_NO 2'b00
`define FORWARD_FROM_WB 2'b01
`define FORWARD_FROM_MEMORY 2'b10

module set_forward (
                     input [4:0] raE, rdM, rdW,
                     input reg_writeM, reg_writeW,
                     output [1:0] forward
                   );
    //
    assign forward = ((raE == rdM) && reg_writeM && (raE != 0)) ? `FORWARD_FROM_MEMORY :
                     ((raE == rdW) && reg_writeW && (raE != 0)) ? `FORWARD_FROM_WB :
                                                                  `FORWARD_NO;

endmodule
