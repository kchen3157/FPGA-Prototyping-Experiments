

module debouncer
    #(parameter TICK_PER_10NS = 1_000_000) // tick period in 10s of ns
    (
        input   logic i_clk, i_rst,
        input   logic i_sw,
        output  logic o_sw_debounced
    );

    typedef enum {e_zero, e_wait1_1, e_wait1_2, e_wait1_3,
                  e_one, e_wait0_1, e_wait0_2, e_wait0_3} t_debounce_state;

    // generate slower (default 10ms) tick
    logic w_slow_tick;
    logic [$clog2(TICK_PER_10NS)-1:0] r_tick_counter, w_tick_counter_next;
    always_ff @(posedge i_clk)
    begin
        r_tick_counter <= w_tick_counter_next;
    end
    assign w_tick_counter_next = r_tick_counter + 1;
    assign w_slow_tick = (r_tick_counter == 0) ? 1'b1 : 1'b0;

    // state register
    t_debounce_state r_debounce_state, w_debounce_state_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_debounce_state <= e_zero;
        else
            r_debounce_state <= w_debounce_state_next;
    end
    
    // next state logic
    always_comb
    begin
        case (r_debounce_state)
            e_zero:
                w_debounce_state_next = (i_sw) ? e_wait1_1 : e_zero;
            e_one:
                w_debounce_state_next = (i_sw) ? e_wait0_1 : e_one;
            e_wait1_1:
            begin
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_1;
                else if (i_sw)
                    w_debounce_state_next = e_wait1_2;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait1_2:
            begin
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_2;
                else if (i_sw)
                    w_debounce_state_next = e_wait1_3;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait1_3:
            begin
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_3;
                else if (i_sw)
                    w_debounce_state_next = e_one;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait0_1:
            begin
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_1;
                else if (~i_sw)
                    w_debounce_state_next = e_wait0_2;
                else
                    w_debounce_state_next = e_one;
            end
            e_wait0_2:
            begin
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_2;
                else if (~i_sw)
                    w_debounce_state_next = e_wait0_3;
                else
                    w_debounce_state_next = e_one;
            end
            e_wait0_3:
            begin
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_3;
                else if (~i_sw)
                    w_debounce_state_next = e_zero;
                else
                    w_debounce_state_next = e_one;
            end
            default: w_debounce_state_next = e_zero;
        endcase
    end

    // output logic
    assign o_sw_debounced = (r_debounce_state == e_one     ||
                             r_debounce_state == e_wait0_1 ||
                             r_debounce_state == e_wait0_2 ||
                             r_debounce_state == e_wait0_3) ? 1'b1 : 1'b0;
endmodule
