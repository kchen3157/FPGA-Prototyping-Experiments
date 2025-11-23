module top
    (
        input   logic clk,
        input   logic cpu_resetn,

        input   logic [7:0] sw,
        input   logic btnc,

        // FMC sseg out
        output  logic [3:0] sseg_dig,
        output  logic sseg_a, sseg_b, sseg_c, sseg_d, sseg_e,
                      sseg_f, sseg_g, sseg_dp,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    logic [7:0] w_output;
    temp_conv_rom u_temp_conv_rom
        (
            .i_clk(clk),
            .i_input(sw[7:0]),
            .i_format(btnc),
            .o_output(w_output)
        );

    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    assign {sseg_dp, sseg_g, sseg_f, sseg_e,
            sseg_d, sseg_c, sseg_b, sseg_a} = w_sseg_n;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    sseg4 u_sseg4
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_bin({6'h000, w_output}),
        .i_neg(1'b0),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(sseg_dig),
        .o_idle()                    // For siulation usage
    );

endmodule
