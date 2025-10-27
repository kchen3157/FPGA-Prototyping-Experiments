// This 


module low_freq_counter
    (
        input   logic i_clk, i_rst,
        input   logic i_start, i_signal,
        output  logic [3:0] o_freq_bcd [3:0]
    );

    logic w_per_counter_start, w_per_counter_done;
    logic [9:0] w_period;
    period_counter_us u_period_counter_us
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_per_counter_start),
        .i_signal(i_signal),

        .o_ready(), .o_done(w_per_counter_done),
        .o_overflow(), .o_underflow(),
        .o_period(w_period)
    );

    logic w_div_start, w_div_done;
    logic [19:0] w_freq_bin;
    div #(.WIDTH(20)) u_div
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_div_start),
        .i_dividend(20'd1000000), .i_divisor({w_period}),
        .o_ready(), .o_done(w_div_done),
        .o_quotient(w_freq_bin), .o_remain()
    );

    logic w_bintobcd_start, w_bintobcd_done;
    bintobcd u_bintobcd
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_bintobcd_start),
        .i_bin(w_freq_bin[12:0]),
        .o_ready(), .o_done(w_bintobcd_done),
        .o_bcd3(o_freq_bcd[3]), .o_bcd2(o_freq_bcd[2]), .o_bcd1(o_freq_bcd[1]), .o_bcd0(o_freq_bcd[0])
    );


    typedef enum logic [1:0] { e_idle, e_count_per, e_divide, e_bcd_convert } t_state;
    t_state r_state, w_state_next;

    // Instantiate registers
    always_ff @( posedge i_clk, posedge i_rst )
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
        end
        else
        begin
            r_state <= w_state_next;
        end
    end

    always_comb
    begin
        //defaults
        w_state_next = r_state;
        w_per_counter_start = 1'b0;
        w_div_start = 1'b0;
        w_bintobcd_start = 1'b0;

        case (r_state)
            e_idle:
            begin
                if (i_start)
                begin
                    w_per_counter_start = 1'b1;
                    w_state_next = e_count_per;
                end
            end
            e_count_per:
            begin
                if (w_per_counter_done)
                begin
                    w_div_start = 1'b1;
                    w_state_next = e_divide;
                end
            end
            e_divide:
            begin
                if (w_div_done)
                begin
                    w_bintobcd_start = 1'b1;
                    w_state_next = e_bcd_convert;
                end
            end
            e_bcd_convert:
            begin
                if (w_bintobcd_done)
                begin
                    w_state_next = e_idle;
                end
            end
            default: w_state_next = e_idle;
        endcase
    end


endmodule