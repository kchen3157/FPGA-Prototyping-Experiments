// This is a Fibonacci sequence generating circuit.
//
//! Although it outputs 4 bytes, this generator is limited
//! to output a maximum of 9999 above the fibonacci generator
//! amount of 20 (F(20) = 6765, F(21) = 10946), to support
//! a 4 digit BCD conversion.
//
// TESTED INPUT(i_gen_amt): 5 Bit Binary 0d00->0d32 (0x00->0x20)
// TESTED OUTPUT(o_final): 4 Byte Binary 0d0000->0d9999 (0x0000->0x270F)


`timescale 1 ns/10 ps

module fib_operator
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [4:0] i_gen_amt,
        output  logic o_ready, o_done_tick,
        output  logic [15:0] o_final,
        output  logic o_overflow
    );

    typedef enum logic [1:0] {e_idle, e_operate, e_done} t_fib_state;

    t_fib_state r_state, w_state_next;
    logic [13:0] r_temp0, w_temp0_next;
    logic [13:0] r_temp1, w_temp1_next;
    logic [4:0] r_num, w_num_next;

    // FSMD state/data registers
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_temp0 <= 0;
            r_temp1 <= 0;
            r_num <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_temp0 <= w_temp0_next;
            r_temp1 <= w_temp1_next;
            r_num <= w_num_next;
        end
    end


    // next state logic
    always_comb
    begin
        // defaults
        w_state_next = r_state;
        w_temp0_next = r_temp0;
        w_temp1_next = r_temp1;
        w_num_next = r_num;

        o_ready = 1'b0;
        o_done_tick = 1'b0;
        o_final = {2'b00, r_temp1};
        o_overflow = 1'b0;

        case (r_state)
            e_idle:
            begin
                o_ready = 1'b1;
                if (i_start)
                begin
                    w_temp0_next = 0;
                    w_temp1_next = 20'd1;
                    w_num_next = i_gen_amt;
                    w_state_next = e_operate;
                    if (i_gen_amt > 20)
                    begin
                        w_temp1_next = 14'd9999;
                        o_overflow = 1'b1;
                        w_state_next = e_done;
                    end
                end
            end
            e_operate:
            begin
                if (r_num == 0)
                begin
                    w_temp1_next = 0;
                    w_state_next = e_done;
                end
                else if (r_num == 1)
                begin
                    w_state_next = e_done;
                end
                else
                begin
                    w_temp1_next = r_temp1 + r_temp0;
                    w_temp0_next = r_temp1;
                    w_num_next = r_num - 1;
                end
            end
            e_done:
            begin
                o_done_tick = 1'b1;
                w_state_next = e_idle;
            end
            default:
                w_state_next = e_idle;
        endcase
    end

endmodule