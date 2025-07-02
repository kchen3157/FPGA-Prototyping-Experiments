`timescale 1 ns/10 ps

module barrel_shifter_tb;

    logic [7:0] test_a;
    logic [2:0] test_amt;
    logic test_lr;
    logic [7:0] test_y;

    barrel_shifter_multi uut_barrel_shifter_multi
        (.a(test_a), .amt(test_amt), .lr(test_lr), .y(test_y));

    initial
    begin
        // RIGHT, LR = 1
        test_lr = 1'b1;

        test_a = 7'b0000000;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 7'b0000001;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 7'b0101011;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // LEFT, LR = 0
        test_lr = 1'b0;

        test_a = 7'b0000000;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 7'b0000001;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 7'b0101011;
        for (int i = 0; i <= 3'b111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // stop tb
        $stop;
    end
endmodule
