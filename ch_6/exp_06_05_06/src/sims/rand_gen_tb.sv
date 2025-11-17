// Testbench for Random Number Generator (rand_gen)
//

`timescale 1 ns/10 ps

module rand_gen_tb;

    // ********** Parameters **********
    localparam CLK_FREQ = 100_000_000;
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** UUT IO **********
    logic i_clk, i_rst;
    logic i_generate;

    logic [31:0] i_seed;
    logic [31:0] i_upper;
    logic [31:0] i_lower;

    logic o_ready;
    logic o_done;
    logic o_invalid;
    logic [31:0] o_val;

    // ********** DUT Instantiation **********
    rand_gen dut_rand_gen
        (.*);

    // ********** Clockgen **********
    initial i_clk = 1'b0;
    always 
    begin
        #(CLK_PERIOD/2);
        i_clk = ~i_clk;
    end

    // ********** Testbench Tasks **********
    task automatic reset();
        begin
            i_rst = 1'b1;
            i_generate = 1'b0;
            i_seed = '0;
            i_upper = '0;
            i_lower = '0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic wait_ready();
    begin
        @(posedge i_clk);
        wait (o_ready == 1'b1);
        @(posedge i_clk);
    end
    endtask

    task automatic do_rand_transaction(
        input   logic [31:0]    seed,
        input   logic [31:0]    lower,
        input   logic [31:0]    upper,
        input   bit             expect_invalid
    );
        int unsigned cycle_count;
    begin
        $display("\tInfo: [%0t] Testing (seed=%h, lower=%0d, upper=%0d, expect_invalid=%0b)",
                 $time, seed, lower, upper, expect_invalid);

        wait_ready();

        i_seed = seed;
        i_lower = lower;
        i_upper = upper;

        // Start rand_gen
        i_generate = 1'b1;
        @(posedge i_clk)
        i_generate = 1'b0;
        @(posedge i_clk)

        // Check if invalid (should be asserted one clk cycle later if invalid)
        if (expect_invalid)
        begin
            if (o_invalid !== 1'b1)
            begin
                $error("\t[%0t] o_invalid did not assert with invalid input", $time);
            end
            return;
        end
        else
        begin
            if (o_invalid == 1'b1)
            begin
                $error("\t[%0t] o_invalid did not assert with invalid input", $time);
            end
        end

        // Valid and invalid deasserted, let's wait for o_done assertion.
        cycle_count = 0;
        while (o_done == 1'b0 && cycle_count < 1000)
        begin
            @(posedge i_clk);
            cycle_count++;
        end
        if (cycle_count >= 1000)
        begin
            $error("\t[%0t] timeout, o_ready/o_done did not reassert", $time);
            return;
        end

        // Now verify the values
        if ($isunknown(o_val))
        begin
            $error("\t[%0t] o_val=%0d nonbinary expression detected", $time, o_val);
        end
        else if (o_val < lower || o_val > upper)
        begin
            $error("\t[%0t] o_val=%0d out of range [%0d, %0d]", $time, o_val, lower, upper);
        end
        else
        begin
            $display("\tInfo: [%0t] got o_val=%0d in range [%0d, %0d]", $time, o_val, lower, upper);
        end

    end
    endtask

    initial
    begin
        reset();

        $display("Info: Beginning constant tests");
        do_rand_transaction(32'h0000_0001, 32'd0, 32'd9, 0);

        do_rand_transaction(32'hDEAD_BEEF, 32'd10, 32'd100, 0);

        do_rand_transaction(32'h2349_3219, 32'd42, 32'd42, 1);

        do_rand_transaction(32'h2839_1482, 32'd10, 32'd5, 1);
    
        for (int i = 0; i < 10; i++)
        begin
            logic [31:0] lower;
            logic [31:0] upper;
            logic [31:0] seed;

            seed = $urandom();
            lower = $urandom_range(0, 1000);
            upper = lower + $urandom_range(1, 1000);
            $display("Info: [%0t] RANDOM TEST (seed=%h, lower=%0d, upper=%0d)",
                 $time, seed, lower, upper);
            for (int i = 0; i < 3; i++)
            begin
                do_rand_transaction(seed, lower, upper, 0);
            end
        end

        // test for reaction timer usecase, between 2000 and 15000 ms
        begin
            logic [31:0] seed;
            seed = $urandom();
            $display("Info: [%0t] CONSTANT TEST (seed=%0d, lower=2000, upper=15000)", $time, seed);
            for (int i = 0; i < 20; i++)
            begin
                do_rand_transaction(seed, 2000, 15000, 0);
            end
        end

        
        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end
    
    
endmodule