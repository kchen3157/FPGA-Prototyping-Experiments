`timescale 1 ns/10 ps

module bcd_inc_tb;

    logic [7:0] x_i, y_o;

    bcd_inc bcd_inc_uut
        (.x(x_i), .y(y_o));

    initial
    begin
        for (int i = 0; i < 2**7; i = i + 1)
        begin
            if ((i[3:0] <= 4'b1001 && i[7:4] <= 4'b1001))
            begin
                x_i = i;
                # 10;
            end
        end
        $stop;
    end

endmodule
