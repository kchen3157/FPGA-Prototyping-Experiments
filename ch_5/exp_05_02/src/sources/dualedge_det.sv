`timescale 1 ns/10 ps

module dualedge_detector_moore
    (
        input   logic i_clk, i_rst,
        input   logic i_lvl,
        output  logic o_edge
    );

    typedef enum {e_zero, e_edge, e_one} t_edge_state;

    // state register
    t_edge_state r_det_state, w_det_state_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_det_state <= e_zero;
        end
        else
        begin
            r_det_state <= w_det_state_next;
        end
    end

    // next state logic
    always_comb
    begin
        case (r_det_state)
            e_zero:
                w_det_state_next = i_lvl ? e_edge : e_zero;
            e_edge:
                w_det_state_next = i_lvl ? e_one : e_zero;
            e_one:
                w_det_state_next = i_lvl ? e_one : e_edge;
            default:
                w_det_state_next = e_zero;
        endcase
    end

    // output logic
    assign o_edge = (r_det_state == e_edge) ? 1'b1 : 1'b0;

endmodule


module dualedge_detector_mealy
    (
        input   logic i_clk, i_rst,
        input   logic i_lvl,
        output  logic o_edge
    );

    // state register
    logic r_det_state, w_det_state_next;
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
        begin
            r_det_state <= 1'b0;
        end
        else
        begin
            r_det_state <= w_det_state_next;
        end
    end

    // next state logic
    assign w_det_state_next = (i_lvl) ? 1'b1 : 1'b0;

    // output logic
    assign o_edge = (~r_det_state && i_lvl) ||
                    (r_det_state && ~i_lvl);

endmodule
