`timescale 1 ns/10 ps

module debouncer_early_det
    #(parameter TICK_PERIOD_10NS = 2_000_000) // tick period in 10s of ns
    (
        input   logic i_clk, i_rst,
        input   logic i_sw,
        output  logic o_sw_debounced
    );

    typedef enum logic {e_zero, e_wait1, e_one, e_wait0} t_debounce_state;

    // generate 20ms tick
    logic w_slow_tick;
    logic [$clog2(TICK_PERIOD_10NS)-1:0] r_tick_counter, w_tick_counter_next;
    always_ff @(posedge i_clk)
    begin
        if (r_debounce_state == e_one || r_debounce_state == e_zero)
        begin
            r_tick_counter <= 0;
        end
        else
        begin
            r_tick_counter <= w_tick_counter_next;
        end
    end
    assign w_tick_counter_next = r_tick_counter + 1;
    assign w_slow_tick = (r_tick_counter == TICK_PERIOD_10NS) ? 1'b1 : 1'b0;

    // state register
    t_debounce_state r_debounce_state, w_debounce_state_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_debounce_state <= e_zero;
        else
            r_debounce_state <= w_debounce_state_next;
    end
    assign o_debounce_state = r_debounce_state;

    // next state logic
    always_comb
    begin
        w_debounce_state_next = r_debounce_state
        case (r_debounce_state)
            e_zero:
                if (i_sw)
                    w_debounce_state_next = e_wait1;
            e_wait1:
            begin
                if (w_slow_tick)
                    w_debounce_state_next = (i_sw) ? e_one : e_zero;
            end
            e_one:
                if (~i_sw)
                    w_debounce_state_next = e_wait0;
            e_wait0:
            begin
                if (w_slow_tick)
                    w_debounce_state_next = (i_sw) ? e_one : e_zero;
            end
        endcase
    end

    // output logic
    assign o_sw_debounced = ((r_debounce_state == e_one) || (r_debounce_state == e_wait1)) ? 1'b1 : 1'b0;
endmodule
