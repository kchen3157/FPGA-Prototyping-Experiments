`timescale 1 ns/10 ps



module sign_mag_add
    #(parameter N = 4)
    (
        input   logic [N-1:0] a, b,
        output  logic [N-1:0] sum
    );

    logic [N-1:0] max, min;
    logic [N-2:0] sum_mag;

    assign max = (a > b) ? a : b;
    assign min = (a > b) ? b : a;

    always_comb
    begin
        if (max[N-1] == min[N-1])
        begin
            sum_mag = (max[N-2:0] + min[N-2:0]);
        end
        else
        begin
            sum_mag = (max[N-2:0] - min[N-2:0]);
        end
    end

    assign sum = {max[N-1], sum_mag};

    
endmodule

// Listing 3.16
module sign_mag_add_book
    #(parameter N = 4)
    (
        input   logic [N-1:0] a, b,
        output  logic [N-1:0] sum
    );

    logic [N-2:0] mag_a, mag_b, mag_sum, max, min;
    logic sign_a, sign_b, sign_sum;

    always_comb
    begin
        mag_a = a[N-2:0];
        mag_b = b[N-2:0];
        sign_a = a[N-1];
        sign_b = b[N-1];

        if (mag_a > mag_b)
        begin
            max = mag_a;
            min = mag_b;
            sign_sum = sign_a;
        end
        else
        begin
            max = mag_b;
            min = mag_a;
            sign_sum = sign_b;
        end

        if (sign_a == sign_b)
        begin
            mag_sum = max + min;
        end
        else
        begin
            mag_sum = max - min;
        end

        sum = {sign_sum, mag_sum};
    end
endmodule


module top
    #(parameter N = 4)
    (
        input   logic [N-1:0] a, b, a_book, b_book,
        output  logic [N-1:0] sum,
        output  logic [N-1:0] sum_book
    );


    sign_mag_add u_sign_mag_add
        (.a(a), .b(b), .sum(sum));

    sign_mag_add_book u_sign_mag_add_book
        (.a(a_book), .b(b_book), .sum(sum_book));


endmodule