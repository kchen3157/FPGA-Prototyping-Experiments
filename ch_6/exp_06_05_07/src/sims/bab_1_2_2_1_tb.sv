`timescale 1 ns/10 ps


module bab_1_2_2_1_tb;

    // ********** Parameters **********
    localparam CLK_PERIOD = 10; // 10 ns -> 100 MHz

    // ********** DUT IO **********
    logic i_clk, i_rst;
    logic i_start, i_clear;
    logic [5:0] i_n;

    logic o_done;
    logic [17:0] o_val;

    // ********** DUT Instantiation **********
    bab_1_2_2_1 dut_bab_1_2_2_1
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
            i_clear = 1'b0;
            repeat(2) @(posedge i_clk);
            i_rst = 1'b0;
            repeat(2) @(posedge i_clk);
        end
    endtask

    task automatic start();
        begin            
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
            @(posedge i_clk);
        end
    endtask

    task automatic clear();
        begin            
            @(posedge i_clk);
            i_clear = 1'b1;
            @(posedge i_clk);
            i_clear = 1'b0;
            @(posedge i_clk);
        end
    endtask

    task automatic set_input(logic [5:0] n);
        begin
            i_n = n;
        end
    endtask

    initial
    begin
        set_input(0);
        reset();
        
        for (int i = 0, logic [5:0] n = 0; i <= 6'b111111; i++)
        begin
            set_input(n);
            start();
            wait(o_done === 1'b1);
            clear();
            n++;
        end

        repeat(3) @(posedge i_clk);
        $stop;
    end


endmodule