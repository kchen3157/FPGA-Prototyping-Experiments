module square_wave_gen_tb;

    localparam CLOCK_PER = 10;

    logic i_clk, i_rst;
    logic [3:0] i_m, i_n;
    logic o_q;

    square_wave_gen square_wave_gen_uut
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
        i_m = 4'h1;
        i_n = 4'h1;
        i_rst = 1'b1;
        repeat(3) @(posedge i_clk);
        i_rst = 1'b0;
        repeat(40) @(posedge i_clk);
        i_m = 4'h5;
        i_n = 4'h5;
        repeat(200) @(posedge i_clk);
        i_m = 4'hF;
        i_n = 4'hF;
        repeat(600) @(posedge i_clk);
        i_n = 4'h2;
        repeat(350) @(posedge i_clk);
        i_m = 4'h0;
        i_n = 4'h0;
        repeat(50) @(posedge i_clk);

        $stop;
    end

    
endmodule