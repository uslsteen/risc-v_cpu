module top (input clk, reset);
    //
    logic [31:0] pcF /* verilator public */;
    logic [31:0] instrF /* verilator public */;
    logic [31:0] read_dataM, write_dataM, alu_outM;
    logic [2:0] mem_sizeM;
    logic mem_writeM;
    //
    // NOTE: instantiate processor and memories
    riscv riscv (.clk(clk), 
                 .reset(reset), 
                 .pcF(pcF), 
                 .instrF(instrF), 
                 .mem_writeM(mem_writeM), 
                 .mem_sizeM(mem_sizeM), 
                 .alu_outM(alu_outM), 
                 .write_dataM(write_dataM), 
                 .read_dataM(read_dataM)
                );
    
    //
    imem #(18) imem (.a(pcF[19:2]), 
                     .rd(instrF));

    //
    dmem #(18) dmem (.clk(clk), 
                     .we(mem_writeM), 
                     .mem_size(mem_sizeM), 
                     .a(alu_outM), 
                     .wd(write_dataM), 
                     .rd(read_dataM)
                    );
    //
endmodule