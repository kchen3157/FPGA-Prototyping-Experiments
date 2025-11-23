
module rise_edge_det
    (
        input   logic i_clk, i_rst,
        input   logic i_signal,
        output  logic o_edge
    );

    typedef enum { e_idle0, e_idle1, e_edge } t_state;

    t_state r_state, w_state_next;

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_state <= e_idle0;
        else
            r_state <= w_state_next;
    end

    always_comb
    begin
        o_edge = 1'b0;
        w_state_next = r_state;

        case (r_state)
            e_idle0:
                if (i_signal)
                begin
                    w_state_next = e_edge;
                end
            e_idle1:
                if (~i_signal)
                begin
                    w_state_next = e_idle0;
                end
            e_edge:
            begin
                o_edge = 1'b1;
                w_state_next = e_idle1;
            end
        endcase
    end
endmodule