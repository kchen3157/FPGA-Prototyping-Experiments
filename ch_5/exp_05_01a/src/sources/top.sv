// FMC MEZZANINE

// MSPI HEADERS
// A  B  C  D  E          F   G  DP
// 9N 3P 9P 8N CLK0_M2C_N 12P 8P 5N

// I2S HEADERS
// L1 L2 L3  L4
// 2P 2N 4P CLK1_M2C_N

// LED SOCKET

// L1 A  F  L2 L3 B
// 12 11 10 9  8  7

// 1  2  3  4  5  6
// E  D  DP C  G  L4


// SOCKET -> FMC
// 1 -> CLK0_M2C_N (MSPI[5])
// 2 -> 8N (MSPI[4])
// 3 -> 5N (MSPI[8])
// 4 -> 9P (MSPI[3])
// 5 -> 8P (MSPI[7])
// 6 -> CLK1_M2C_N (I2S[4])
// 7 -> 3P (MSPI[2])
// 8 -> 4P (I2S[3])
// 9 -> 2N (I2S[2])
// 10 -> 12P (MSPI[6])
// 11 -> 9N (MSPI[1])
// 12 -> 2P (I2S[1])


module top
    (
        input   logic clk, cpu_resetn,
        input   logic btnc, btnu, // input, clear counter

        // vadj
        output  logic [1:0] set_vadj,
        output  logic vadj_en,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p,

        // Probing
        output  logic ja0, ja1, ja2, ja3, ja4, jb0
    );

    // Set v_adj to 1.8V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b01;

    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    logic [7:0] w_lvl_count, w_lvl_db_count;
    debounce_counter u_debounce_counter
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_clr(btnu), .i_lvl(btnc),
         .o_lvl_count(w_lvl_count), .o_lvl_db_count(w_lvl_db_count), .o_lvl_db(ja0),
        .o_debounce_state({ja4, ja3, ja2}), .o_slow_tick(jb0));

    assign ja1 = btnc;


    // output
    logic [7:0] w_map_n [3:0];
    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(w_lvl_count[3:0]), .i_dp(1'b0), .o_sseg_n(w_map_n[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_lvl_count[7:4]), .i_dp(1'b0), .o_sseg_n(w_map_n[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_lvl_db_count[3:0]), .i_dp(1'b1), .o_sseg_n(w_map_n[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(w_lvl_db_count[7:4]), .i_dp(1'b0), .o_sseg_n(w_map_n[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(clk), .i_reset(~cpu_resetn), .i_in_n(w_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));


endmodule
