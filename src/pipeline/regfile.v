module regfile (input clk,
                input [4:0] ra1, ra2,
                input we3,
                input [4:0] wa3,
                input [31:0] wd3,
                output [31:0] rd1, rd2
               );
    //
    reg [31:0] reg_file[31:0] /*verilator public*/;
    
    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0

    always @ (negedge clk)
        if (we3) reg_file[wa3] <= wd3;
    assign rd1 = (ra1 != 0) ? reg_file[ra1] : 0;
    assign rd2 = (ra2 != 0) ? reg_file[ra2] : 0;
    
endmodule