
module stopwatch_cascade
    #(parameter DVSR = 10_000_000)
    (
        input   logic i_clk,
        input   logic i_go, i_clr,
        output  logic [3:0] o_s2, o_s1, o_s0
    );

    logic [22:0] r_ms_reg;
    logic [22:0] r_ms_next;
    logic [3:0] r_s2_reg, r_s1_reg, r_s0_reg;
    logic [3:0] r_s2_next, r_s1_next, r_s0_next;
    logic w_s2_en, w_s1_en, w_s0_en;
    logic r_ms_tick, r_s1_tick, r_s0_tick;

    always_ff @(posedge i_clk)
    begin
        r_ms_reg <= r_ms_next;
        r_s2_reg <= r_s2_next;
        r_s1_reg <= r_s1_next;
        r_s0_reg <= r_s0_next;
    end

    assign r_ms_next = (i_clr || (r_ms_reg == DVSR && i_go)) ? 23'b0 :
                       (i_go) ? r_ms_reg + 1 :
                       r_ms_reg;
    assign r_ms_tick = (r_ms_reg == DVSR) ? 1'b1 : 1'b0;

    assign w_s0_en = r_ms_tick;
    assign r_s0_next = (i_clr || (w_s0_en && r_s0_reg == 9)) ? 4'b0 :
                       (w_s0_en) ? r_s0_reg + 1 :
                       r_s0_reg;
    assign r_s0_tick = (r_s0_reg == 9) ? 1'b1 : 1'b0;

    assign w_s1_en = r_ms_tick & r_s0_tick;
    assign r_s1_next = (i_clr || (w_s1_en && r_s1_reg == 9)) ? 4'b0 :
                       (w_s1_en) ? r_s1_reg + 1 :
                       r_s1_reg;
    assign r_s1_tick = (r_s1_reg == 9) ? 1'b1 : 1'b0;

    assign w_s2_en = r_ms_tick & r_s0_tick & r_s1_tick;
    assign r_s2_next = (i_clr || (w_s2_en && r_s2_reg == 9)) ? 4'b0 :
                       (w_s2_en) ? r_s2_reg + 1 :
                       r_s2_reg;

    assign o_s0 = r_s0_reg;
    assign o_s1 = r_s1_reg;
    assign o_s2 = r_s2_reg;

endmodule


