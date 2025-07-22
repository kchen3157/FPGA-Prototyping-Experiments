

module debouncer
    #(parameter TICK_PER_10NS = 1_000_000) // tick period in 10s of ns
    (
        input   logic i_clk, i_rst,
        input   logic i_sw,
        output  logic o_sw_debounced,
        output  logic [2:0] o_debounce_state,
        output  logic o_slow_tick
    );

    typedef enum {e_zero, e_wait1_1, e_wait1_2, e_wait1_3,
                  e_one, e_wait0_1, e_wait0_2, e_wait0_3} t_debounce_state;

    // generate slower (default 10ms) tick
    logic w_slow_tick;
    logic [$clog2(TICK_PER_10NS)-1:0] r_tick_counter, w_tick_counter_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_tick_counter <= 0;
        end
        else
        begin
            r_tick_counter <= w_tick_counter_next;
        end
    end
    assign w_tick_counter_next = (r_tick_counter >= TICK_PER_10NS-1) ? 0 : r_tick_counter + 1;
    assign w_slow_tick = (r_tick_counter == TICK_PER_10NS-1) ? 1'b1 : 1'b0;
    assign o_slow_tick = w_slow_tick;

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
    
    // combined next state and output logic
    always_comb
    begin
        case (r_debounce_state)
            e_zero:
            begin
                o_sw_debounced = 1'b0;
                w_debounce_state_next = (i_sw) ? e_wait1_1 : e_zero;
            end
            e_one:
            begin
                o_sw_debounced = 1'b1;
                w_debounce_state_next = (~i_sw) ? e_wait0_1 : e_one;
            end
            e_wait1_1:
            begin
                o_sw_debounced = 1'b0;
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_1;
                else if (i_sw)
                    w_debounce_state_next = e_wait1_2;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait1_2:
            begin
                o_sw_debounced = 1'b0;
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_2;
                else if (i_sw)
                    w_debounce_state_next = e_wait1_3;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait1_3:
            begin
                o_sw_debounced = 1'b0;
                if (i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait1_3;
                else if (i_sw)
                    w_debounce_state_next = e_one;
                else
                    w_debounce_state_next = e_zero;
            end
            e_wait0_1:
            begin
                o_sw_debounced = 1'b1;
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_1;
                else if (~i_sw)
                    w_debounce_state_next = e_wait0_2;
                else
                    w_debounce_state_next = e_one;
            end
            e_wait0_2:
            begin
                o_sw_debounced = 1'b1;
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_2;
                else if (~i_sw)
                    w_debounce_state_next = e_wait0_3;
                else
                    w_debounce_state_next = e_one;
            end
            e_wait0_3:
            begin
                o_sw_debounced = 1'b1;
                if (~i_sw & ~w_slow_tick)
                    w_debounce_state_next = e_wait0_3;
                else if (~i_sw)
                    w_debounce_state_next = e_zero;
                else
                    w_debounce_state_next = e_one;
            end
            default:
            begin
                o_sw_debounced = 1'b0;
                w_debounce_state_next = e_zero;
            end
        endcase
    end
endmodule
