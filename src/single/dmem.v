module dmem #(parameter DMEM_POWER = 18)
            (input clk, we,
             input [2:0] memsize,
             input [31:0] a, wd,
             output [31:0] rd
            );
//
    reg [31:0] RAM[((1 << DMEM_POWER) - 1):0];
    //! NOTE: word aligned
    assign rd = RAM[a[(DMEM_POWER + 1):2]];
    //
    always @ (posedge clk)
        if (we)
            RAM[a[(DMEM_POWER + 1):2]] <= wd;
    //! unused ?
//
endmodule