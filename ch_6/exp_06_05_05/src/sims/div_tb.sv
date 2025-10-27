
`timescale 1 ns/10 ps


module div_tb;

    // ********** Parameters **********
    localparam WIDTH = 32; // Be able to handle numbers up to 1E9
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** DUT IO **********
    logic i_clk, i_rst;
    logic i_start;
    logic [WIDTH-1:0] i_dividend, i_divisor;
    logic o_ready, o_done;
    logic [WIDTH-1:0] o_quotient, o_remain;

    // ********** DUT Instantiation **********
    div 
        #(
            .WIDTH(WIDTH)
        ) dut_div
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
            i_start = 1'b0;
            i_dividend = 0;
            i_divisor = 0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic start_division();
        begin
            wait(o_ready === 1'b1);
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
        end
    endtask

    task automatic set_inputs(logic [WIDTH-1:0] dividend, logic [WIDTH-1:0] divisor);
        begin
            i_dividend = dividend;
            i_divisor = divisor;
        end
    endtask

    task automatic verify
        (
            real    dividend,
            real    divisor
        );
        int diff;
        begin
            @(posedge o_done);

            $display("div_tb: Ran %0f/%0f, should be %0f, got %0d",
               dividend, divisor, (dividend/divisor), o_quotient);

            diff = (int'(dividend / divisor) - int'(o_quotient));
            if (diff < 0)
            begin
                diff = -diff;
            end
            assert(diff <= 1)
                else $error("div_tb: Mismatch on o_quotient: expected %0f got %0d", (dividend/divisor), o_quotient);
            

            wait(o_ready === 1'b1);
        end
    endtask

    initial
    begin
        reset();
        set_inputs(32'd1_000_000_000, 32'd1);
        start_division();
        verify(32'd1_000_000_000, 32'd1);

        set_inputs(32'd1_000_000_000, 32'd101);
        start_division();
        verify(32'd1_000_000_000, 32'd101);

        set_inputs(32'd1_000_000_000, 32'd6767);
        start_division();
        verify(32'd1_000_000_000, 32'd6767);

        set_inputs(32'd1_000_000_000, 32'd676767);
        start_division();
        verify(32'd1_000_000_000, 32'd676767);

        set_inputs(32'd1_000_000_000, 32'd999999);
        start_division();
        verify(32'd1_000_000_000, 32'd999999);

        // wait some more
        repeat(3) @(posedge i_clk);

        $stop;
    end


endmodule