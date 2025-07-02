`timescale 1 ns/10 ps

module barrel_shifter_16_tb;

    logic [15:0] test_a;
    logic [3:0] test_amt;
    logic test_lr;
    logic [15:0] test_y;

    barrel_shifter_rev_16 uut_barrel_shifter_rev_16
        (.a(test_a), .amt(test_amt), .lr(test_lr), .y(test_y));

    initial
    begin
        // RIGHT, LR = 1
        test_lr = 1'b1;

        test_a = 16'b0000000000000000;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 16'b0000000000000001;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 16'b0010010001100101;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // LEFT, LR = 0
        test_lr = 1'b0;

        test_a = 16'b0000000000000000;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 16'b0000000000000001;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 16'b0010010001100101;
        for (int i = 0; i <= 4'b1111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // stop tb
        $stop;
    end
endmodule

module barrel_shifter_32_tb;

    logic [31:0] test_a;
    logic [4:0] test_amt;
    logic test_lr;
    logic [31:0] test_y;

    barrel_shifter_rev_32 uut_barrel_shifter_rev_32
        (.a(test_a), .amt(test_amt), .lr(test_lr), .y(test_y));

    initial
    begin
        // RIGHT, LR = 1
        test_lr = 1'b1;

        test_a = 32'b00000000000000000000000000000000;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 32'b00000000000000000000000000000001;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 32'b01001010111000100010010001100101;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // LEFT, LR = 0
        test_lr = 1'b0;

        test_a = 32'b00000000000000000000000000000000;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 32'b00000000000000000000000000000001;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        test_a = 32'b01001010111000100010010001100101;
        for (int i = 0; i <= 5'b11111; i = i + 1)
        begin
            test_amt = i;
            # 10;
        end

        // stop tb
        $stop;
    end
endmodule
