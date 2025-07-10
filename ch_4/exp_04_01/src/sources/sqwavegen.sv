

module square_wave_gen
    (
        input   logic i_clk, i_rst,
        input   logic [3:0] i_m, i_n,
        output  logic o_q
    );

    localparam MAX_HNS_TICK = 150; // Max possible clock ticks for i_m, i_n, in 10s of ns

    // localparam DVSR = 10;
    // logic [$clog2(DVSR)-1:0] r_hns_count;
    // logic w_hns_tick;
    // always_ff @(posedge i_clk)
    // begin
    //     r_hns_count <= r_hns_count + 1;
    // end
    // assign w_hns_tick = r_hns_count[$clog(DVSR)-1];

    logic r_state; // 0->low, 1->high
    logic [$clog2(MAX_HNS_TICK)-1:0] r_m_count, r_n_count;
    logic w_state_next;
    logic [$clog2(MAX_HNS_TICK)-1:0] w_m_count_next, w_n_count_next;
    always_ff @(posedge i_clk)
    begin
        if (i_rst)
        begin
            r_state <= 1'b0;
            r_m_count <= 4'h0;
            r_n_count <= 4'h0;
        end
        else
        begin
            r_state <= w_state_next;
            r_m_count <= w_m_count_next;
            r_n_count <= w_n_count_next;
        end
    end

    always_comb
    begin
        w_m_count_next = r_m_count + 1;
        w_n_count_next = r_n_count + 1;
        w_state_next = r_state;
        if (r_state && (r_m_count >= (i_m * 10 - 1)))
        begin
            w_n_count_next = 4'h0;
            w_state_next = ~r_state;
        end
        if (!r_state && (r_n_count >= (i_n * 10 - 1)))
        begin
            w_m_count_next = 4'h0;
            w_state_next = ~r_state;
        end
    end

    assign o_q = r_state;

endmodule
