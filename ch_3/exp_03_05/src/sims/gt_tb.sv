

module gt_f_tb;
    logic [12:0] a_i;
    logic [12:0] b_i;
    logic agtb_o;

    gt_f gt_f_uut
        (.a(a_i), .b(b_i), .agtb(agtb_o));

    initial
    begin
        // 0 !> 0
        a_i = 13'd0;
        b_i = 13'd0;
        # 10;

        // +max > +min
        a_i = 13'b0_1111_11111111;
        b_i = 13'b0_0001_10000000;
        # 10;

        // -max !> +min
        a_i = 13'b1_1111_11111111;
        b_i = 13'b0_0001_10000000;
        # 10;

        // +10010011E0101 !> +10010100E0101
        a_i = 13'b0_0101_10010011;
        b_i = 13'b0_0101_10010100;
        # 10;


        $stop;
    end


endmodule