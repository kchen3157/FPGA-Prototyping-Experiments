`timescale 1 ns/10 ps


module bab_2_3_5
    (
        input   logic i_clk, i_rst,
        input   logic i_start, i_clear,
        input   logic [5:0] i_n,

        output  logic o_done,
        output  logic [12:0] o_val
    );

    typedef enum { e_idle, e_calc, e_done } t_state;
    t_state r_state, w_state_next;

    logic [5:0] r_calc_n, w_calc_n_next;
    logic [12:0] r_calc_f0_val, w_calc_f0_val_next;
    logic [12:0] r_calc_f1_val, w_calc_f1_val_next;

    logic [12:0] r_val, w_val_next;


    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_calc_n <= 0;
            r_calc_f0_val <= 0;
            r_calc_f1_val <= 0;
            r_val <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_calc_n <= w_calc_n_next;
            r_calc_f0_val <= w_calc_f0_val_next;
            r_calc_f1_val <= w_calc_f1_val_next;
            r_val <= w_val_next;
        end
    end

    always_comb
    begin
        w_state_next = r_state;
        w_calc_n_next = r_calc_n;
        w_calc_f0_val_next = r_calc_f0_val;
        w_calc_f1_val_next = r_calc_f1_val;
        w_val_next = r_val;

        o_done = 1'b0;

        case (r_state)
            e_idle:
            begin
                if (i_start)
                begin
                    w_calc_n_next = i_n;
                    w_calc_f0_val_next = 13'h5;
                    w_calc_f1_val_next = 13'h5;
                    w_state_next = e_calc;
                end
            end
            e_calc:
            begin
                if (r_calc_n == 0)
                begin
                    w_val_next = r_calc_f1_val;
                    w_state_next = e_done;
                end
                else
                begin
                    w_calc_f1_val_next = w_calc_f1_val_next + r_calc_f0_val;
                    w_calc_f0_val_next = r_calc_f0_val + 4;
                    w_calc_n_next = r_calc_n - 1;
                end
            end
            e_done:
            begin
                o_done = 1'b1;
                if (i_clear)
                begin
                    w_state_next = e_idle;
                end
            end
            default:
                w_state_next = e_idle;
        endcase
        
    end

    assign o_val = r_val;
    

endmodule