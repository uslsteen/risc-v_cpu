module imem #(parameter IMEM_POWER = 18)
            (input [(IMEM_POWER - 1):0] a,
             output [31:0] rd
            );
    
    reg [31:0] RAM[((1 << IMEM_POWER) - 1):0] /* verilator public */;
    //! NOTE: word aligned
    assign rd = RAM[a] ;
    //
endmodule