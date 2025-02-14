`timescale 1 ns/10 ps


module  gt_2_sop_testbench;

    logic [1:0] test_a_in, test_b_in;
    logic test_aeqb_out;

    // uut instantiation
    eq_2_sop uut
        (.a(test_a_in), .b(test_b_in), .aeqb(test_aeqb_out));
    
    initial
    begin
        test_a_in = 2'b00;
        test_b_in = 2'b00;
        # 200;
        test_a_in = 2'b01;
        test_b_in = 2'b00;
        # 200;
        test_a_in = 2'b10;
        test_b_in = 2'b00;
        # 200;
        test_a_in = 2'b11;
        test_b_in = 2'b00;
        # 200;

        test_a_in = 2'b00;
        test_b_in = 2'b01;
        # 200;
        test_a_in = 2'b01;
        test_b_in = 2'b01;
        # 200;        
        test_a_in = 2'b10;
        test_b_in = 2'b01;
        # 200;
        test_a_in = 2'b11;
        test_b_in = 2'b01;
        # 200;

        test_a_in = 2'b00;
        test_b_in = 2'b10;
        # 200;
        test_a_in = 2'b01;
        test_b_in = 2'b10;
        # 200;
        test_a_in = 2'b10;
        test_b_in = 2'b10;
        # 200;  
        test_a_in = 2'b11;
        test_b_in = 2'b10;
        # 200;

        test_a_in = 2'b00;
        test_b_in = 2'b11;
        # 200;
        test_a_in = 2'b01;
        test_b_in = 2'b11;
        # 200;
        test_a_in = 2'b10;
        test_b_in = 2'b11;
        # 200;
        test_a_in = 2'b11;
        test_b_in = 2'b11;
        
        # 200;
        // stop sim
        $stop;
    end

endmodule