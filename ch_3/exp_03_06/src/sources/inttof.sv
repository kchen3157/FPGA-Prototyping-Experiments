

module int_to_float
    (
        input   logic [7:0] a,
        output  logic [12:0] y
    );

    logic a_neg, y_neg;
    logic [6:0] a_frac;
    logic [7:0] y_frac;
    logic [3:0] y_exp;
    logic [3:0] shift_amt;

    // parse input
    assign a_neg = a[7:7];
    assign a_frac = a[6:0];

    // calc shift amt
    always_comb
    begin
        casex (a_frac)
            7'b1??????: shift_amt = 4'd0; // exp=7
            7'b01?????: shift_amt = 4'd1; // exp=6
            7'b001????: shift_amt = 4'd2; // exp=5
            7'b0001???: shift_amt = 4'd3; // ... (exp=7 - shift_amt)
            7'b00001??: shift_amt = 4'd4;
            7'b000001?: shift_amt = 4'd5;
            7'b0000001: shift_amt = 4'd6;
            default:    shift_amt = 4'd7;
        endcase
    end

    // parse output sign bit
    assign y_neg = a_neg;

    // parse output frac
    assign y_frac = {a_frac, 1'b0} << shift_amt;

    // parse output
    assign y_exp = 7 - shift_amt;

    // send out
    assign y = {y_neg, y_exp, y_frac};

endmodule
