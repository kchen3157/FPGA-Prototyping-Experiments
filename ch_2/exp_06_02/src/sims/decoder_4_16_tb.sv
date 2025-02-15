`timescale 1 ns/10 ps

module decoder_4_16_testbench;
    
    logic test_en_in;
    logic [3:0] test_a_in;
    logic [15:0] test_bcode_out;

    decoder_4_16 uut
        (.en(test_en_in), .a(test_a_in), .bcode(test_bcode_out));
    initial
    begin
        // EN
        test_en_in = 1'b1;

        test_a_in = 4'b0000;
        # 200;
        test_a_in = 4'b0001;
        # 200;
        test_a_in = 4'b0010;
        # 200;
        test_a_in = 4'b0011;
        # 200;
        test_a_in = 4'b0100;
        # 200;
        test_a_in = 4'b0101;
        # 200;
        test_a_in = 4'b0110;
        # 200;
        test_a_in = 4'b0111;
        # 200;
        test_a_in = 4'b1000;
        # 200;
        test_a_in = 4'b1001;
        # 200;
        test_a_in = 4'b1010;
        # 200;
        test_a_in = 4'b1011;
        # 200;
        test_a_in = 4'b1100;
        # 200;
        test_a_in = 4'b1101;
        # 200;
        test_a_in = 4'b1110;
        # 200;
        test_a_in = 4'b1111;
        # 200;

        // !EN
        test_en_in = 1'b0;

        test_a_in = 4'b0000;
        # 200;
        test_a_in = 4'b0001;
        # 200;
        test_a_in = 4'b0010;
        # 200;
        test_a_in = 4'b0011;
        # 200;
        test_a_in = 4'b0100;
        # 200;
        test_a_in = 4'b0101;
        # 200;
        test_a_in = 4'b0110;
        # 200;
        test_a_in = 4'b0111;
        # 200;
        test_a_in = 4'b1000;
        # 200;
        test_a_in = 4'b1001;
        # 200;
        test_a_in = 4'b1010;
        # 200;
        test_a_in = 4'b1011;
        # 200;
        test_a_in = 4'b1100;
        # 200;
        test_a_in = 4'b1101;
        # 200;
        test_a_in = 4'b1110;
        # 200;
        test_a_in = 4'b1111;
        # 200;

        // stop sim
        $stop;
    end
endmodule