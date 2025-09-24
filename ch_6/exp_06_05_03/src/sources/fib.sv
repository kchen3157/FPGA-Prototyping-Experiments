module fib
    (
        input   logic i_clk, i_rst,
        input   logic i_start,
        input   logic [4:0] i_gen_amt,
        output  logic o_ready, o_done_tick,
        output  logic [19:0] o_final
    );

    typedef enum logic [1:0] {e_idle, e_operate, e_done} t_fib_state;

    t_fib_state r_state, w_state_next;
    logic [19:0] r_temp0, w_temp0_next;
    logic [19:0] r_temp1, w_temp1_next;
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
        o_final = r_temp1;

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