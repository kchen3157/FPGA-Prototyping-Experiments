module top
    (
        input   logic clk, cpu_resetn,
        input   logic btnc, // START
        input   logic btnu, // CLEAR

        output   logic [5:0] sw,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    logic [12:0] w_bab_2_3_5_val;
    bab_2_3_5 u_bab_2_3_5
        (
            .i_clk(clk), .i_rst(~cpu_resetn),
            .i_start(btnc), .i_clear(btnu),
            .i_n(sw[5:0]),

            .o_val(w_bab_2_3_5_val)
        );


    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    sseg4 u_sseg4
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_bin({1'b0, w_bab_2_3_5_val}),
        .i_greeting(1'b0),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(w_ldsel),
        .o_idle()                    // For siulation usage
    );

    

endmodule
