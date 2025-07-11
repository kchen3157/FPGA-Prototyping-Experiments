

module heartbeat_sseg
    (
        input   logic i_clk, i_rst,
        output  logic [7:0] o_sseg_n [3:0]
    );

    // State register
    logic [1:0] r_pat_state;
    logic [1:0] w_pat_state_next;
    always_ff @(posedge i_clk)
    begin
        if (i_rst)
        begin
            r_pat_state <= 2'h0;
        end
        else
        begin
            r_pat_state <= w_pat_state_next;
        end
    end

    // Next-state logic
    assign w_pat_state_next = (r_pat_state == 2'h2) ? 2'h0 :
                              (r_pat_state + 1);

    // Output logic
    always_comb
    begin
        o_sseg_n = {8'hFF, 8'hFF, 8'hFF, 8'hFF};
        case (r_pat_state)
            2'h0:
            begin
                o_sseg_n[2] = 8'b11111001;
                o_sseg_n[1] = 8'b11001111;
            end
            2'h1:
            begin
                o_sseg_n[1] = 8'b11111001;
                o_sseg_n[2] = 8'b11001111;
            end
            default:
            begin
                o_sseg_n[0] = 8'b11111001;
                o_sseg_n[3] = 8'b11001111;
            end
        endcase
    end
    



endmodule