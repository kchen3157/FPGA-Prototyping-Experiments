`timescale 1 ns/10 ps

module decoder_2_4_testbench;
    
    logic test_en_in;
    logic [1:0] test_a_in;
    logic [3:0] test_bcode_out;

    decoder_2_4 uut
        (.en(test_en_in), .a(test_a_in), .bcode(test_bcode_out));
    initial
    begin
        // EN
        test_en_in = 1'b1;

        test_a_in = 2'b00;
        # 200;
        test_a_in = 2'b01;
        # 200;
        test_a_in = 2'b10;
        # 200;
        test_a_in = 2'b11;
        # 200;


        // !EN
        test_en_in = 1'b0;

        test_a_in = 2'b00;
        # 200;
        test_a_in = 2'b01;
        # 200;
        test_a_in = 2'b10;
        # 200;
        test_a_in = 2'b11;
        # 200;

        // stop sim
        $stop;
    end
endmodule