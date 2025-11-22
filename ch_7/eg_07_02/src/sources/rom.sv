// Listing 7.4 True ROM using file

module true_rom_file
    (
        input   logic [3:0] i_addr,
        output  logic [6:0] o_data
    );

    logic [6:0] r_rom [0:15];

    initial begin
        $readmemb("led_pattern.txt", rom);
    end

    assign o_data = r_rom[i_addr];

endmodule

// Listing 7.5 True ROM using case statement

module true_rom_case
    (
        input   logic [3:0] i_addr,
        output  logic [6:0] o_data
    );

    always_comb
        case (i_addr)
            4'h0: o_data = 7'b1000000;
            4'h1: o_data = 7'b1111001;
            4'h2: o_data = 7'b0100100;
            4'h3: o_data = 7'b0110000;
            4'h4: o_data = 7'b0011001;
            4'h5: o_data = 7'b0010010;
            4'h6: o_data = 7'b0000010;
            4'h7: o_data = 7'b1111000;
            4'h8: o_data = 7'b0000000;
            4'h9: o_data = 7'b0010000;
            4'hA: o_data = 7'b0001000;
            4'hB: o_data = 7'b0000011;
            4'hC: o_data = 7'b1000110;
            4'hD: o_data = 7'b0100001;
            4'hE: o_data = 7'b0000110;
            4'hF: o_data = 7'b0001110;
        endcase
endmodule


// Listing 7.6 True ROM with initial values
module true_rom_initval
    (
        input   logic [3:0] i_addr,
        output  logic [6:0] o_data
    );

    logic [6:0] rom [0:15] = '{
        7'b1000000,
        7'b1111001,
        7'b0100100,
        7'b0110000,
        7'b0011001,
        7'b0010010,
        7'b0000010,
        7'b1111000,
        7'b0000000,
        7'b0010000,
        7'b0001000,
        7'b0000011,
        7'b1000110,
        7'b0100001,
        7'b0000110,
        7'b0001110
    };

    assign o_data = r_rom[i_addr];
endmodule
