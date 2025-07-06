
module hex_to_sseg
    (
        input   [3:0] i_hex,
        output  [7:0] o_sseg_n
    );

    logic [7:0] r_sseg_n;

    always_comb
    begin
        case (i_hex)
            4'h0: r_sseg_n = 8'b00000011;
            4'h1: r_sseg_n = 8'b00111111;
            4'h2: r_sseg_n = 8'b00100101;
            4'h3: r_sseg_n = 8'b00001101;
            4'h4: r_sseg_n = 8'b10011001;
            4'h5: r_sseg_n = 8'b01001001;
            4'h6: r_sseg_n = 8'b01000001;
            4'h7: r_sseg_n = 8'b00011111;
            4'h8: r_sseg_n = 8'b00000001;
            4'h9: r_sseg_n = 8'b00001001;
            4'hA: r_sseg_n = 8'b00010001;
            4'hB: r_sseg_n = 8'b11000001;
            4'hC: r_sseg_n = 8'b01100011;
            4'hD: r_sseg_n = 8'b10000101;
            4'hE: r_sseg_n = 8'b01100001;
            4'hF: r_sseg_n = 8'b01110001;
            default: r_sseg_n = 8'b11111111;
        endcase
    end

    assign o_sseg_n = r_sseg_n;

endmodule
