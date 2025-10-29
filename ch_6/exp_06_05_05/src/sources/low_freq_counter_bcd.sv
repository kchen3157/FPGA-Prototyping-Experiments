// This 


module low_freq_counter_bin
    (
        input   logic i_clk, i_rst,
        input   logic i_start, i_signal,

        output  logic [31:0] o_frequency,

        output  logic o_ready, o_done
    );

    localparam CLK_FREQ = 100_000_000; // Base clock frequency
    localparam POLL_FREQ = 1_000_000; // Polling frequency (1E6 polled every microsecond)
    localparam DIV_WIDTH = 32; // Width of division circuit

    logic w_per_counter_start;
    logic w_per_counter_done;
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
        .o_overflow(), .o_underflow(), // TODO: When these are high, don't care the rest and set output to 0/9999
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
        .o_quotient(o_frequency), .o_remain()
    );


    typedef enum logic [1:0] { e_idle, e_count_per, e_divide } t_state;
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
        o_ready = 1'b0;
        o_done = 1'b0;
        w_per_counter_start = 1'b0;
        w_div_start = 1'b0;

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
                end
            end
            e_divide:
            begin
                if (w_div_done)
                begin
                    o_done = 1'b1;
                    w_state_next = e_idle;
                end
            end
            default: w_state_next = e_idle;
        endcase
    end


endmodule