`timescale 1 ns/10 ps

module top
    (
        input   logic clk, cpu_resetn,
        input   logic [7:0] sw,
        input   logic btn,
        output  logic [1:0] led,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // vadj
        (* DONT_TOUCH = "TRUE" *) output  logic [1:0] set_vadj,
        (* DONT_TOUCH = "TRUE" *) output  logic vadj_en
    );

    logic [3:0] w_gen_amt_map [1:0];
    logic [3:0] w_final_map [3:0];
    fib_ctl u_fib_ctl
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_start(btn),
        .i_gen_amt_bcd0(w_gen_amt_map[0]),
        .i_gen_amt_bcd1(w_gen_amt_map[1]),
        .o_final_bcd0(w_final_map[0]),
        .o_final_bcd1(w_final_map[1]),
        .o_final_bcd2(w_final_map[2]),
        .o_final_bcd3(w_final_map[3]),
        .o_ready(led[0]), .o_done(led[1])
    );

    assign w_gen_amt_map[0] = sw[3:0];
    assign w_gen_amt_map[1] = sw[7:4];


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
        (.i_hex(w_final_map[0]), .i_dp(1'b0), .o_sseg_n(w_map_n[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_final_map[1]), .i_dp(1'b0), .o_sseg_n(w_map_n[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_final_map[2]), .i_dp(1'b0), .o_sseg_n(w_map_n[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(w_final_map[3]), .i_dp(1'b0), .o_sseg_n(w_map_n[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(clk), .i_reset(~cpu_resetn), .i_in_n(w_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));
endmodule
