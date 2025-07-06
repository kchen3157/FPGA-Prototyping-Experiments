module led_switch
    (
        input i_clk, i_reset,
        input [7:0] i_sw,
        output [7:0] o_sseg_n,
        output [3:0] o_ldsel
    );

    logic [15:0] w_led_val;
    logic [7:0] w_led_map [3:0];

    assign w_led_val = {8'h00, i_sw};

    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(w_led_val[3:0]), .o_sseg_n(w_led_map[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(w_led_val[7:4]), .o_sseg_n(w_led_map[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(w_led_val[11:8]), .o_sseg_n(w_led_map[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(w_led_val[15:12]), .o_sseg_n(w_led_map[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(i_clk), .i_reset(i_reset), .i_in_n(w_led_map), .o_ldsel(o_ldsel), .o_sseg_n(o_sseg_n));

endmodule
