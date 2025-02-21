module top
    (
        input logic [7:0] sw,
        output logic [7:0] ja,
        output logic [7:0] jb
    );

    // LED TO JMOD A WIRING (SAME FOR JMOD B)
    // BLUE   JA[0] -> DP
    // PURPLE JA[1] -> C
    // GREY   JA[2] -> D
    // WHITE  JA[3] -> E
    // BROWN  JA[4] -> B
    // RED    JA[5] -> A
    // ORANGE JA[6] -> F
    // YELLOW JA[7] -> G

    logic [7:0] ja_led, jb_led;

    assign ja[0] = ja_led[7];
    assign ja[1] = ja_led[2];
    assign ja[2] = ja_led[3];
    assign ja[3] = ja_led[4];
    assign ja[4] = ja_led[1];
    assign ja[5] = ja_led[0];
    assign ja[6] = ja_led[5];
    assign ja[7] = ja_led[6];
    assign jb[0] = jb_led[7];
    assign jb[1] = jb_led[2];
    assign jb[2] = jb_led[3];
    assign jb[3] = jb_led[4];
    assign jb[4] = jb_led[1];
    assign jb[5] = jb_led[0];
    assign jb[6] = jb_led[5];
    assign jb[7] = jb_led[6];

    hex_to_sseg sseg_raw_0
        (.hex(sw[3:0]), .dp(1'b0), .sseg(ja_led));
    hex_to_sseg sseg_raw_1
        (.hex(sw[7:4]), .dp(1'b0), .sseg(jb_led));   


endmodule
