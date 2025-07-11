
module stopwatch_cascade
    #(parameter DVSR = 10_000_000)
    (
        input   logic i_clk,
        input   logic i_go, i_clr, i_up,
        output  logic [3:0] o_s3, o_s2, o_s1, o_s0
    );

    logic [24:0] r_ms;
    logic [24:0] w_ms_next;
    logic [3:0] r_s3, r_s2, r_s1, r_s0;
    logic [3:0] w_s3_next, w_s2_next, w_s1_next, w_s0_next;
    logic w_s3_en, w_s2_en, w_s1_en, w_s0_en;
    logic w_ms_tick, w_s1_tick, w_s0_tick, w_s2_tick;

    always_ff @(posedge i_clk)
    begin
        r_ms <= w_ms_next;
        r_s3 <= w_s3_next;
        r_s2 <= w_s2_next;
        r_s1 <= w_s1_next;
        r_s0 <= w_s0_next;
    end

    assign w_ms_next = (i_clr || (r_ms == DVSR && i_go)) ? 24'b0 :
                       (i_go) ? r_ms + 1 :
                       r_ms;
    assign w_ms_tick = (r_ms == DVSR) ? 1'b1 : 1'b0;

    assign w_s0_en = w_ms_tick;
    assign w_s0_next = (i_clr || (w_s0_en && r_s0 == 9 && i_up)) ? 4'b0 :
                       (w_s0_en && r_s0 == 4'h0 && ~i_up) ? 4'h9 :
                       (w_s0_en && i_up) ? r_s0 + 1 :
                       (w_s0_en) ? r_s0 - 1 :
                       r_s0;
    assign w_s0_tick = (r_s0 == 4'h9 && i_up) ? 1'b1 :
                       (r_s0 == 4'h0 && ~i_up) ? 1'b1 :
                       1'b0;

    assign w_s1_en = w_ms_tick & w_s0_tick;
    assign w_s1_next = (i_clr || (w_s1_en && r_s1 == 9 && i_up)) ? 4'b0 :
                       (w_s1_en && r_s1 == 4'h0 && ~i_up) ? 4'h9 :
                       (w_s1_en && i_up) ? r_s1 + 1 :
                       (w_s1_en) ? r_s1 - 1 :
                       r_s1;
    assign w_s1_tick = (r_s1 == 4'h9 && i_up) ? 1'b1 :
                       (r_s1 == 4'h0 && ~i_up) ? 1'b1 :
                       1'b0;

    assign w_s2_en = w_ms_tick & w_s0_tick & w_s1_tick;
    assign w_s2_next = (i_clr || (w_s2_en && r_s2 == 5 && i_up)) ? 4'b0 :
                       (w_s2_en && r_s2 == 4'h0 && ~i_up) ? 4'h5 :
                       (w_s2_en && i_up) ? r_s2 + 1 :
                       (w_s2_en) ? r_s2 - 1 :
                       r_s2;
    assign w_s2_tick = (r_s2 == 4'h5 && i_up) ? 1'b1 :
                       (r_s2 == 4'h0 && ~i_up) ? 1'b1 :
                       1'b0;

    assign w_s3_en = w_ms_tick & w_s0_tick & w_s1_tick & w_s2_tick;
    assign w_s3_next = (i_clr || (w_s3_en && r_s3 == 9 && i_up)) ? 4'b0 :
                       (w_s3_en && r_s3 == 4'h0 && ~i_up) ? 4'h9 :
                       (w_s3_en && i_up) ? r_s3 + 1 :
                       (w_s3_en) ? r_s3 - 1 :
                       r_s3;


    // assign w_s0_en = w_ms_tick;
    // assign w_s0_next = (i_clr || (w_s0_en && r_s0 == 4'h0)) ? 4'h9 :
    //                    (w_s0_en) ? r_s0 - 1 :
    //                    r_s0;
    // assign w_s0_tick = (r_s0 == 0) ? 1'b1 : 1'b0;

    // assign w_s1_en = w_ms_tick & w_s0_tick;
    // assign w_s1_next = (i_clr || (w_s1_en && r_s1 == 4'h0)) ? 4'h9 :
    //                    (w_s1_en) ? r_s1 - 1 :
    //                    r_s1;
    // assign w_s1_tick = (r_s1 == 0) ? 1'b1 : 1'b0;

    // assign w_s2_en = w_ms_tick & w_s0_tick & w_s1_tick;
    // assign w_s2_next = (i_clr || (w_s2_en && r_s2 == 4'h0)) ? 4'h5 :
    //                    (w_s2_en) ? r_s2 - 1 :
    //                    r_s2;
    // assign w_s2_tick = (r_s2 == 0) ? 1'b1 : 1'b0;

    // assign w_s3_en = w_ms_tick & w_s0_tick & w_s1_tick & w_s2_tick;
    // assign w_s3_next = (i_clr || (w_s3_en && r_s3 == 4'h0)) ? 4'h9 :
    //                    (w_s3_en) ? r_s3 - 1 :
    //                    r_s3;

    assign o_s0 = r_s0;
    assign o_s1 = r_s1;
    assign o_s2 = r_s2;
    assign o_s3 = r_s3;

endmodule
