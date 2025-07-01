module hex_to_sseg_test
    (
        input   logic [7:0] sw,
        output  logic [1:0] an,
        output  logic [7:0] sseg
    );

    logic [7:0] inc;
    logic [7:0] led0, led1, led2, led3;

    assign inc = sw + 1;

    // reg LSB
    hex_to_sseg sseg_unit_0
        (.hex(sw[3:0]), .dp(1'b0), .sseg(led0));
    // reg MSB
    hex_to_sseg sseg_unit_1
        (.hex(sw[7:4]), .dp(1'b0), .sseg(led1));
    // inc LSB
    hex_to_sseg sseg_unit_2
        (.hex(inc[3:0]), .dp(1'b0), .sseg(led2));
    // inc MSB
    hex_to_sseg sseg_unit_3
        (.hex(inc[7:4]), .dp(1'b0), .sseg(led3));


    always_comb
    begin
        case (an)
            2'b00:  sseg = led0;
            2'b01:  sseg = led1;
            2'b10:  sseg = led2;
            2'b11:  sseg = led3;
        endcase
    end
    
endmodule