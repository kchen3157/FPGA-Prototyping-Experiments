

module gt_f
    (
        input   logic [12:0] a,
        input   logic [12:0] b,
        output  logic agtb
    );

    logic a_neg, b_neg;
    logic [3:0] a_exp, b_exp;
    logic [7:0] a_frac, b_frac;

    assign a_neg = a[12:12];
    assign a_exp = a[11:8];
    assign a_frac = a[7:0];
    assign b_neg = b[12:12];
    assign b_exp = b[11:8];
    assign b_frac = b[7:0];

    always_comb
    begin
        if (a_neg & b_neg) // if both negative, less magnitude is greater
        begin
            agtb = {a_exp, a_frac} < {b_exp, b_frac};
        end
        else if (!a_neg & !b_neg) // if both positive, more magnitude is greater
        begin
            agtb = {a_exp, a_frac} > {b_exp, b_frac};
        end
        else // otherwise, positive one is greater
        begin
            agtb = (a_neg) ? 1'b0 : 1'b1;
        end
    end

endmodule