// This is a 32 bit pseudo-random number generator using LFSR. The polynomial
// in use is x^32 + x^22 + x^2 + x^1 + 1

module lfsr32
    (
        input   logic i_clk, i_rst,
        input   logic i_en,             // Assert high for next random value

        input   logic i_load_seed,
        input   logic [31:0] i_seed,    // Seed must be non-zero. If the input is 0,
                                        // seed will be asserted as 1

        output  logic [31:0] o_val
    );

    logic [31:0] r_val;
    logic w_feedback;

    always @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_val <= 32'h1;
        else if (i_load_seed)
            r_val <= (i_seed == 32'h0) ? 32'h1 : i_seed;
        else if (i_en)
            r_val <= {r_val[30:0], w_feedback};
    end

    assign w_feedback = r_val[31] ^ r_val[21] ^ r_val[1] ^ r_val[0];
    assign o_val = r_val;

endmodule