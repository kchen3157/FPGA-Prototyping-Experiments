

module int_to_float_tb;

    logic [7:0] a_in;
    logic [12:0] y_out;

    int_to_float int_to_float_uut
        (.a(a_in), .y(y_out));

    initial
    begin
        for (int i = 0; i < 256; i = i + 1)
        begin
            a_in = i;
            # 10;
        end
    end


endmodule