module top (input clk, reset,
            output [31:0] writedata, dataadr,
            output memwrite
           );
    //! NOTE: veerialtor public
    logic [31:0] pc, 
    logic [31:0] instr, readdata;
    logic [2:0] memsize;
    //
    // NOTE: instantiate processor and memories
    riscv riscv (clk, reset, pc, instr, memwrite, memsize, dataadr, writedata, readdata);
    imem #(18) imem (pc[19:2], instr);
    dmem #(18) dmem (clk, memwrite, memsize, dataadr, writedata, readdata);
    //
endmodule