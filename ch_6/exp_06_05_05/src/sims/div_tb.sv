
timescale 1ns/1ps


module div_tb;

    // ********** Parameters **********
    parameter WIDTH = 27 // Be able to handle numbers up to 1E9

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
            i_signal = 1'b0;
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

    initial
    begin
        reset();
        set_inputs(27'd100_000_000, 27'd1);
        start_division();

        reset();
        set_inputs(27'd100_000_000, 27'd101);
        start_division();

        reset();
        set_inputs(27'd100_000_000, 27'd6767);
        start_division();

        reset();
        set_inputs(27'd100_000_000, 27'd676767);
        start_division();

        reset();
        set_inputs(27'd100_000_000, 27'd999999);
        start_division();

        // wait some more
        repeat(3) @(posedge i_clk);

        $stop();
    end


endmodule