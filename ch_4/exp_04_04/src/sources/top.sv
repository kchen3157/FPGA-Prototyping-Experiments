// FMC MEZZANINE

// MSPI HEADERS
// A  B  C  D  E          F   G  DP
// 9N 3P 9P 8N CLK0_M2C_N 12P 8P 5N

// I2S HEADERS
// L1 L2 L3  L4
// 2P 2N 4P CLK1_M2C_N

// LED SOCKET

// L1 A  F  L2 L3 B
// 12 11 10 9  8  7

// 1  2  3  4  5  6
// E  D  DP C  G  L4


// SOCKET -> FMC
// 1 -> CLK0_M2C_N (MSPI[5])
// 2 -> 8N (MSPI[4])
// 3 -> 5N (MSPI[8])
// 4 -> 9P (MSPI[3])
// 5 -> 8P (MSPI[7])
// 6 -> CLK1_M2C_N (I2S[4])
// 7 -> 3P (MSPI[2])
// 8 -> 4P (I2S[3])
// 9 -> 2N (I2S[2])
// 10 -> 12P (MSPI[6])
// 11 -> 9N (MSPI[1])
// 12 -> 2P (I2S[1])


module top
    (
        input   logic clk, cpu_resetn,
        input   logic [1:0] sw,
        output  logic [1:0] set_vadj,
        output  logic vadj_en,
        output  logic fmc_clk0_m2c_n,
        output  logic fmc_clk1_m2c_n,
        output  logic fmc_la_2n,
        output  logic fmc_la_2p,
        output  logic fmc_la_3p,
        output  logic fmc_la_4p,
        output  logic fmc_la_5n,
        output  logic fmc_la_8n,
        output  logic fmc_la_8p,
        output  logic fmc_la_9n,
        output  logic fmc_la_9p,
        output  logic fmc_la_12p
    );

    // Set v_adj to 1.8V
    assign vadj_en = 1'b1;
    assign set_vadj = 2'b01;

    // Create sseg/ldsel nets
    logic [7:0] w_sseg_n;
    logic [3:0] w_ldsel;

    assign {fmc_la_5n, fmc_la_8p, fmc_la_12p, fmc_clk0_m2c_n,
            fmc_la_8n, fmc_la_9p, fmc_la_3p, fmc_la_9n} = w_sseg_n;
    assign  {fmc_la_2p, fmc_la_2n, fmc_la_4p, fmc_clk1_m2c_n} = w_ldsel;

    // Create slower clock for display mux
    localparam SLOW_CLK_N = 15; // 100 MHz / 2^15 ~= 3.1 kHz
    logic [SLOW_CLK_N-1:0] r_clk_count;
    logic w_clk_slow;
    assign w_clk_slow = r_clk_count[SLOW_CLK_N-1];
    always @(posedge clk)
    begin
        r_clk_count <= r_clk_count + 1;
    end

    // Create 72bpm (3.6tps) clock for pattern
    localparam DVSR = 27_777_778; // 3.6tps -> T = 1/3.6 s ~= 27,777,778 * 10ns
    logic [$clog2(DVSR)-1:0] r_pat_clk_count;
    logic w_pat_clk;
    assign w_pat_clk = (r_pat_clk_count == DVSR - 1) ? 1'b1 : 1'b0;
    always @(posedge clk)
    begin
        r_pat_clk_count <= r_pat_clk_count + 1;
    end

    logic [7:0] w_sseg_map_n [3:0];


    heartbeat_sseg u_heartbeat_sseg
        (.i_clk(w_pat_clk), .i_rst(~cpu_resetn),
         .o_sseg_n(w_sseg_map_n));

    led_4_1_mux u_led_4_1_mux
        (.i_clk(w_clk_slow), .i_reset(~cpu_resetn), .i_in_n(w_sseg_map_n),
         .o_ldsel(w_ldsel), .o_sseg_n(w_sseg_n));

endmodule
