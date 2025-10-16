


module fibgen
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [3:0] i_gen_amt_bcd1, i_gen_amt_bcd0,
        
        output  logic [3:0] o_final_bcd3, o_final_bcd2, o_final_bcd1, o_final_bcd0,
        output  logic o_ready, o_done, o_overflow

    );

    typedef enum { e_idle, e_conv_in, e_calculate, e_conv_out, e_done, e_overflow } t_state;

    t_state r_state, w_state_next;
    logic [7:0] r_index, w_index_next;

    logic [3:0] r_gen_amt_bcd [1:0];
    logic [3:0] w_gen_amt_bcd_next [1:0];
    logic [3:0] w_gen_amt_bcd_adj [1:0];
    logic [7:0] r_gen_amt_bin, w_gen_amt_bin_next;

    logic [13:0] r_final_bin, w_final_bin_next;
    logic [3:0] r_final_bcd [3:0];
    logic [3:0] w_final_bcd_next [3:0];
    logic [3:0] w_final_bcd_adj [3:0];

    // Calculation specific registers
    logic [13:0] r_final_prev, w_final_prev_next;

    always_comb
    begin : input_bcd_logic
        w_gen_amt_bcd_adj[1] = {1'b0,                   r_gen_amt_bcd[1][3:1]};
        w_gen_amt_bcd_adj[0] = {r_gen_amt_bcd[1][0],    r_gen_amt_bcd[0][3:1]};
    end

    always_comb
    begin : output_bcd_logic
        w_final_bcd_adj[3] = (r_final_bcd[3] > 4'h4) ? (r_final_bcd[3] + 4'h3) : (r_final_bcd[3]);
        w_final_bcd_adj[2] = (r_final_bcd[2] > 4'h4) ? (r_final_bcd[2] + 4'h3) : (r_final_bcd[2]);
        w_final_bcd_adj[1] = (r_final_bcd[1] > 4'h4) ? (r_final_bcd[1] + 4'h3) : (r_final_bcd[1]);
        w_final_bcd_adj[0] = (r_final_bcd[0] > 4'h4) ? (r_final_bcd[0] + 4'h3) : (r_final_bcd[0]);
    end

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_index <= 0;
            
            r_gen_amt_bcd <= {0, 0};
            r_gen_amt_bin <= 0;

            r_final_bin <= 0;
            r_final_bcd <= {0, 0, 0, 0};

            r_final_prev <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_index <= w_index_next;

            r_gen_amt_bcd <= w_gen_amt_bcd_next;
            r_gen_amt_bin <= w_gen_amt_bin_next;

            r_final_bin <= w_final_bin_next;
            r_final_bcd <= w_final_bcd_next;

            r_final_prev <= w_final_prev_next;
        end
    end

    always_comb
    begin
        // defaults
        w_state_next = r_state;
        w_index_next = r_index;
        
        w_gen_amt_bcd_next = r_gen_amt_bcd;
        w_gen_amt_bin_next = r_gen_amt_bin;

        w_final_bin_next = r_final_bin;
        w_final_bcd_next = r_final_bcd;

        w_final_prev_next = r_final_prev;
        
        o_ready = 1'b0;
        o_done = 1'b0;
        o_overflow = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_gen_amt_bcd_next = {i_gen_amt_bcd1, i_gen_amt_bcd0};
                    w_gen_amt_bin_next = 8'h00;
                    w_index_next = 8'h08;
                    w_state_next = e_conv_in;
                end
            end
            e_conv_in:
            begin
                if (r_index != 8'h00)
                begin
                    w_gen_amt_bcd_next[1] = (w_gen_amt_bcd_adj[1] > 7) ? (w_gen_amt_bcd_adj[1] - 3) :
                                            (w_gen_amt_bcd_adj[1]);
                    w_gen_amt_bcd_next[0] = (w_gen_amt_bcd_adj[0] > 7) ? (w_gen_amt_bcd_adj[0] - 3) :
                                            (w_gen_amt_bcd_adj[0]);
                    w_gen_amt_bin_next = {r_gen_amt_bcd[0][0], r_gen_amt_bin[7:1]};
                    w_index_next = r_index - 1;
                end
                else if (r_gen_amt_bin > 20)
                begin
                    w_final_bcd_next = {4'h9, 4'h9, 4'h9, 4'h9};
                    w_state_next = e_overflow;
                end
                else
                begin
                    w_final_prev_next = 0;
                    w_final_bin_next = 1;
                    w_index_next = r_gen_amt_bin;
                    w_state_next = e_calculate;
                end
            end
            e_calculate:
            begin
                if (r_index == 8'h00)
                begin
                    w_final_bin_next = 0;
                    w_final_bcd_next = {0, 0, 0, 0};
                    w_index_next = 8'h0E;
                    w_state_next = e_conv_out;
                end
                else if (r_index == 8'h01)
                begin
                    w_final_bcd_next = {0, 0, 0, 0};
                    w_index_next = 8'h0E;
                    w_state_next = e_conv_out;
                end
                else
                begin
                    w_final_bin_next = r_final_bin + r_final_prev;
                    w_final_prev_next = r_final_bin;
                    w_index_next = r_index - 1;
                end
            end
            e_conv_out:
            begin
                if (r_index == 0)
                begin
                    w_state_next = e_done;
                end
                else
                begin
                    w_final_bcd_next[3] = {w_final_bcd_adj[3][2:0], w_final_bcd_adj[2][3]};
                    w_final_bcd_next[2] = {w_final_bcd_adj[2][2:0], w_final_bcd_adj[1][3]};
                    w_final_bcd_next[1] = {w_final_bcd_adj[1][2:0], w_final_bcd_adj[0][3]};
                    w_final_bcd_next[0] = {w_final_bcd_adj[0][2:0], r_final_bin[13]};
                    w_final_bin_next = {r_final_bin << 1};
                    w_index_next = r_index - 1;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_idle;
            end
            e_overflow:
            begin
                o_done = 1'b1;
                o_overflow = 1'b1;
                w_state_next = e_idle;
            end
            default: w_state_next = e_idle;
        endcase
    end

    assign o_final_bcd3 = r_final_bcd[3];
    assign o_final_bcd2 = r_final_bcd[2];
    assign o_final_bcd1 = r_final_bcd[1];
    assign o_final_bcd0 = r_final_bcd[0];

endmodule