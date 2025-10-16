
module hex_to_sseg
    (
        input   logic [3:0] i_hex,
        input   logic i_dp,
        output  logic [7:0] o_sseg_n
    );

    logic [6:0] r_sseg_n;

    always_comb
    begin
        case (i_hex)
            4'h0: r_sseg_n = 7'b1000000;
            4'h1: r_sseg_n = 7'b1111001;
            4'h2: r_sseg_n = 7'b0100100;
            4'h3: r_sseg_n = 7'b0110000;
            4'h4: r_sseg_n = 7'b0011001;
            4'h5: r_sseg_n = 7'b0010010;
            4'h6: r_sseg_n = 7'b0000010;
            4'h7: r_sseg_n = 7'b1111000;
            4'h8: r_sseg_n = 7'b0000000;
            4'h9: r_sseg_n = 7'b0010000;
            4'hA: r_sseg_n = 7'b0001000;
            4'hB: r_sseg_n = 7'b0000011;
            4'hC: r_sseg_n = 7'b1000110;
            4'hD: r_sseg_n = 7'b0100001;
            4'hE: r_sseg_n = 7'b0000110;
            4'hF: r_sseg_n = 7'b0001110;
            default: r_sseg_n = 7'b1111111;
        endcase
    end

    assign o_sseg_n = {~i_dp, r_sseg_n};

endmodule
