module div
    #(parameter WIDTH = 8)
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [WIDTH-1:0] i_dividend, i_divisor,
        output  logic o_ready, o_done,
        output  logic [WIDTH-1:0] o_quotient, o_remain
    );

    typedef enum {e_idle, e_operate, e_last, e_done} t_div_state;

    t_div_state r_div_state, w_div_state_next; // FSM state
    logic [WIDTH-1:0] r_dividend_lo, w_dividend_lo_next; // Lower bits of extended dividend
    logic [WIDTH-1:0] r_dividend_hi, w_dividend_hi_next; // Higher bits of extended dividend (init filled with 0)
    logic [WIDTH-1:0] r_divisor, w_divisor_next;
    logic [$clog2(WIDTH + 1):0] r_index, w_index_next;

    // Handle compare/subtract
    logic [WIDTH-1:0] w_dividend_divisor_rem; // divisor subtracted from dividend
    logic w_dividend_divisor_cmp; // 1 if divisor subtracted, 0 else
    assign w_dividend_divisor_rem = (r_dividend_hi >= r_divisor) ? (r_dividend_hi - r_divisor) :
                                    (r_dividend_hi);
    assign w_dividend_divisor_cmp = (r_dividend_hi >= r_divisor) ? 1'b1 : 1'b0;

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_div_state <= e_idle;
            r_dividend_lo <= 0;
            r_dividend_hi <= 0;
            r_divisor <= 0;
            r_index <= 0;
        end
        else
        begin
            r_div_state <= w_div_state_next;
            r_dividend_lo <= w_dividend_lo_next;
            r_dividend_hi <= w_dividend_hi_next;
            r_divisor <= w_divisor_next;
            r_index <= w_index_next;
        end
    end


    always_comb
    begin
        // defaults
        w_div_state_next = r_div_state;
        w_dividend_lo_next = r_dividend_lo;
        w_dividend_hi_next = r_dividend_hi;
        w_divisor_next = r_divisor;
        w_index_next = r_index;

        o_ready = 1'b0;
        o_done = 1'b0;

        case (r_div_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    // initialize for division
                    w_dividend_lo_next = i_dividend;
                    w_dividend_hi_next = 4'h0;
                    w_divisor_next = i_divisor;
                    w_index_next = WIDTH + 1;
                    w_div_state_next = e_operate;
                end
            end
            e_operate:
            begin
                w_dividend_lo_next = {r_dividend_lo[WIDTH-2:0], w_dividend_divisor_cmp};
                w_dividend_hi_next = {w_dividend_divisor_rem[WIDTH-2:0], r_dividend_lo[WIDTH-1]};

                w_index_next = r_index - 1;
                if (w_index_next == 1)
                    w_div_state_next = e_last;
            end
            e_last:
            begin
                w_dividend_lo_next = {r_dividend_lo[WIDTH-2:0], w_dividend_divisor_cmp};
                w_dividend_hi_next = w_dividend_divisor_rem;
                w_div_state_next = e_done;
            end
            e_done:
            begin
                o_done = 1'b1;
                w_div_state_next = e_idle;
            end
        endcase
    end



    // Handle output
    assign o_quotient = r_dividend_lo;
    assign o_remain = r_dividend_hi;
endmodule