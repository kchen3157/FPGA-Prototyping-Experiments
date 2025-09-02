
module parking_lot_occupancy_counter
    (
        input   logic i_clk, i_rst,
        input   logic i_a, i_b,
        output  logic o_car_enter,
        output  logic o_car_exit
    );

    typedef enum logic [2:0] {e_unblocked = 3'h0, e_enter_a = 3'h1, e_enter_both = 3'h2, e_enter_b = 3'h3,
                              e_exit_b = 3'h4, e_exit_both = 3'h5, e_exit_a = 3'h6} t_ploc_state;
    t_ploc_state r_ploc_state, w_ploc_state_next;

    // state register
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_ploc_state <= e_unblocked;
        end
        else
        begin
            r_ploc_state <= w_ploc_state_next;
        end
    end

    // next state and output logic
    always_comb
    begin
        w_ploc_state_next = e_unblocked;
        o_car_enter = 1'b0;
        o_car_exit = 1'b0;

        case (r_ploc_state)
            e_unblocked:
                if (i_a & ~i_b)
                    w_ploc_state_next = e_enter_a;
                else if (~i_a & i_b)
                    w_ploc_state_next = e_exit_b;
            e_enter_a:
                if (i_a & i_b)
                    w_ploc_state_next = e_enter_both;
                else if (i_a & ~i_b)
                    w_ploc_state_next = r_ploc_state;
            e_enter_both:
                if (~i_a & i_b)
                    w_ploc_state_next = e_enter_b;
                else if (i_a & i_b)
                    w_ploc_state_next = r_ploc_state;
            e_enter_b:
                if (~i_a & ~i_b)
                begin
                    w_ploc_state_next = e_unblocked;
                    o_car_enter = 1'b1;
                end
                else if (~i_a & i_b)
                    w_ploc_state_next = r_ploc_state;
            e_exit_b:
                if (i_a & i_b)
                    w_ploc_state_next = e_exit_both;
                else if (~i_a & i_b)
                    w_ploc_state_next = r_ploc_state;
            e_exit_both:
                if (i_a & ~i_b)
                    w_ploc_state_next = e_exit_a;
                else if (i_a & i_b)
                    w_ploc_state_next = r_ploc_state;
            e_exit_a:
                if (~i_a & ~i_b)
                begin
                    w_ploc_state_next = e_unblocked;
                    o_car_exit = 1'b1;
                end
                else if (i_a & ~i_b)
                    w_ploc_state_next = r_ploc_state;
            default:
                w_ploc_state_next = e_unblocked;
        endcase
    end


endmodule