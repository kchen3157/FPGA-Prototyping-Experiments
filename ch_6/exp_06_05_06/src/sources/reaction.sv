
`timescale 1 ns/10 ps

module reaction
    #(
        parameter logic [31:0] SEED = 32'hDEADBEEF, // seed for random number generator
        parameter logic [31:0] UPPER_WAIT_MS = 32'd15_000, // max wait time before stimulus
        parameter logic [31:0] LOWER_WAIT_MS = 32'd2_000, // min wait time before stimulus
        parameter logic [13:0] MAX_REACT_TIME_MS = 14'd1_000, // max time for reaction before automatically going to result
        parameter CLK_PERIOD_NS = 10
    )
    (
        input   logic i_clk, i_rst,

        input   logic i_start, i_clear, i_stop, // user control signals

        output  logic [13:0] o_display_val, // output to display, in binary (BCD conversion and led mux handled by other modules)
        output  logic o_display_greeting, // when high, the display module ignores input val and displays "HI"
        output  logic o_led // stimulus LED
    );

    // *********** State and Register Definitions ***********
    typedef enum {e_idle, e_rand, e_wait, e_react, e_result} t_state;
    t_state r_state, w_state_next;

    logic [13:0] r_react_time, w_react_time_next;
    logic [13:0] r_wait_time, w_wait_time_next;

    // *********** Millisecond Tick Generator ***********
    logic w_tick_en, w_tick_clear, w_tick;
    logic [$clog2(1_000_000/CLK_PERIOD_NS)-1:0] r_tick_count, w_tick_count_next;
    always_comb
    begin
        if (w_tick_clear || r_tick_count >= 1_000_000/CLK_PERIOD_NS)
            w_tick_count_next = '0;
        else
            w_tick_count_next = (w_tick_en) ? (r_tick_count + 1) : (r_tick_count);
    end
    assign w_tick = (r_tick_count == 100_000);

    // *********** Random Number Generator Instantiation ***********
    logic w_rand_gen_generate;
    logic [31:0] w_rand_gen_seed, w_rand_gen_upper, w_rand_gen_lower;
    logic w_rand_gen_ready, w_rand_gen_done, w_rand_gen_invalid;
    logic [31:0] w_rand_gen_val;
    rand_gen u_rand_gen
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_generate(w_rand_gen_generate),
    
        .i_seed(w_rand_gen_seed),
        .i_upper(w_rand_gen_upper),
        .i_lower(w_rand_gen_lower),

        .o_ready(w_rand_gen_ready),
        .o_done(w_rand_gen_done),
        .o_invalid(w_rand_gen_invalid),
        
        .o_val(w_rand_gen_val)
    );
    assign w_rand_gen_seed = SEED;
    assign w_rand_gen_upper = UPPER_WAIT_MS;
    assign w_rand_gen_lower = LOWER_WAIT_MS;

    // *********** Register Instantiations ***********
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_react_time <= '0;
            r_wait_time <= '0;
            r_tick_count <= '0;
        end
        else if (i_clear)
        begin
            r_state <= e_idle;
            r_react_time <= '0;
            r_wait_time <= '0;
        end
        else
        begin
            r_state <= w_state_next;
            r_react_time <= w_react_time_next;
            r_wait_time <= w_wait_time_next;
            r_tick_count <= w_tick_count_next;
        end
    end

    // *********** FSMD Logic ***********
    always_comb
    begin
        // defaults
        w_state_next = r_state;

        w_tick_clear = 1'b0;
        w_tick_en = 1'b0;

        w_rand_gen_generate = 1'b0;

        w_react_time_next = r_react_time;
        w_wait_time_next = r_wait_time;

        o_display_greeting = 1'b0;
        o_display_val = '0;
        o_led = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_display_greeting = 1'b1;
                if (i_start && w_rand_gen_ready)
                begin
                    w_react_time_next = '0;
                    w_wait_time_next = '0;
                    w_tick_clear = 1'b1;

                    w_rand_gen_generate = 1'b1;
                    w_state_next = e_rand;
                end
            end
            e_rand:
            begin
                o_display_greeting = 1'b1;
                if (w_rand_gen_done)
                begin
                    w_tick_en = 1'b1;
                    w_wait_time_next = w_rand_gen_val[13:0];
                    w_state_next = e_wait;
                end
            end
            e_wait:
            begin
                w_tick_en = 1'b1;
                if (i_stop)
                begin
                    w_react_time_next = 14'd9999;
                    w_state_next = e_result;
                end
                else
                begin
                    if (w_tick)
                    begin
                        w_wait_time_next = r_wait_time - 1;
                    end
                    if (r_wait_time == 0)
                    begin
                        w_state_next = e_react;
                    end
                end
            end
            e_react:
            begin
                o_display_val = r_react_time;
                o_led = 1'b1;
                w_tick_en = 1'b1;
                if (w_tick)
                begin
                    w_react_time_next = r_react_time + 1;
                end
                if (i_stop)
                begin
                    w_state_next = e_result;
                end
                if (r_react_time > MAX_REACT_TIME_MS)
                begin
                    w_react_time_next = 14'd1000;
                    w_state_next = e_result;
                end
            end
            e_result:
            begin
                o_display_val = r_react_time;
                // do nothing, hold state
            end 
            default:
            begin
                w_state_next = e_idle;
            end
            
        endcase
    end

endmodule