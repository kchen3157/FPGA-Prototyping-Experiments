

module float_to_int
    (
        input   logic [12:0] a,
        output  logic [7:0] y,
        output  logic of,
        output  logic uf
    );

    logic [7:0] a_frac;
    logic [3:0] a_exp;
    logic a_neg, y_neg;
    logic [6:0] y_frac;

    assign a_neg = a[12:12];
    assign a_exp = a[11:8];
    assign a_frac = a[7:0];

    always_comb
    begin
        uf = 1'b0;
        of = 1'b0;
        if (a_exp <= 7)
        begin
            y_frac = a_frac[7:1] >> (7 - a_exp);
        end
        else
        begin
            y_frac = a_frac[6:0] << (a_exp - 8);
            if (a_neg)
            begin
                uf = 1'b1;
            end
            else
            begin
                of = 1'b1;
            end
        end
    end
    
    assign y_neg = a_neg;

    assign y = {y_neg, y_frac};

endmodule
