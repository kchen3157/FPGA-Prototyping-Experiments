module top
    (
        input   logic clk,
        input   logic cpu_resetn,

        input   logic [7:0] sw,

        // FMC sseg out
        output  logic [3:0] sseg_dig,
        output  logic sseg_a, sseg_b, sseg_c, sseg_d, sseg_e,
                      sseg_f, sseg_g, sseg_dp,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    logic [3:0] w_sum;
    add_signmag_rom u_add_signmag_rom
        (
            .i_clk(clk),
            .i_a(sw[7:4]), .i_b(sw[3:0]),
            .o_sum(w_sum)
        );

    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {sseg_dp, sseg_g, sseg_f, sseg_e,
            sseg_d, sseg_c, sseg_b, sseg_a} = w_sseg_n;
    assign  sseg_dig = w_ldsel;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    sseg4 u_sseg4
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_bin({11'h000, w_sum[2:0]}),
        .i_neg(w_sum[3]),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(w_ldsel),
        .o_idle()                    // For siulation usage
    );

endmodule
