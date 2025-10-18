// This period counter counts with a precision of 1 microsecond, and has a range of 1 us to (1E6)-1 us.
// It counts between the first two rising edges of i_signal after i_start is high for one clock.
// Must wait till o_ready is high to record new measurement.
//
// Output is the period in microseconds in 20 bit binary.
// The output period is ready upon rising edge of o_done signal.
// Underflow (< 1 us) and overflow (> 999,999 us) are indicated upon output ready.

module period_counter_us
    #(
        parameter CLK_FREQ = 100_000_000,
        parameter POLL_FREQ = 1_000_000
    )
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic i_signal,

        output  logic o_ready, o_done,
        output  logic o_overflow, o_underflow,
        output  logic [$clog2(POLL_FREQ)-1:0] o_period
    );

    typedef enum logic [2:0] { e_idle, e_wait, e_measure, e_done, e_overflow, e_underflow} t_state;

    t_state r_state, w_state_next;
    logic [$clog2(CLK_FREQ / POLL_FREQ)-1:0] r_count_clk, w_count_clk_next; // CLK/1E6 = 100, 10ns CPU period * 100 = 1us period
    logic [$clog2(POLL_FREQ)-1:0] r_count_us, w_count_us_next;
    logic r_prev_signal, w_prev_signal_next;

    always_ff @( posedge i_clk, posedge i_rst ) begin : register_inst
        if (i_rst)
        begin
            r_state <= e_idle;
            r_count_clk <= 0;
            r_count_us <= 0;
            r_prev_signal <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_count_clk <= w_count_clk_next;
            r_count_us <= w_count_us_next;
            r_prev_signal <= w_prev_signal_next;
        end
    end

    always_comb 
    begin : next_state_logic
        // defaults
        o_ready = 1'b0;
        o_done = 1'b0;
        o_overflow = 1'b0;
        o_underflow = 1'b0;
        w_state_next = r_state;
        w_count_us_next = r_count_us;
        w_count_clk_next = r_count_clk;
        w_prev_signal_next = i_signal;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_state_next = e_wait;
                end
            end
            e_wait:
            begin
                if (~r_prev_signal & i_signal) // Capture first rising edge
                begin
                    w_state_next = e_measure;
                    w_count_clk_next = 1;
                    w_count_us_next = 0;
                end
            end
            e_measure:
            begin
                if (r_count_us > (POLL_FREQ - 1))
                begin
                    w_state_next = e_overflow;
                end
                else if (~r_prev_signal & i_signal) // Capture second rising edge
                begin
                    w_state_next = (r_count_us != 0) ? e_done : e_underflow;
                end
                else
                begin
                    if (w_count_clk_next == 99)
                    begin
                        w_count_clk_next = 0;
                        w_count_us_next = r_count_us + 1;
                    end
                    else
                    begin
                        w_count_clk_next = r_count_clk + 1;
                    end
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
            e_underflow:
            begin
                o_done = 1'b1;
                o_underflow = 1'b1;
                w_state_next = e_idle;
            end
            default: w_state_next = e_idle;
        endcase
    end

    assign o_period = r_count_us;

endmodule
