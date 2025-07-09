
module stopwatch_cascade
    #(parameter DVSR = 10_000_000)
    (
        input   logic i_clk,
        input   logic i_go, i_clr,
        output  logic [3:0] o_s2, o_s1, o_s0
    );

    logic [24:0] r_ms;
    logic [24:0] w_ms_next;
    logic [3:0] r_s2, r_s1, r_s0;
    logic [3:0] w_s2_next, w_s1_next, w_s0_next;
    logic w_s2_en, w_s1_en, w_s0_en;
    logic w_ms_tick, w_s1_tick, w_s0_tick;

    always_ff @(posedge i_clk)
    begin
        r_ms <= w_ms_next;
        r_s2 <= w_s2_next;
        r_s1 <= w_s1_next;
        r_s0 <= w_s0_next;
    end

    assign w_ms_next = (i_clr || (r_ms == DVSR && i_go)) ? 24'b0 :
                       (i_go) ? r_ms + 1 :
                       r_ms;
    assign w_ms_tick = (r_ms == DVSR) ? 1'b1 : 1'b0;

    assign w_s0_en = w_ms_tick;
    assign w_s0_next = (i_clr || (w_s0_en && r_s0 == 9)) ? 4'b0 :
                       (w_s0_en) ? r_s0 + 1 :
                       r_s0;
    assign w_s0_tick = (r_s0 == 9) ? 1'b1 : 1'b0;

    assign w_s1_en = w_ms_tick & w_s0_tick;
    assign w_s1_next = (i_clr || (w_s1_en && r_s1 == 9)) ? 4'b0 :
                       (w_s1_en) ? r_s1 + 1 :
                       r_s1;
    assign w_s1_tick = (r_s1 == 9) ? 1'b1 : 1'b0;

    assign w_s2_en = w_ms_tick & w_s0_tick & w_s1_tick;
    assign w_s2_next = (i_clr || (w_s2_en && r_s2 == 9)) ? 4'b0 :
                       (w_s2_en) ? r_s2 + 1 :
                       r_s2;

    assign o_s0 = r_s0;
    assign o_s1 = r_s1;
    assign o_s2 = r_s2;

endmodule

module stopwatch_if
    #(parameter DVSR = 10_000_000)
    (
        input   logic i_clk,
        input   logic i_go, i_clr,
        output  logic [3:0] o_s2, o_s1, o_s0
    );

    logic [24:0] r_ms;
    logic [24:0] w_ms_next;
    logic [3:0] r_s2, r_s1, r_s0;
    logic [3:0] w_s2_next, w_s1_next, w_s0_next;
    logic w_ms_tick;

    // Setup registers
    always_ff @(posedge i_clk)
    begin
        r_ms <= w_ms_next;
        r_s2 <= w_s2_next;
        r_s1 <= w_s1_next;
        r_s0 <= w_s0_next;
    end

    // Generate ms tick once every DVSR cycles
    assign w_ms_next = (i_clr || (r_ms == DVSR && i_go)) ? 24'b0 :
                       (i_go) ? r_ms + 1 :
                       r_ms;
    assign w_ms_tick = (r_ms == DVSR) ? 1'b1 : 1'b0;

    // Main 3-digit counter
    always_comb
    begin
        // Default
        w_s0_next = r_s0;
        w_s1_next = r_s1;
        w_s2_next = r_s2;

        if (i_clr)
        begin
            w_s0_next = 4'h0;
            w_s1_next = 4'h0;
            w_s2_next = 4'h0;
        end
        else if (w_ms_tick)
        begin
            if (r_s0 != 4'h9)
            begin
                w_s0_next = r_s0 + 1;
            end
            else
            begin
                w_s0_next = 4'h0;

                if (r_s1 != 4'h9)
                begin
                    w_s1_next = r_s1 + 1;
                end
                else
                begin
                    w_s1_next = 4'h0;

                    if (r_s2 != 4'h9)
                    begin
                        w_s2_next = r_s2 + 1;
                    end
                    else
                    begin
                        w_s2_next = 4'h0;
                    end
                end
            end
        end
    end

    assign o_s0 = r_s0;
    assign o_s1 = r_s1;
    assign o_s2 = r_s2;


endmodule
