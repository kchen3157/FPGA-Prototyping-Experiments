// This 


module low_freq_counter_bcd
    (
        input   logic i_clk, i_rst,
        input   logic i_start, i_signal,

        output  logic [3:0] o_freq_bcd3,
        output  logic [3:0] o_freq_bcd2,
        output  logic [3:0] o_freq_bcd1,
        output  logic [3:0] o_freq_bcd0,
        output  logic [3:0] o_freq_dp,
        
        output  logic o_overflow, o_underflow,
        output  logic o_ready, o_done
    );

    localparam CLK_FREQ = 100_000_000; // Base clock frequency
    localparam POLL_FREQ = 1_000_000; // Polling frequency (1E6 polled every microsecond)
    localparam DIV_WIDTH = 32; // Width of division circuit

    logic w_per_counter_start, w_per_counter_done;
    logic w_per_counter_overflow, w_per_counter_underflow;
    logic [$clog2(POLL_FREQ)-1:0] w_period;
    period_counter_us 
    #(
        .CLK_FREQ(CLK_FREQ), .POLL_FREQ(POLL_FREQ)
    ) u_period_counter_us
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_per_counter_start),

        .i_signal(i_signal),

        .o_ready(), .o_done(w_per_counter_done),
        // TODO: When these are high, don't care the rest and set output to 0/9999
        //! Period UNDERFLOW here means frequency OVERFLOW
        //! Period OVERFLOW here means frequency UNDERFLOW
        .o_overflow(w_per_counter_overflow), .o_underflow(w_per_counter_underflow),
        .o_period(w_period)
    );

    logic w_div_start;
    logic w_div_done;
    logic [DIV_WIDTH-1:0] w_freq_bin;
    div #(.WIDTH(DIV_WIDTH)) u_div
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_div_start),

        .i_dividend(32'd1_000_000_000),
        .i_divisor({{(32 - $clog2(POLL_FREQ)){1'b0}}, w_period}),

        .o_ready(), .o_done(w_div_done),
        .o_quotient(w_freq_bin), .o_remain()
    );

    logic w_bintobcd_start;
    logic w_bintobcd_done;
    logic w_bintobcd_overflow;
    logic [3:0] w_bintobcd_freq_bcd3, w_bintobcd_freq_bcd2, w_bintobcd_freq_bcd1, w_bintobcd_freq_bcd0;
    logic [3:0] w_bintobcd_freq_dp;
    bintobcd u_bintobcd
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_bintobcd_start),
        .i_bin(w_freq_bin),

        .o_ready(), .o_done(w_bintobcd_done), .o_overflow(w_bintobcd_overflow),
        .o_bcd3(w_bintobcd_freq_bcd3), .o_bcd2(w_bintobcd_freq_bcd2),
        .o_bcd1(w_bintobcd_freq_bcd1), .o_bcd0(w_bintobcd_freq_bcd0),
        .o_dp(w_bintobcd_freq_dp)
    );

    typedef enum logic [2:0] { e_idle, e_count_per, e_divide, e_bcdconv, e_overflow, e_underflow, e_done} t_state;
    t_state r_state, w_state_next;

    // Output buffer registers
    logic [3:0] r_freq_bcd3, w_freq_bcd3_next;
    logic [3:0] r_freq_bcd2, w_freq_bcd2_next;
    logic [3:0] r_freq_bcd1, w_freq_bcd1_next;
    logic [3:0] r_freq_bcd0, w_freq_bcd0_next;
    logic [3:0] r_freq_dp, w_freq_dp_next;

    // Instantiate registers
    always_ff @( posedge i_clk, posedge i_rst )
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_freq_bcd3 <= 4'h0;
            r_freq_bcd2 <= 4'h0;
            r_freq_bcd1 <= 4'h0;
            r_freq_bcd0 <= 4'h0;
            r_freq_dp <= 4'h0;
        end
        else
        begin
            r_state <= w_state_next;
            r_freq_bcd3 <= w_freq_bcd3_next;
            r_freq_bcd2 <= w_freq_bcd2_next;
            r_freq_bcd1 <= w_freq_bcd1_next;
            r_freq_bcd0 <= w_freq_bcd0_next;
            r_freq_dp <= w_freq_dp_next;
        end
    end

    always_comb
    begin
        //defaults
        w_state_next = r_state;
        o_ready = 1'b0;
        o_done = 1'b0;
        o_overflow = 1'b0;
        o_underflow = 1'b0;
        w_per_counter_start = 1'b0;
        w_div_start = 1'b0;
        w_bintobcd_start = 1'b0;

        w_freq_bcd3_next = r_freq_bcd3;
        w_freq_bcd2_next = r_freq_bcd2;
        w_freq_bcd1_next = r_freq_bcd1;
        w_freq_bcd0_next = r_freq_bcd0;
        w_freq_dp_next = r_freq_dp;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
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
                    if (w_per_counter_overflow)
                    begin
                        // period overflow is freq underflow
                        w_freq_bcd3_next = 4'hE;
                        w_freq_bcd2_next = 4'h0;
                        w_freq_bcd1_next = 4'h0;
                        w_freq_bcd0_next = 4'h0;
                        w_freq_dp_next = 0;
                        w_state_next = e_underflow;
                    end
                    if (w_per_counter_underflow)
                    begin
                        // period underflow is freq overflow
                        w_freq_bcd3_next = 4'hE;
                        w_freq_bcd2_next = 4'h9;
                        w_freq_bcd1_next = 4'h9;
                        w_freq_bcd0_next = 4'h9;
                        w_freq_dp_next = 0;
                        w_state_next = e_overflow;
                    end
                end
            end
            e_divide:
            begin
                if (w_div_done)
                begin
                    w_bintobcd_start = 1'b1;
                    w_state_next = e_bcdconv;
                end
            end
            e_bcdconv:
            begin
                if (w_bintobcd_done)
                begin
                    w_freq_bcd3_next = w_bintobcd_freq_bcd3;
                    w_freq_bcd2_next = w_bintobcd_freq_bcd2;
                    w_freq_bcd1_next = w_bintobcd_freq_bcd1;
                    w_freq_bcd0_next = w_bintobcd_freq_bcd0;
                    w_freq_dp_next = w_bintobcd_freq_dp;

                    if (w_bintobcd_overflow)
                    begin
                        w_freq_bcd3_next = 4'hE;
                        w_freq_bcd2_next = 4'h9;
                        w_freq_bcd1_next = 4'h9;
                        w_freq_bcd0_next = 4'h8;
                        w_freq_dp_next = 0;
                        w_state_next = e_overflow;
                    end
                    w_state_next = e_done;
                end
            end
            e_underflow: // Frequency too low
            begin
                o_done = 1'b1;
                o_overflow = 1'b1;
                w_state_next = e_idle;
            end
            e_overflow: // Frequency too high
            begin
                o_done = 1'b1;
                o_underflow = 1'b1;
                w_state_next = e_idle;
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_idle;
            end
            default: w_state_next = e_idle;
        endcase
    end

    assign o_freq_bcd3 = r_freq_bcd3;
    assign o_freq_bcd2 = r_freq_bcd2;
    assign o_freq_bcd1 = r_freq_bcd1;
    assign o_freq_bcd0 = r_freq_bcd0;
    assign o_freq_dp = r_freq_dp;


endmodule