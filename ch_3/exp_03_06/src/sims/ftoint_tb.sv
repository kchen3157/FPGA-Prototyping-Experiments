// this tb only tests valid wholes

module float_to_int_tb;

    logic [7:0] a_i;
    logic [7:0] y_o;
    logic of_o, uf_o;

    logic [12:0] t;

    int_to_float int_to_float_uut
        (.a(a_i), .y(t));

    float_to_int float_to_int_uut
        (.a(t), .y(y_o), .of(of_o), .uf(uf_o));

    initial
    begin
        for (int i = 0; i < 256; i = i + 1)
        begin
            a_i = i;
            # 10;
        end

        $stop;
    end

endmodule