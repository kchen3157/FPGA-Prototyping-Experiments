`timescale 1 ns/10 ps

module sign_mag_add_tb
    #(parameter N = 4);
    
    logic [N-1:0] test_a_in, test_b_in;
    logic [N-1:0] test_sum_out;

    sign_mag_add_book sign_mag_add_uut
        (.a(test_a_in), .b(test_b_in), .sum(test_sum_out));
    initial
    begin
        test_a_in = 4'b0000;
        test_b_in = 4'b0000;
        # 200;
        test_a_in = 4'b0100;
        test_b_in = 4'b0001;
        # 200;
        test_a_in = 4'b1100; // -4, 0xC
        test_b_in = 4'b0010; // 2, 0x2
        # 200; // -2 (0b1010, 0xA) 
        test_a_in = 4'b1001; // -1, 0x9
        test_b_in = 4'b1010; // -2, 0xA
        # 200; // -3 (0b1011, 0xB)
        test_a_in = 4'b0111; // 7, 0x7
        test_b_in = 4'b0010; // 1, 0x1
        # 200; // 1 (0b0001, 0x1)
        test_a_in = 4'b1111; // -7, 0xF
        test_b_in = 4'b1010; // -2, 0xA
        # 200; // -1 (0b1001, 0x9)
        test_a_in = 4'b1010; // -2, 0xA
        test_b_in = 4'b0011; // 3, 0x3
        # 200; // 1 (0b0001, 0x1)
        // stop sim

        $stop;
    end
endmodule