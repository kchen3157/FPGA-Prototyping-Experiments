module top
    (
        input logic clk,
        input logic [7:0] sw,
        output logic [7:0] ja
    );

    // LED TO JMOD A WIRING
    // BLUE   JA[0] -> DP
    // PURPLE JA[1] -> C
    // GREY   JA[2] -> D
    // WHITE  JA[3] -> E
    // BROWN  JA[4] -> B
    // RED    JA[5] -> A
    // ORANGE JA[6] -> F
    // YELLOW JA[7] -> G


    logic [7:0] inc, ja_led;
    logic [7:0] led_raw_0, led_raw_1, led_inc_0, led_inc_1;

    assign inc = sw + 1;
    assign ja[0] = ja_led[7];
    assign ja[1] = ja_led[2];
    assign ja[2] = ja_led[3];
    assign ja[3] = ja_led[4];
    assign ja[4] = ja_led[1];
    assign ja[5] = ja_led[0];
    assign ja[6] = ja_led[5];
    assign ja[7] = ja_led[6];

    hex_to_sseg sseg_raw_0
        (.hex(sw[3:0]), .dp(1'b0), .sseg(led_raw_0));
    hex_to_sseg sseg_raw_1
        (.hex(sw[7:4]), .dp(1'b0), .sseg(led_raw_1));

    hex_to_sseg sseg_inc_0
        (.hex(inc[3:0]), .dp(1'b0), .sseg(led_inc_0));
    hex_to_sseg sseg_inc_1
        (.hex(inc[7:4]), .dp(1'b0), .sseg(led_inc_1));


    disp_mux disp_unix
        (.clk(clk), .reset(1'b0), .in0(led_raw_0), .in1(led_raw_1), .in2(led_inc_0), .in3(led_inc_1), .an(), .sseg(ja_led));
        
        


endmodule
