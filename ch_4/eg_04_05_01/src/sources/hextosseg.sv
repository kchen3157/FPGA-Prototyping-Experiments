
module hex_to_sseg
    (
        input   logic [3:0] i_hex,
        output  logic [7:0] o_sseg_n
    );

    logic [7:0] r_sseg_n;

    always_comb
    begin
        case (i_hex)
            4'h0: r_sseg_n = 8'b11000000;
            4'h1: r_sseg_n = 8'b11111001;
            4'h2: r_sseg_n = 8'b10100100;
            4'h3: r_sseg_n = 8'b10110000;
            4'h4: r_sseg_n = 8'b10011001;
            4'h5: r_sseg_n = 8'b10010010;
            4'h6: r_sseg_n = 8'b10000010;
            4'h7: r_sseg_n = 8'b11111000;
            4'h8: r_sseg_n = 8'b10000000;
            4'h9: r_sseg_n = 8'b10010000;
            4'hA: r_sseg_n = 8'b10001000;
            4'hB: r_sseg_n = 8'b10000011;
            4'hC: r_sseg_n = 8'b11000110;
            4'hD: r_sseg_n = 8'b10100001;
            4'hE: r_sseg_n = 8'b10000110;
            4'hF: r_sseg_n = 8'b10001110;
            default: r_sseg_n = 8'b11111111;
        endcase
    end

    assign o_sseg_n = r_sseg_n;

endmodule
