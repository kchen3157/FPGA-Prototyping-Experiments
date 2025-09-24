module bintobcd
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [12:0] i_bin,
        output  logic o_ready, o_done,
        output  logic [3:0] o_bcd3, o_bcd2, o_bcd1, o_bcd0
    );

    typedef enum logic [1:0] {e_ready, e_operation, e_done} t_state;

    t_state r_state, w_state_next;
    logic [12:0] r_bin, w_bin_next;
    logic [3:0] r_bcd0, w_bcd0_next, w_bcd0_adj;
    logic [3:0] r_bcd1, w_bcd1_next, w_bcd1_adj;
    logic [3:0] r_bcd2, w_bcd2_next, w_bcd2_adj;
    logic [3:0] r_bcd3, w_bcd3_next, w_bcd3_adj;
    logic [3:0] r_index, w_index_next;

    always_comb begin : bcd_add4
        w_bcd0_adj = (r_bcd0 > 4'h4) ? (r_bcd0 + 4'h3) : (r_bcd0);
        w_bcd1_adj = (r_bcd1 > 4'h4) ? (r_bcd1 + 4'h3) : (r_bcd1);
        w_bcd2_adj = (r_bcd2 > 4'h4) ? (r_bcd2 + 4'h3) : (r_bcd2);
        w_bcd3_adj = (r_bcd3 > 4'h4) ? (r_bcd3 + 4'h3) : (r_bcd3);
    end

    always_ff @( posedge i_clk, posedge i_rst ) begin : register_inst
        if (i_rst)
        begin
            r_state <= e_ready;
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

    always_comb begin : next_state_logic
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
            e_ready:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_bin_next = i_bin;
                    w_bcd0_next = 4'h0;
                    w_bcd1_next = 4'h0;
                    w_bcd2_next = 4'h0;
                    w_bcd3_next = 4'h0;
                    w_index_next = 4'hD;
                    w_state_next = e_operation;
                end
            end
            e_operation:
            begin
                if (r_index == 0)
                    w_state_next = e_done;
                else
                begin
                    w_bcd3_next = {w_bcd3_adj[2:0], w_bcd2_adj[3]};
                    w_bcd2_next = {w_bcd2_adj[2:0], w_bcd1_adj[3]};
                    w_bcd1_next = {w_bcd1_adj[2:0], w_bcd0_adj[3]};
                    w_bcd0_next = {w_bcd0_adj[2:0], r_bin[12]};
                    w_bin_next = (r_bin << 1);
                    w_index_next = r_index - 1;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_ready;
            end
        endcase
    end

    assign o_bcd0 = r_bcd0;
    assign o_bcd1 = r_bcd1;
    assign o_bcd2 = r_bcd2;
    assign o_bcd3 = r_bcd3;

endmodule