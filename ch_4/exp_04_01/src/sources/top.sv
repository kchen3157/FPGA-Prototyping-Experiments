module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        input   logic [7:0] sw,
        output  logic ja0
    );

    square_wave_gen u_square_wave_gen
        (.i_clk(clk), .i_rst(~cpu_resetn), .i_m(sw[3:0]),
         .i_n(sw[7:4]), .o_q(ja0));
    
    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(w_s0), .i_dp(1'b0), .o_sseg_n(w_led_map[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_s1), .i_dp(1'b0), .o_sseg_n(w_led_map[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_s2), .i_dp(1'b1), .o_sseg_n(w_led_map[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(4'h0), .i_dp(1'b0), .o_sseg_n(w_led_map[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(w_clk_slow), .i_reset(~cpu_resetn), .i_pwm_ctl(sw),
         .i_in_n(w_led_map), .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));

endmodule
