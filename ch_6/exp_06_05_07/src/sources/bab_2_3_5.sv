

module bab_2_3_5
    (
        input   logic i_clk, i_rst,
        input   logic i_start, i_clear,
        input   logic [5:0] i_n,

        output  logic [12:0] o_val
    );

    typedef enum { e_idle, e_calc_f0, e_calc_f1, e_done } t_state;
    t_state r_state, w_state_next;

    logic [5:0] r_calc_f0_n, w_calc_f0_n_next;
    logic [12:0] r_calc_f0_val, w_calc_f0_val_next;
    logic [5:0] r_calc_f1_n, w_calc_f1_n_next;
    logic [12:0] r_calc_f1_val, w_calc_f1_val_next;

    logic [12:0] r_val, w_val_next;


    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_state <= e_idle;
            r_calc_f0_n <= 0;
            r_calc_f0_val <= 0;
            r_calc_f1_n <= 0;
            r_calc_f1_val <= 0;
            r_val <= 0;
        end
        else
        begin
            r_state <= w_state_next;
            r_calc_f0_n <= w_calc_f0_n_next;
            r_calc_f0_val <= w_calc_f0_val_next;
            r_calc_f1_n <= w_calc_f1_n_next;
            r_calc_f1_val <= w_calc_f1_val_next;
            r_val <= w_val_next;
        end
    end

    always_comb
    begin
        w_state_next = r_state;
        w_calc_f0_n_next = r_calc_f0_n;
        w_calc_f0_val_next = r_calc_f0_val;
        w_calc_f1_n_next = r_calc_f1_n;
        w_calc_f1_val_next = r_calc_f1_val;
        w_val_next = r_val;

        case (r_state)
            e_idle:
            begin
                if (i_start)
                begin
                    w_calc_f0_n_next = i_n;
                    w_calc_f0_val_next = 13'h5;
                    w_calc_f1_n_next = i_n;
                    w_calc_f1_val_next = 13'h5;
                    w_state_next = e_calc_f0;
                end
            end
            e_calc_f0:
            begin
                if (r_calc_f0_n == 0 || r_calc_f0_n == 1)
                begin
                    w_state_next = e_calc_f0;
                end
                else
                begin
                    w_calc_f0_val_next = r_calc_f0_val + 4;
                    w_calc_f0_n_next = r_calc_f0_n - 1;
                end
            end
            e_calc_f1:
            begin
                if (r_calc_f0_n == 0)
                begin
                    w_val_next = r_calc_f1_val;
                    w_state_next = e_done;
                end
                else
                begin
                    w_calc_f1_val_next = r_calc_f1_val + r_calc_f0_val;
                    w_calc_f1_n_next = r_calc_f1_n - 1;
                end
            end
            e_done:
            begin
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