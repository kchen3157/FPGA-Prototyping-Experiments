module top
    (
        input   logic clk, cpu_resetn,
        input   logic [1:0] sw,

        // vadj
        output  logic [1:0] set_vadj,
        output  logic vadj_en,

        // FMC sseg out
        output  logic fmc_clk0_m2c_n, fmc_clk1_m2c_n,
        output  logic fmc_la_2n, fmc_la_2p, fmc_la_3p, fmc_la_4p,
                      fmc_la_5n, fmc_la_8n, fmc_la_8p, fmc_la_9n,
                      fmc_la_9p, fmc_la_12p
    );

    // Wires
    logic w_car_enter, w_car_exit;
    logic [15:0] w_occupancy_count;

    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;
    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    // Set v_adj to 1.8V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b01;

    parking_lot_occupancy_counter u_parking_lot_occupancy_counter
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_a(sw[0]), .i_b(sw[1]),
         .o_car_enter(w_car_enter), .o_car_exit(w_car_exit));

    countreg u_countreg
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_inc(w_car_enter), .i_dec(w_car_exit),
         .o_count(w_occupancy_count));

    // output
    logic [7:0] w_map_n [3:0];
    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(w_occupancy_count[3:0]), .i_dp(1'b0), .o_sseg_n(w_map_n[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_occupancy_count[7:4]), .i_dp(1'b0), .o_sseg_n(w_map_n[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_occupancy_count[11:8]), .i_dp(1'b0), .o_sseg_n(w_map_n[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(w_occupancy_count[15:12]), .i_dp(1'b0), .o_sseg_n(w_map_n[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(clk), .i_reset(~cpu_resetn), .i_in_n(w_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));

endmodule
