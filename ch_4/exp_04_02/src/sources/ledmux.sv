

module led_4_1_mux
    (
        input   logic i_clk, i_reset,
        input   logic [3:0] i_pwm_ctl,
        input   logic [7:0] i_in_n [3:0], // ACTIVE LO
        output  logic [3:0] o_ldsel, // ACTIVE HI
        output  logic [7:0] o_sseg_n  // ACTIVE LO
    );

    logic [1:0] r_sel_state, r_sel_next;
    logic [3:0] w_ldsel;

    always_ff @(posedge i_clk)
    begin
        if (i_reset)
        begin
            r_sel_state <= 0;
        end
        else
        begin
            r_sel_state <= r_sel_next;
        end
    end

    assign r_sel_next = r_sel_state + 1;

    always_comb
    begin
        case (r_sel_state)
            2'b00:
            begin
                w_ldsel = 4'b0001;
                o_sseg_n = i_in_n[0];
            end
            2'b01:
            begin
                w_ldsel = 4'b0010;
                o_sseg_n = i_in_n[1];
            end
            2'b10:
            begin
                w_ldsel = 4'b0100;
                o_sseg_n = i_in_n[2];
            end
            default:
            begin
                w_ldsel = 4'b1000;
                o_sseg_n = i_in_n[3];
            end
        endcase
    end

    logic w_pdm;
    pwm_gen u_pwm_gen
        (.i_clk(i_clk), .i_rst(i_reset),
         .i_w(i_pwm_ctl), .o_q(w_pdm));

    assign o_ldsel = w_ldsel & {w_pdm, w_pdm, w_pdm, w_pdm};

endmodule