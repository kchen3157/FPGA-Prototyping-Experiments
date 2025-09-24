module bcdtobin
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [3:0] i_bcd [1:0],
        output  logic o_ready, o_done,
        output  logic [11:0] o_bin
    );

    typedef enum {e_idle, e_operation, e_done} t_state;

    t_state r_state, w_state_next;
    logic [11:0] r_bin, w_bin_next, w_bin_adj;
    logic [3:0] r_bcd0, w_bcd0_next, w_bcd0_adj;
    logic [3:0] r_bcd1, w_bcd1_next, w_bcd1_adj;
    logic [3:0] r_bcd2, w_bcd2_next, w_bcd2_adj;
    logic [3:0] r_bcd3, w_bcd3_next, w_bcd3_adj;
    logic [3:0] r_index, w_index_next;

    always_comb
    begin : shifter
        w_bcd3_adj = {1'b0,         r_bcd3[3:1]};
        w_bcd2_adj = {r_bcd3[0],    r_bcd2[3:1]};
        w_bcd1_adj = {r_bcd2[0],    r_bcd1[3:1]};
        w_bcd0_adj = {r_bcd1[0],    r_bcd0[3:1]};
    end

    always_ff @(posedge i_clk, posedge i_rst)
    begin : register_inst
        if (i_rst)
        begin
            r_state <= e_idle;
            r_bin <= 0;
            r_bcd0 <= 0;
            r_bcd1 <= 0;
            r_bcd2 <= 0;
            r_bcd3 <= 0;
            r_index <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_bin <= w_bin_next;
            r_bcd0 <= w_bcd0_next;
            r_bcd1 <= w_bcd1_next;
            r_bcd2 <= w_bcd2_next;
            r_bcd3 <= w_bcd3_next;
            r_index <= w_index_next;
        end
    end

    always_comb
    begin : next_state_logic
        // defaults
        w_state_next = r_state;
        w_bin_next = r_bin;
        w_bcd0_next = r_bcd0;
        w_bcd1_next = r_bcd1;
        w_bcd2_next = r_bcd2;
        w_bcd3_next = r_bcd3;
        w_index_next = r_index;

        o_ready = 1'b0;
        o_done = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_bin_next = 12'h000;
                    w_bcd0_next = i_bcd[0];
                    w_bcd1_next = i_bcd[1];
                    w_bcd2_next = i_bcd[2];
                    w_bcd3_next = i_bcd[3];
                    w_index_next = 4'hD;
                    w_state_next = e_operation;
                end
            end
            e_operation:
            begin
                if (r_index == 1)
                    w_state_next = e_done;
                else
                begin
                    w_bcd3_next = (w_bcd3_adj > 7) ? (w_bcd3_adj - 3) : w_bcd3_adj;
                    w_bcd2_next = (w_bcd2_adj > 7) ? (w_bcd2_adj - 3) : w_bcd2_adj;
                    w_bcd1_next = (w_bcd1_adj > 7) ? (w_bcd1_adj - 3) : w_bcd1_adj;
                    w_bcd0_next = (w_bcd0_adj > 7) ? (w_bcd0_adj - 3) : w_bcd0_adj;
                    w_bin_next = {r_bcd0[0], r_bin[11:1]};
                    w_index_next = r_index - 1;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_idle;
            end
        endcase
    end

    assign o_bin = r_bin;

endmodule