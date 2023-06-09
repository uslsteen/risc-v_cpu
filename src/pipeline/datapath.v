
`include "consts.v"

//
module datapath (input clk, reset, endD,
                 //
                 input mem_to_regD, mem_writeD, jump_srcD,
                 input [2:0] mem_sizeD,
                 input [1:0] alu_srcAD,
                 input [1:0] alu_srcBD,
                 //
                 input reg_writeD, jumpD,
                 input [3:0] alu_controlD,
                 output [31:0] pcF,
                 input [31:0] instrF,
                 output [31:0] alu_outM, write_dataM,
                 input [31:0] read_dataM,
                 output mem_writeM,
                 output [2:0] mem_sizeM,
                 input branchD, inv_branchD,
                 output [31:0] instrD
                );

    logic [31:0] pc_out         /*verilator public*/;
    logic [31:0] instr          /*verilator public*/;
    logic [31:0] imm            /*verilator public*/;
    logic [4:0]  rd             /*verilator public*/;
    logic [4:0] ra1             /*verilator public*/;
    logic [4:0] ra2             /*verilator public*/;
    logic [31:0] alu_out        /*verilator public*/; 
    logic [31:0] write_data     /*verilator public*/; 
    logic [31:0] result         /*verilator public*/;
    logic mem_write             /*verilator public*/;
    logic reg_write             /*verilator public*/;
    logic valid                 /*verilator public*/;
    logic is_end                /*verilator public*/;

    //! -------------------------------------------------------------
    //! NOTE: fetch stage
    logic stallF;
    logic stallD, flushD;
    logic jumpE;
    
    logic [31:0] jmp_fin_pcE;
    logic [31:0] pcD; 
    logic [31:0] pcnextF, pcplus4F, pcbranchE, pcnextbrF;
    //
    pc_reg pcreg(.clk(clk), 
                 .en(!stallF), 
                 .clr(reset),
                 .pc_in(pcnextF), 
                 .pc_out(pcF)
                 );

    adder pcadd1(.a(pcF), .b(32'b100), .y(pcplus4F));

    logic pc_srcE;

    mux2 #(32) pcbrmux(.d0(pcplus4F), 
                       .d1(pcbranchE),
                       .s(pc_srcE), 
                       .y(pcnextbrF));

    mux2 #(32) pcmux(.d0(pcnextbrF), 
                     .d1(jmp_fin_pcE), 
                     .s(jumpE), 
                     .y(pcnextF));

    pipereg #(`F2D_WIDTH) Fetch2Decode(.clk(clk), 
                               .en(!stallD), 
                               .clr(flushD),
                               .inp({instrF, pcF}),
                               .out({instrD, pcD})
                              );

    //! -------------------------------------------------------------
    //! NOTE: decode stage
    logic [31:0] immD, rd1D, rd2D;
    logic [4:0] ra1D = instrD[19:15]; 
    logic [4:0] ra2D = instrD[24:20]; 
    logic [4:0] rdD = instrD[11:7];
    logic [4:0] rdW, ra1W, ra2W;
    logic reg_writeW;
    logic endE, mem_to_regE, jump_srcE, reg_writeE,
                mem_writeE, branchE, inv_brE, flushE;
    //
    logic [1:0] alu_srcAE, alu_srcBE;
    logic [2:0] mem_sizeE;
    logic [3:0] alu_controlE;
    logic [4:0] ra1E, ra2E, rdE;
    logic [31:0] immE;
    logic [31:0] pcE, rd1E, rd2E, instrE;
    logic [31:0] resultW;

    imm_sel imm_sel(.instr(instrD), .imm(immD));
    assign imm = immD;
    //
    regfile rf(.clk(clk), 
               .ra1(ra1D),
               .ra2(ra2D),
               .we3(reg_writeW), .wa3(rdW),
               .wd3(resultW),
               .rd1(rd1D), .rd2(rd2D)
              );
    //
    pipereg #(`D2E_WIDTH) Decode2Exec(.clk(clk), .en(1), .clr(flushE),
                               .inp({endD, 
                                     mem_to_regD, 
                                     jump_srcD, 
                                     alu_srcAD, 
                                     alu_srcBD, 
                                     reg_writeD, 
                                     jumpD, 
                                     alu_controlD, 
                                     pcD, 
                                     mem_writeD, 
                                     mem_sizeD, 
                                     branchD, 
                                     inv_branchD, 
                                     rd1D, 
                                     rd2D, 
                                     ra1D, 
                                     ra2D, 
                                     rdD, 
                                     immD, 
                                     instrD}),
                                //
                               .out({endE,
                                     mem_to_regE, 
                                     jump_srcE, 
                                     alu_srcAE, 
                                     alu_srcBE,
                                     reg_writeE, 
                                     jumpE, 
                                     alu_controlE, 
                                     pcE, 
                                     mem_writeE,
                                     mem_sizeE, 
                                     branchE, 
                                     inv_brE, 
                                     rd1E, 
                                     rd2E, 
                                     ra1E, 
                                     ra2E, 
                                     rdE,
                                     immE, 
                                     instrE})
                              );
    //! -------------------------------------------------------------
    //! NOTE: execute stage
    logic [31:0] srcAE, srcBE, alu_outE, rd1Efrw, rd2Efrw;
    logic [1:0] forwardAE, forwardBE;
    logic zeroE;
    logic controlChange;
    //
    assign pc_srcE = branchE & (zeroE ^ inv_brE);
    assign controlChange = pc_srcE | jumpE;

    //
    mux3 #(32) forwardAmux(.d0(rd1E), 
                           .d1(resultW), 
                           .d2(alu_outM),
                           .s(forwardAE), 
                           .y(rd1Efrw));

    mux3 #(32) forwardBmux(.d0(rd2E), 
                           .d1(resultW), 
                           .d2(alu_outM),
                           .s(forwardBE), 
                           .y(rd2Efrw));


    mux2 #(32) srcamux(.d0(rd1Efrw), 
                       .d1(pcE),
                       .s(alu_srcAE[0]), 
                       .y(srcAE));

    mux3 #(32) srcbmux(.d0(rd2Efrw), 
                       .d1(immE),
                       .d2(32'd4),
                       .s(alu_srcBE), 
                       .y(srcBE));

    alu alu(.a(srcAE), 
            .b(srcBE),
            .alu_op(alu_controlE), 
            .alu_out(alu_outE),
            .is_zero(zeroE));

    logic [31:0] jmp_baseE, jmp_pcE;
    adder pcaddimm(.a(pcE), .b(immE), .y(pcbranchE));

    mux2 #(32) jmpsrcmux(.d0(pcE), .d1(rd1E),
                         .s(jump_srcE), .y(jmp_baseE));

    adder jmptar(.a(jmp_baseE), .b(immE), .y(jmp_pcE));
    
    assign jmp_fin_pcE = jmp_pcE & ~1;
    logic [31:0] write_dataE;
    assign write_dataE = rd2Efrw;

    logic reg_writeM, mem_to_regM, endM, controlChangeM;
    logic [4:0] rdM, ra1M, ra2M;
    logic [31:0] pcM;
    logic [31:0] instrM;

    pipereg #(`E2M_WIDTH) Exec2Memory(.clk(clk), 
                               .en(1), 
                               .clr(reset),
                               .inp({reg_writeE, 
                                     mem_to_regE,  
                                     mem_writeE,
                                     endE, 
                                     mem_sizeE, 
                                     rdE, 
                                     ra1E,
                                     ra2E,
                                     write_dataE, 
                                     alu_outE,
                                     pcE, 
                                     controlChange, 
                                     instrE}),
                                //
                               .out({reg_writeM, 
                                     mem_to_regM, 
                                     mem_writeM,
                                     endM, 
                                     mem_sizeM, 
                                     rdM, 
                                     ra1M,
                                     ra2M,
                                     write_dataM, 
                                     alu_outM, 
                                     pcM, 
                                     controlChangeM, 
                                     instrM}));

    //! -------------------------------------------------------------
    //! NOTE: memory stage
    //
    logic mem_writeW, controlChangeW, mem_to_regW, endW;
    logic validW;
    logic [31:0] pcW, instrW, alu_outW, write_dataW, read_dataW;
    //
    
    pipereg #(`M2W_WIDTH) Memory2Write(.clk(clk), 
                                .en(1), 
                                .clr(reset),
                                .inp({reg_writeM, 
                                      mem_to_regM, 
                                      endM, 
                                      rdM,
                                      ra1M,
                                      ra2M, 
                                      alu_outM, 
                                      read_dataM, 
                                      mem_writeM, 
                                      write_dataM, 
                                      pcM != 0, 
                                      pcM, 
                                      controlChangeM, 
                                      instrM}),
                                //
                                .out({reg_writeW, 
                                      mem_to_regW, 
                                      endW, 
                                      rdW, 
                                      ra1W, 
                                      ra2W,
                                      alu_outW, 
                                      read_dataW, 
                                      mem_writeW, 
                                      write_dataW, 
                                      validW, 
                                      pcW, 
                                      controlChangeW, 
                                      instrW}));

    //! -------------------------------------------------------------
    //! NOTE: writeback stage
    mux2 #(32) resmux(.d0(alu_outW), 
                      .d1(read_dataW),
                      .s(mem_to_regW), 
                      .y(resultW));
                    
    reg[31:0] tact_num /*verilator public*/;
    assign tact_num = 0;
    
    always @(negedge clk) begin
        tact_num <= tact_num + 1;
    end
    //
    assign pc_out = pcW;
    //    
    assign instr = instrW;
    assign valid = validW;
    //
    assign reg_write = reg_writeW & rdW != 0;
    assign rd = rdW;
    assign ra1 = ra1W;
    assign ra2 = ra2W;
    assign result = resultW;
    //
    assign mem_write = mem_writeW;
    assign alu_out = alu_outW;
    assign write_data = write_dataW;
    assign is_end = endW;

    //! -------------------------------------------------------------
    
    hazard hazard_resolver(.ra1D(ra1D), 
                           .ra2D(ra2D), 
                           .ra1E(ra1E), 
                           .ra2E(ra2E),
                           .rdE(rdE),
                           .rdM(rdM),
                           .rdW(rdW),
                           .controlChange(controlChange),
                           .mem_to_regE(mem_to_regE),
                           .reg_writeM(reg_writeM),
                           .reg_writeW(reg_writeW),
                           .stallF(stallF),
                           .stallD(stallD),
                           .flushD(flushD),
                           .flushE(flushE),
                           .forwardAE(forwardAE),
                           .forwardBE(forwardBE));


    wire unused_warning_fix = &{1'b0,
                                alu_srcAE,
                                mem_writeW,
                                validW,
                                controlChangeW,
                                endW,
                                write_dataW,
                                pcW,
                                instrW,
                                1'b0};
//
endmodule