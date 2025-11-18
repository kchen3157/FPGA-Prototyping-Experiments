module top
    (
        input   logic clk, cpu_resetn,
        input   logic btnl, // START
        input   logic btnc, // STOP
        input   logic btnr, // CLEAR

        output   logic [7:0] led,


        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    //********* DISPLAY OUTPUT *********
    // Create nets to connect sseg4 and reaction together
    logic [13:0] w_reaction_val;
    logic w_reaction_greeting, w_reaction_led;
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
        .i_bin(w_reaction_val),
        .i_greeting(w_reaction_greeting),               // When asserted, display "HI"

        .o_sseg_n(w_sseg_n),
        .o_ldsel(w_ldsel),
        .o_idle()                    // For siulation usage
    );

    
    reaction u_reaction
    (
        .i_clk(clk), .i_rst(~cpu_resetn),

        .i_start(btnl), .i_clear(btnr), .i_stop(btnc), // user control signals

        .o_display_val(w_reaction_val), // output to display, in binary (BCD conversion and led mux handled by other modules)
        .o_display_greeting(w_reaction_greeting), // when high, the display module ignores input val and displays "HI"
        .o_led(w_reaction_led) // stimulus LED
    );

    assign led = (w_reaction_led) ? 8'b11111111 : 8'b00000000;



endmodule
