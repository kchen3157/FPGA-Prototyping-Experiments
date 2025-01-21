timescale 1 ns/10 ps


module  gt_2_sop_testbench;

    logic [1:0] test_a_in, test_b_in;
    logic test_agtb_out;

    // uut instantiation
    gt_2_sop uut
        (.a(test_a_in), .b(test_b_in), .agtb(test_agtb_out));
    
    initial
    begin
        // test vector 00 !> 00
        test_a_in = 2'b00
        test_b_in = 2'b00
        # 200;
        // test vector 01 > 00
        test_a_in = 2'b01
        test_b_in = 2'b00
        # 200;
        // test vector 10 > 00
        test_a_in = 2'b10
        test_b_in = 2'b00
        # 200;
        // test vector 11 > 00
        test_a_in = 2'b11
        test_b_in = 2'b00
        # 200;

        // test vector 00 !> 01
        test_a_in = 2'b00
        test_b_in = 2'b01
        # 200;
        // test vector 01 !> 01
        test_a_in = 2'b01
        test_b_in = 2'b01
        # 200;        
        // test vector 10 > 01
        test_a_in = 2'b10
        test_b_in = 2'b01
        # 200;
        // test vector 11 > 01
        test_a_in = 2'b11
        test_b_in = 2'b01
        # 200;

        // test vector 00 !> 10
        test_a_in = 2'b00
        test_b_in = 2'b10
        # 200;
        // test vector 01 !> 10
        test_a_in = 2'b01
        test_b_in = 2'b10
        # 200;
        // test vector 10 !> 10
        test_a_in = 2'b10
        test_b_in = 2'b10
        # 200;  
        // test vector 11 > 10
        test_a_in = 2'b11
        test_b_in = 2'b10
        # 200;

        // test vector 00 !> 11
        test_a_in = 2'b00
        test_b_in = 2'b11
        # 200;
        // test vector 01 !> 11
        test_a_in = 2'b01
        test_b_in = 2'b11
        # 200;
        // test vector 10 !> 11
        test_a_in = 2'b10
        test_b_in = 2'b11
        # 200;
        // test vector 11 !> 11
        test_a_in = 2'b11
        test_b_in = 2'b11
        # 200;
    end

endmodule