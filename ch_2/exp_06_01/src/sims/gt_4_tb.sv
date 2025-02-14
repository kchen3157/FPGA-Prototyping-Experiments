`timescale 1 ns/10 ps


module  gt_4_sop_testbench;

    logic [3:0] test_a_in, test_b_in;
    logic test_agtb_out;

    // uut instantiation
    gt_4_sop uut
        (.a(test_a_in), .b(test_b_in), .agtb(test_agtb_out));
    
    initial
    begin
        //******* X > 0000 ********
        test_b_in = 4'b0000;

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

        //******* X > 0001 ********
        test_b_in = 4'b0001;

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

        //******* X > 0010 ********
        test_b_in = 4'b0010;

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


        //******* X > 0011 ********
        test_b_in = 4'b0011;

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

        //******* X > 0100 ********
        test_b_in = 4'b0100;

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


        //******* X > 0101 ********
        test_b_in = 4'b0101;

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


        //******* X > 0110 ********
        test_b_in = 4'b0110;

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


        //******* X > 0111 ********
        test_b_in = 4'b0111;

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


        //******* X > 1000 ********
        test_b_in = 4'b1000;

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


        //******* X > 1001 ********
        test_b_in = 4'b1001;

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



        //******* X > 1010 ********
        test_b_in = 4'b1010;

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


        //******* X > 1011 ********
        test_b_in = 4'b1011;

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


        //******* X > 1100 ********
        test_b_in = 4'b1100;

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




        //******* X > 1101 ********
        test_b_in = 4'b1101;

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



        //******* X > 1110 ********
        test_b_in = 4'b1110;

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


        //******* X > 1111 ********
        test_b_in = 4'b1111;

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