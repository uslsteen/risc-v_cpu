module hazard (
                input [4:0] ra1D, ra2D, ra1E, ra2E, rdE, rdM, rdW,
                input controlChange, mem_to_regE, reg_writeM, reg_writeW,
                output stallF, stallD, flushD, flushE,
                output [1:0] forwardAE, forwardBE
              );
    
    // Bypasses
    set_forward setA(.raE(ra1E), .rdM(rdM), .rdW(rdW),
                    .reg_writeM(reg_writeM), .reg_writeW(reg_writeW),
                    .forward(forwardAE));

    set_forward setB(.raE(ra2E), .rdM(rdM), .rdW(rdW),
                    .reg_writeM(reg_writeM), .reg_writeW(reg_writeW),
                    .forward(forwardBE));

    // Stall pipeline
    logic lwStall;
    assign lwStall = mem_to_regE & ((ra1D == rdE) || (ra2D == rdE));
    assign stallF = lwStall;
    assign stallD = lwStall;

    // Control hazards
    assign flushD = controlChange;
    assign flushE = lwStall | controlChange;
endmodule
