

module rotating_square_sseg
    (
        input   logic i_clk, i_rst,
        input   logic i_cw, i_en,
        output  logic [7:0] o_sseg_n,
        output  logic [3:0] o_ldsel
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
        case (r_pat_state)
            3'h0:
            begin
                o_sseg_n = 8'b10011100;
                o_ldsel = 4'b1000;
            end
            3'h1:
            begin
                o_sseg_n = 8'b10011100;
                o_ldsel = 4'b0100;
            end
            3'h2:
            begin
                o_sseg_n = 8'b10011100;
                o_ldsel = 4'b0010;
            end
            3'h3:
            begin
                o_sseg_n = 8'b10011100;
                o_ldsel = 4'b0001;
            end
            3'h4: 
            begin
                o_sseg_n = 8'b10100011;
                o_ldsel = 4'b0001;
            end
            3'h5: 
            begin
                o_sseg_n = 8'b10100011;
                o_ldsel = 4'b0010;
            end
            3'h6: 
            begin
                o_sseg_n = 8'b10100011;
                o_ldsel = 4'b0100;
            end
            3'h7: 
            begin
                o_sseg_n = 8'b10100011;
                o_ldsel = 4'b1000;
            end
        endcase
    end
    



endmodule