

module rotating_square_sseg
    (
        input   logic i_clk, i_rst,
        input   logic i_cw, i_en,
        output  logic [7:0] o_sseg_n [3:0]
    );

    // State register
    logic [2:0] r_pat_state;
    logic [2:0] w_pat_state_next;
    always_ff @(posedge i_clk)
    begin
        if (i_rst)
        begin
            r_pat_state <= 3'h0;
        end
        else
        begin
            r_pat_state <= w_pat_state_next;
        end
    end

    // Next-state logic
    always_comb
    begin
        if (i_cw & i_en)
        begin
            w_pat_state_next = r_pat_state + 1;
        end
        else if (i_en)
        begin
            w_pat_state_next = r_pat_state - 1;
        end
        else
        begin
            w_pat_state_next = r_pat_state;
        end
    end

    // Output logic
    always_comb
    begin
        o_sseg_n = 32'h0;
        case (r_pat_state)
            3'h0: o_sseg_n[3] = 8'b10011100;
            3'h1: o_sseg_n[2] = 8'b10011100;
            3'h2: o_sseg_n[1] = 8'b10011100;
            3'h3: o_sseg_n[0] = 8'b10011100;
            3'h4: o_sseg_n[3] = 8'b10100011;
            3'h5: o_sseg_n[3] = 8'b10100011;
            3'h6: o_sseg_n[3] = 8'b10100011;
            3'h7: o_sseg_n[3] = 8'b10100011;
        endcase
    end
    



endmodule