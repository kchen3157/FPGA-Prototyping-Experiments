`timescale 1 ns/10 ps

module db_earlydet
    #(parameter TICK_PERIOD_10NS = 2_000_000) // tick period in 10s of ns
    (
        input   logic i_clk, i_rst,
        input   logic i_sw,
        output  logic o_sw_debounced, o_rising
    );

    typedef enum logic [1:0] {e_zero, e_wait1, e_one, e_wait0} t_debounce_state;
    t_debounce_state r_debounce_state, w_debounce_state_next;

    // generate tick and control
    logic [$clog2(TICK_PERIOD_10NS)-1:0] r_tick_counter, w_tick_counter_next;
    logic w_tick, w_tick_dec, w_tick_load;

    // state and data register
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_debounce_state <= e_zero;
            r_tick_counter <= 0;
        end
        else
        begin
            r_debounce_state <= w_debounce_state_next;
            r_tick_counter <= w_tick_counter_next;
        end
    end

    assign w_tick_counter_next = (w_tick_load) ? {$clog2(TICK_PERIOD_10NS){1'b1}} :
                                 (w_tick_dec)  ? r_tick_counter - 1 :
                                                 r_tick_counter;
    assign w_tick = (w_tick_counter_next == 0);

    // next state logic
    always_comb
    begin
        w_debounce_state_next = r_debounce_state;
        w_tick_load = 1'b0;
        w_tick_dec = 1'b0;
        o_sw_debounced = 1'b0;
        o_rising = 1'b0;
        case (r_debounce_state)
            e_zero:
            begin
                if (i_sw)
                begin
                    w_debounce_state_next = e_wait1;
                    w_tick_load = 1'b1;
                end
            end
            e_wait1:
            begin
                o_sw_debounced = 1'b1;
                o_rising = 1'b1;

                w_tick_dec = 1'b1;
                if (w_tick)
                begin
                    w_debounce_state_next = e_one;
                end
            end
            e_one:
            begin
                o_sw_debounced = 1'b1;
                if (~i_sw)
                begin
                    w_debounce_state_next = e_wait0;
                    w_tick_load = 1'b1;
                    o_sw_debounced = 1'b0;
                end
            end
            e_wait0:
            begin
                w_tick_dec = 1'b1;
                if (w_tick)
                begin
                    w_debounce_state_next = e_zero;
                end
            end
            default:
            begin
                w_debounce_state_next = e_zero;
            end
        endcase
    end

endmodule
