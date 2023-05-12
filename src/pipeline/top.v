module top (input clk, reset);
    //
    logic [31:0] pcF /* verilator public */;
    logic [31:0] instrF, read_dataM, write_dataM, ALU_outM;
    logic [2:0] mem_sizeM;
    logic mem_sizeM;
    //
    // NOTE: instantiate processor and memories
    riscv riscv (clk, 
                 reset, 
                 pcF, 
                 instrF, 
                 mem_sizeM, 
                 mem_sizeM, 
                 ALU_outM, 
                 write_dataM, 
                 read_dataM
                );
    
    //
    imem #(18) imem (pcF[19:2], 
                     instrF
                    );

    //
    dmem #(18) dmem (clk, 
                     mem_sizeM, 
                     mem_sizeM, 
                     ALU_outM, 
                     write_dataM, 
                     read_dataM
                    );
    //
endmodule