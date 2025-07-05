module f_add
    (
        input   logic       sign1, sign2,
        input   logic [3:0] exp1, exp2,
        input   logic [7:0] frac1, frac2,
        output  logic       sign_out,
        output  logic [3:0] exp_out,
        output  logic [7:0] frac_out
    );

    // Stage 1: Sort
    logic sign_big, sign_small, sign_sum;
    logic [3:0] exp_big, exp_small, exp_diff, exp_sum;
    logic [7:0] frac_big, frac_small, frac_small_aligned, frac_sum_adj;
    logic [8:0] frac_sum;
    logic [2:0] num_leading_zeros;

    logic guard, round, sticky;
    logic round_carry;

    always_comb
    begin
        // Sort
        if ({exp1, frac1} > {exp2, frac2})
        begin
            frac_big = frac1;
            frac_small = frac2;
            sign_big = sign1;
            sign_small = sign2;
            exp_big = exp1;
            exp_small = exp2;
        end
        else
        begin
            frac_big = frac2;
            frac_small = frac1;
            sign_big = sign2;
            sign_small = sign1;
            exp_big = exp2;
            exp_small = exp1;
        end

        // Align
        guard = 1'b0;
        round = 1'b0;
        sticky = 1'b0;
        exp_diff = exp_big - exp_small;
        frac_small_aligned = frac_small >> exp_diff;
        case (exp_diff) // guard takes bit just before, roundb after, sticky OR of everything after
            0:
            1:
                guard  = frac_small[0];
            2:
                guard  = frac_small[1];
                roundb = frac_small[0];
            default:
                guard  = frac_small[exp_diff-1];
                roundb = frac_small[exp_diff-2];
                sticky = |frac_small[exp_diff-3:0];
        endcase

        // Add/Sub
        if (sign_big == sign_small)
        begin
            frac_sum = {1'b0, frac_big} + {1'b0, frac_small};
        end
        else
        begin
            frac_sum = {1'b0, frac_big} - {1'b0, frac_small};
        end

        // Normalize
        if (frac_sum[7])
            num_leading_zeros = 3'o0;
        else if (frac_sum[6])
            num_leading_zeros = 3'o1;
        else if (frac_sum[5])
            num_leading_zeros = 3'o2;
        else if (frac_sum[4])
            num_leading_zeros = 3'o3;
        else if (frac_sum[3])
            num_leading_zeros = 3'o4;
        else if (frac_sum[2])
            num_leading_zeros = 3'o5;
        else if (frac_sum[1])
            num_leading_zeros = 3'o6;
        else
            num_leading_zeros = 3'o7;

        if (frac_sum[8]) // carryout
        begin
            exp_sum = exp_big + 0'b1;
            frac_sum_adj = frac_sum[8:1];
        end
        else if (num_leading_zeros > exp_big) // too small, zero
        begin
            exp_sum = 0;
            frac_sum_adj = 0;
        end
        else
        begin
            exp_sum = exp_big - num_leading_zeros;
            frac_sum_adj = exp_sum << num_leading_zeros;
        end

        // result must be >= 0.5, roundb/sticky 1 means above, else only round if odd
        if (guard && (roundb || sticky || frac_sum_adj[0]))
        begin
            {round_carry, frac_sum_adj} = frac_sum_adj + 1'b1;

            if (round_carry)
            begin
                exp_sum      = exp_sum + 1;
                frac_sum_adj = frac_sum_adj >> 1;
            end
        end
    end

    assign sign_out = sign_big;
    assign exp_out = exp_sum;
    assign frac_out = frac_sum_adj;

endmodule
