module pipereg #(parameter WIDTH = 32) (
        input clk,
        input en,
        input clr,
        input [(WIDTH - 1):0] inp,
        output [(WIDTH - 1):0] out
    );
    
    //
    reg [(WIDTH - 1):0] storage_data;
    assign out = storage_data;

    //
    always @(posedge clk)
        if (clr)
            storage_data <= 0;
        else if (en)
            storage_data <= inp;

endmodule
