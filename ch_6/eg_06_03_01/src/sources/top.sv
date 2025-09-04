module top
    (
        input   logic clk,
        input   logic cpu_resetn,
        input   logic btn,
        input   logic [4:0] sw,
        output  logic [3:0] ja,
        output  logic [3:0] jb,
        output  logic [3:0] jc
    );

    localparam SLOW_CLK_N = 15;
    logic [SLOW_CLK_N-1:0] r_clk_count;
    logic w_clk_slow;
    assign w_clk_slow = r_clk_count[SLOW_CLK_N-1];
    always_ff @(posedge clk)
    begin
        r_clk_count <= r_clk_count + 1;
    end

    assign ja[0] = w_clk_slow;

    logic [19:0] fib;
    assign jb = fib[3:0];
    assign jc = fib[7:4];

    fib u_fib
        (.i_clk(w_clk_slow), .i_rst(~cpu_resetn), .i_start(btn), .i_gen_amt(sw),
         .o_ready(ja[1]), .o_done_tick(ja[2]), .o_final(fib));

endmodule
