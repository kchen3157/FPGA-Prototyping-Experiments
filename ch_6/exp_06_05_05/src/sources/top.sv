`timescale 1 ns/10 ps

module top
    (
        input   logic clk, cpu_resetn,
        input   logic btnc,
        output  logic [1:0] led,

        // SIGNAL IN
        input   logic [0:0] ja,
        // input   logic btnu,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    logic btnc_db;
    debouncer u_debouncer_btnc
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_sw(btnc),
        .o_sw_debounced(btnc_db),
        .o_debounce_state(),
        .o_slow_tick()
    );

    logic btnu_db;
    debouncer u_debouncer_btnu
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_sw(btnu),
        .o_sw_debounced(btnu_db),
        .o_debounce_state(),
        .o_slow_tick()
    );

    logic [3:0] w_frequency_map [3:0];
    logic [3:0] w_dp_map;
    low_freq_counter_bcd u_low_freq_counter_bcd
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_start(btnc_db), 
        
        .i_signal(ja[0]),
        // .i_signal(btnu_db),

        .o_freq_bcd3(w_frequency_map[3]),
        .o_freq_bcd2(w_frequency_map[2]),
        .o_freq_bcd1(w_frequency_map[1]),
        .o_freq_bcd0(w_frequency_map[0]),
        .o_freq_dp(w_dp_map),
    
        .o_overflow(), .o_underflow(),
        .o_ready(led[0]), .o_done(led[1])
    );


    //********* DISPLAY OUTPUT *********
    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    // Set v_adj to 3.3V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b11;

    // output
    logic [7:0] w_map_n [3:0];
    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(w_frequency_map[0]), .i_dp(w_dp_map[0]), .o_sseg_n(w_map_n[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_frequency_map[1]), .i_dp(w_dp_map[1]), .o_sseg_n(w_map_n[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_frequency_map[2]), .i_dp(w_dp_map[2]), .o_sseg_n(w_map_n[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(w_frequency_map[3]), .i_dp(w_dp_map[3]), .o_sseg_n(w_map_n[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(clk), .i_reset(~cpu_resetn), .i_in_n(w_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));
endmodule
