
module edge_detect_moore
    (
        input   logic i_clk, i_rst,
        input   logic i_level,
        output  logic o_tick
    );

    typedef enum {e_zero, e_edge, e_one} t_edge_state;

    t_edge_state r_edge_state, w_edge_state_next;

    // state register
    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_edge_state <= e_zero;
        else
            r_edge_state <= w_edge_state_next;
    end

    // next-state logic
    always_comb
    begin
        w_edge_state_next = r_edge_state;
        case (r_edge_state)
            e_zero:
            begin
                if (i_level)
                    w_edge_state_next = e_edge;
            end
            e_edge:
            begin
                if (i_level)
                    w_edge_state_next = e_one;
                else
                    w_edge_state_next = e_zero;
            end
            e_one:
            begin
                if (~i_level)
                    w_edge_state_next = e_zero;
            end
            default:
            begin
                w_edge_state_next = e_zero;
            end
        endcase
    end

    // output logic
    assign o_tick = (r_edge_state == e_edge);

endmodule

module edge_detect_mealy
    (
        input   logic i_clk, i_rst,
        input   logic i_level,
        output  logic o_tick
    );

    typedef enum {e_zero, e_one} t_edge_state;

    t_edge_state r_edge_state, w_edge_state_next;

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_edge_state <= e_zero;
        else
            r_edge_state <= w_edge_state_next;
    end

    always_comb
    begin
        w_edge_state_next = e_zero;
        if (i_level)
            w_edge_state_next = e_one;
    end

    assign o_tick = (r_edge_state == e_zero) && i_level;

endmodule

module edge_detect_gate
    (
        input   logic i_clk, i_rst,
        input   logic i_level,
        output  logic o_tick
    );

    logic r_delay;

    always_ff @(posedge i_clk, posedge i_rst)
    begin
        if (i_rst)
            r_delay <= 1'b0;
        else
            r_delay <= i_level;
    end

    assign o_tick = ~r_delay & i_level;
endmodule
