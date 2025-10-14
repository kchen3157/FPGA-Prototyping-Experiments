// Testbench for Fibonacci Operator/Generator
//
// TESTED INPUT(i_gen_amt): 8 Bit Binary 0d000->0d255 (0x00->0xFF)
// TESTED OUTPUT(o_final): 4 Byte Binary 0d0000->0d9999 (0x0000->0x270F)
// 
// SIMULATION TIME: ~10 us

`timescale 1 ns/10 ps

module fib_operator_tb;

    localparam CLOCK_T = 10; // 10 ns -> 100 MHz

    logic i_clk, i_rst;
    logic i_start;
    logic [7:0] i_gen_amt;
    logic o_ready, o_done_tick;
    logic [15:0] o_final;
    logic o_overflow;


    // Unit Instantiation
    fib_operator uut_fib_operator
        (.*);

    always // generate clock
    begin
        i_clk = 1'b1;
        #(CLOCK_T/2);
        i_clk = 1'b0;
        #(CLOCK_T/2);
    end

    initial
    begin
        // first reset
        i_rst = 1'b1;
        i_start = 1'b0;
        i_gen_amt = 5'h00;
        @(posedge i_clk);
        i_rst = 1'b0;
        
        // wait some
        repeat(3) @(posedge i_clk);
        
        for (int i = 8'h00; i <= 8'hFF; i = i + 1)
        begin
            wait (o_ready == 1'b1);
            i_gen_amt = i;
            @(posedge i_clk);
            i_start = 1'b1;
            @(posedge i_clk);
            i_start = 1'b0;
            wait (o_done_tick == 1'b1);
        end

        // wait some
        repeat(3) @(posedge i_clk);
    
        $stop;
    end
    
    
endmodule