module led_switch
    (
        input   logic i_clk, i_reset,
        input   logic [7:0] i_sw,
        output  logic [7:0] o_sseg_n,
        output  logic [3:0] o_ldsel
    );

    logic [15:0] w_led_val;
    logic [7:0] w_led_map [3:0];

    assign w_led_val = {({4'b0, i_sw[3:0]} + {4'b0, i_sw[7:4]}), i_sw};

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


module led_switch_set
    (
        input   logic i_clk, i_reset,
        input   logic [3:0] i_set,
        input   logic [3:0] i_sw,
        output  logic [7:0] o_sseg_n,
        output  logic [3:0] o_ldsel
    );

    logic [7:0] w_led_map [3:0];

    logic [3:0] r_hex1, r_hex2, r_hex3, r_hex4;
    
    always_ff @(posedge i_clk)
    begin
        if (i_set[3])
            r_hex4 <= i_sw;
        if (i_set[2])
            r_hex3 <= i_sw;
        if (i_set[1])
            r_hex2 <= i_sw;
        if (i_set[0])
            r_hex1 <= i_sw;
    end

    hex_to_sseg u_hex_to_sseg_LD1
        (.i_hex(r_hex1), .o_sseg_n(w_led_map[0]));

    hex_to_sseg u_hex_to_sseg_LD2
        (.i_hex(r_hex2), .o_sseg_n(w_led_map[1]));

    hex_to_sseg u_hex_to_sseg_LD3
        (.i_hex(r_hex3), .o_sseg_n(w_led_map[2]));

    hex_to_sseg u_hex_to_sseg_LD4
        (.i_hex(r_hex4), .o_sseg_n(w_led_map[3]));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(i_clk), .i_reset(i_reset), .i_in_n(w_led_map), .o_ldsel(o_ldsel), .o_sseg_n(o_sseg_n));

endmodule
