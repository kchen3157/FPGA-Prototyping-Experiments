`timescale 1 ns/10 ps

module decoder_3_8_testbench;
    
    logic test_en_in;
    logic [2:0] test_a_in;
    logic [7:0] test_bcode_out;

    decoder_3_8 uut
        (.en(test_en_in), .a(test_a_in), .bcode(test_bcode_out));
    initial
    begin
        // EN
        test_en_in = 1'b1;

        test_a_in = 3'b000;
        # 200;
        test_a_in = 3'b001;
        # 200;
        test_a_in = 3'b010;
        # 200;
        test_a_in = 3'b011;
        # 200;
        test_a_in = 3'b100;
        # 200;
        test_a_in = 3'b101;
        # 200;
        test_a_in = 3'b110;
        # 200;
        test_a_in = 3'b111;
        # 200;

        // !EN
        test_en_in = 1'b0;

        test_a_in = 3'b000;
        # 200;
        test_a_in = 3'b001;
        # 200;
        test_a_in = 3'b010;
        # 200;
        test_a_in = 3'b011;
        # 200;
        test_a_in = 3'b100;
        # 200;
        test_a_in = 3'b101;
        # 200;
        test_a_in = 3'b110;
        # 200;
        test_a_in = 3'b111;
        # 200;

        // stop sim
        $stop;
    end
endmodule