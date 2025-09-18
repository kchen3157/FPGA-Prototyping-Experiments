
module per_counter
    #(parameter CLK_FREQ = 100_000_000)
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic i_signal,
        output  logic o_ready, o_done,
        output  logic [9:0] o_period
    );

    typedef enum logic [1:0] { e_idle, e_wait, e_measure, e_done } t_state;

    t_state r_state, w_state_next;
    logic [$clog2(CLK_FREQ / 1000)-1:0] r_count_10ns, w_count_10ns_next;
    logic [9:0] r_count_ms, w_count_ms_next;
    logic r_prev_signal, w_prev_signal_next;

    always_ff @( posedge i_clk, posedge i_rst ) begin : register_inst
        if (i_rst)
        begin
            r_state <= e_idle;
            r_count_10ns <= 0;
            r_count_ms <= 0;
            r_prev_signal <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_count_10ns <= w_count_10ns_next;
            r_count_ms <= w_count_ms_next;
            r_prev_signal <= w_prev_signal_next;
        end
    end

    always_comb begin : next_state_logic
        // defaults
        o_ready = 1'b0;
        o_done = 1'b0;
        w_state_next = r_state;
        w_count_ms_next = r_count_ms;
        w_count_10ns_next = r_count_10ns;
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
                if (~r_prev_signal & i_signal)
                begin
                    w_state_next = e_measure;
                    w_count_10ns_next = 0;
                    w_count_ms_next = 0;
                end
            end
            e_measure:
            begin
                if (~r_prev_signal & i_signal)
                begin
                    w_state_next = e_done;
                end
                else
                begin
                    if (w_count_10ns_next == 99_999)
                    begin
                        w_count_10ns_next = 0;
                        w_count_ms_next = r_count_ms + 1;
                    end
                    else
                        w_count_10ns_next = r_count_10ns + 1;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                w_state_next = e_idle;
            end
        endcase
    end

    assign o_period = r_count_ms;

endmodule
