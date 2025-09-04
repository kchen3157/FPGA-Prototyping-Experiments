module top
    (
        input   logic clk, cpu_resetn,
        input   logic [7:0] sw,
        input   logic btn,

        output  logic [1:0] led,
        
        // vadj
        output  logic [1:0] set_vadj,
        output  logic vadj_en,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p
    );

    logic [3:0] w_quotient, w_remain;
    div u_div
    (
        .i_clk(clk), .i_rst(~cpu_resetn),
        .i_start(btn),
        .i_dividend(sw[7:4]), .i_divisor(sw[3:0]),
        .o_ready(led[0]), .o_done(led[1]),
        .o_quotient(w_quotient), .o_remain(w_remain)
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
        (.i_hex(w_remain), .i_dp(1'b0), .o_sseg_n(w_map_n[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_quotient), .i_dp(1'b0), .o_sseg_n(w_map_n[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(sw[3:0]), .i_dp(1'b0), .o_sseg_n(w_map_n[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(sw[7:4]), .i_dp(1'b0), .o_sseg_n(w_map_n[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(clk), .i_reset(~cpu_resetn), .i_in_n(w_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));


endmodule
