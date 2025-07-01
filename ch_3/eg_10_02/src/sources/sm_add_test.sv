
module sm_add_test
    (
        input   logic [7:0] sw,
        output  logic [7:0] sseg0,
        output  logic [7:0] sseg1
    );

    logic [3:0] sum, oct;

    sign_mag_add #(.N(4)) sm_adder_unit
        (.a(sw[3:0]), .b(sw[7:4]), .sum(sum));

    assign oct = {1'b0, sum[2:0]};

    hex_to_sseg sseg_unit
        (.hex(oct), .dp(1'b0), .sseg(sseg0));

    always_comb
    begin
        sseg1 = 8'b00000000;
        if (sum[3] == 1'b1)
        begin
            sseg1[6] = 1'b1;
        end
    end


endmodule