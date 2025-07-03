module barrel_shifter
    #(parameter N = 3)
    (
        input logic [2**N-1:0] a,
        input logic [N-1:0] amt,
        input logic lr,
        output logic [2**N-1:0] y
    );

    logic [2**N-1:0] tr;
    logic [2**N-1:0] t [N:0];

    generate
        genvar i;

        for (i = 0; i < (2**N); i++)
        begin
            assign t[0][i] = (lr) ? a[i] : a[(2**N-1)-i];
        end

        for (i = 0; i < N; i++)
        begin
            assign t[i+1] = amt[i] ? {t[i][2**i-1:0], t[i][2**N-1:2**i]} : t[i];
        end

        for (i = 0; i < (2**N); i++)
        begin
            assign y[i] = (lr) ? t[N][i] : t[N][(2**N-1)-i];
        end

    endgenerate

endmodule