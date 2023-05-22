module pc_reg (
        input clk,
        input en,
        input clr,
        input [31:0] pc_in,
        output [31:0] pc_out
    );
    reg [31:0] pc /* verilator public */;
    assign pc_out = pc;

    always @(posedge clk)
        if (clr)
            pc <= 0;
        else if (en)
            pc <= pc_in;

endmodule
