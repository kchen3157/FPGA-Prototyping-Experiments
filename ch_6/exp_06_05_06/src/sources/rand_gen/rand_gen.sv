// This random number generator uses the lfsr32 circuit to generate a
// 32 bit integer with values from i_lower_bound to i_upper_bound, 
// inclusive.

`timescale 1 ns/10 ps

module rand_gen
    (
        input   logic i_clk, i_rst,
        input   logic i_generate,
        
        input   logic [31:0] i_seed,
        input   logic [31:0] i_upper,
        input   logic [31:0] i_lower,

        output  logic o_ready,
        output  logic o_done,
        output  logic o_invalid,
        output  logic [31:0] o_val
    );

    typedef enum { e_ready, e_lfsr_setup, e_lfsr, e_div, e_done } t_state;
    t_state r_state, w_state_next;
    logic [31:0] r_seed, w_seed_next;
    logic [31:0] r_upper, w_upper_next;
    logic [31:0] r_lower, w_lower_next;
    logic [31:0] r_val_unshifted, w_val_unshifted_next;
    
    logic [31:0] w_range;
    assign w_range = r_upper - r_lower;


    logic w_lfsr32_en, w_lfsr32_load_seed;
    logic [31:0] w_lfsr32_val;
    lfsr32 u_lfsr32
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_en(w_lfsr32_en),             

        .i_load_seed(w_lfsr32_load_seed),
        .i_seed(r_seed),         

        .o_val(w_lfsr32_val)
    );

    logic w_div_start, w_div_ready, w_div_done;
    logic [31:0] w_div_remain;
    div #(.WIDTH(32)) u_div
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_div_start),
        .i_dividend(w_lfsr32_val), .i_divisor(w_range),
        .o_ready(w_div_ready), .o_done(w_div_done),
        .o_quotient(), .o_remain(w_div_remain)
    );

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state = e_ready;
            r_seed = 32'h1;
            r_upper = 32'hFFFF_FFFF;
            r_lower = 32'h0;
            r_val_unshifted = 32'h0;
        end
        else
        begin
            r_state = w_state_next;
            r_seed = w_seed_next;
            r_upper = w_upper_next;
            r_lower = w_lower_next;
            r_val_unshifted = w_val_unshifted_next;
        end
    end

    always_comb
    begin
        w_state_next = r_state;
        w_seed_next = r_seed;
        w_upper_next = r_upper;
        w_lower_next = r_lower;
        w_val_unshifted_next = r_val_unshifted;

        o_done = 0;
        o_invalid = 0;
        o_ready = 0;

        // LFSR Control
        w_lfsr32_en = 0;
        w_lfsr32_load_seed = 0;

        // DIV Control
        w_div_start = 0;

        case (r_state)
            e_ready:
            begin
                o_ready = 1'b1;
                if (i_generate)
                begin
                    w_seed_next = i_seed;
                    w_upper_next = i_upper;
                    w_lower_next = i_lower;

                    w_state_next = (w_seed_next == r_seed) ? e_lfsr : e_lfsr_setup;
                    w_lfsr32_en = (w_seed_next == r_seed) ? 1'b1 : 1'b0;
                end
            end
            e_lfsr_setup:
            begin
                if (r_lower >= r_upper)
                begin
                    o_invalid = 1'b1;
                    w_state_next = e_ready;
                end
                w_lfsr32_load_seed = 1'b1;
                w_lfsr32_en = 1'b1;
                w_state_next = e_lfsr;
            end
            e_lfsr:
            begin
                w_div_start = 1'b1;
                w_state_next = e_div;
            end
            e_div:
            begin
                if (w_div_done)
                begin
                    w_val_unshifted_next = w_div_remain;
                    w_state_next = e_done;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                o_ready = 1'b1;
                if (i_generate)
                begin
                    w_seed_next = i_seed;
                    w_upper_next = i_upper;
                    w_lower_next = i_lower;

                    w_state_next = (w_seed_next == r_seed) ? e_lfsr : e_lfsr_setup;
                    w_lfsr32_en = (w_seed_next == r_seed) ? 1'b1 : 1'b0;
                end
            end
            default:
            begin
                w_state_next = e_ready;
            end
        endcase
    end

    assign o_val = r_lower + r_val_unshifted;

endmodule