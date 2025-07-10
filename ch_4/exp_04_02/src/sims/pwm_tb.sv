module pwm_gen_tb;

    localparam CLOCK_PER = 10;

    logic i_clk, i_rst;
    logic [3:0] i_w;
    logic o_q;
    logic [3:0] o_test_duty_count;

    pwm_gen pwm_gen_uut
        (.*);

    // generate clock
    always
    begin
        i_clk = 1'b1;
        #(CLOCK_PER/2);
        i_clk = 1'b0;
        #(CLOCK_PER/2);
    end

    initial
    begin
        i_w = 4'hF;
        i_rst = 1'b1;
        repeat(3) @(posedge i_clk);
        i_rst = 1'b0;
        for (int i = 4'hF; i >= 0; i = i - 1)
        begin
            i_w = i;
            repeat(50) @(posedge i_clk);
        end
        $stop;
    end
endmodule
