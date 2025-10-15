// Control module for a fibonacci generator that accepts BCD input
// and output. The output has a ceiling of decimal 9999, to account
// for the limitations of a four decimal digit display.
//
//! Non BCD-compliant input on i_gen_amt_bcd (0xA->0xF) will cause
//! undefined behavior.
//
// TESTED INPUT(i_gen_amt_bcd): 2 BCD 00->99
// TESTED OUTPUT(o_final_bcd): 4 BCD 0000->9999

`timescale 1 ns/10 ps

module fib_ctl
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [3:0] i_gen_amt_bcd1, i_gen_amt_bcd0,

        output  logic [3:0] o_final_bcd3, o_final_bcd2, o_final_bcd1, o_final_bcd0,
        output  logic o_ready, o_done
    );

    typedef enum {e_idle, e_conv_gen_amt_bin, e_fib_operation, e_conv_final_bcd} t_state;

    logic w_bcd2tobin2_start, w_bcd2tobin2_ready, w_bcd2tobin2_done;
    logic [7:0] w_gen_amt_bin;
    bcd2tobin2 u_bcd2tobin2
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_bcd2tobin2_start),
        .i_bcd1(i_gen_amt_bcd1), .i_bcd0(i_gen_amt_bcd0),

        .o_ready(w_bcd2tobin2_ready), .o_done(w_bcd2tobin2_done),
        .o_bin(w_gen_amt_bin)
    );

    logic w_fib_start, w_fib_ready, w_fib_done;
    logic [15:0] w_fib_out_bin;
    fib_operator u_fib_operator
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_fib_start),
        .i_gen_amt(w_gen_amt_bin),

        .o_ready(w_fib_ready), .o_done_tick(w_fib_done),
        .o_final(w_fib_out_bin),
        .o_overflow()
    );

    logic w_bin4tobcd4_start, w_bin4tobcd4_ready, w_bin4tobcd4_done;
    bin4tobcd4 u_bin4tobcd4
    (
        .i_clk(i_clk), .i_rst(i_rst),
        .i_start(w_bin4tobcd4_start),
        .i_bin(w_fib_out_bin),
        .o_ready(w_bin4tobcd4_ready), .o_done(w_bin4tobcd4_done),
        .o_bcd3(o_final_bcd3), .o_bcd2(o_final_bcd2), 
        .o_bcd1(o_final_bcd1), .o_bcd0(o_final_bcd0)
    );


    t_state r_state, w_state_next;

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_state = e_idle;
        else
            r_state = w_state_next;
    end

    always_comb
    begin
        w_bcd2tobin2_start = 1'b0;
        w_fib_start = 1'b0;
        w_bin4tobcd4_start = 1'b0;
        w_state_next = r_state;
        o_ready = 1'b0;
        o_done = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start & w_bcd2tobin2_ready)
                begin
                    w_bcd2tobin2_start = 1'b1;
                    w_state_next = e_conv_gen_amt_bin;
                end
            end
            e_conv_gen_amt_bin:
            begin
                if (w_bcd2tobin2_done & w_fib_ready)
                begin
                    w_fib_start = 1'b1;
                    w_state_next = e_fib_operation;
                end
            end
            e_fib_operation:
            begin
                if (w_bin4tobcd4_ready & w_fib_done)
                begin
                    w_bin4tobcd4_start = 1'b1;
                    w_state_next = e_conv_final_bcd;
                end
            end
            e_conv_final_bcd:
            begin
                if (w_bin4tobcd4_done)
                begin
                    o_done = 1'b1;
                    w_state_next = e_idle;
                end
            end
            default:
            begin
                w_state_next = e_idle;
            end
        endcase
    end
    
endmodule