
module bcd_inc
    (
        input   logic [7:0] x,
        output  logic [7:0] y
    );

    logic [3:0] t [1:0];

    always_comb
    begin
        if (x[3:0] != 4'd9)
        begin
            t[0] = x[3:0] + 1;
            t[1] = x[7:4];
        end
        else if (x[7:4] != 4'd9)
        begin
            t[0] = 8'd0;
            t[1] = x[7:4] + 1;
        end
        else
        begin
            t[0] = 8'd0;
            t[1] = 8'd0;
        end
    end

    assign y = {t[1], t[0]};

endmodule