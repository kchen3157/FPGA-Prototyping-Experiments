

module sseg4
    (
        input   logic i_clk, i_rst,
        input   logic [$clog2(9999)-1:0] i_bin,
        input   logic i_greeting                // When asserted, display "HI"

        output  logic [7:0] o_sseg_n
    );


endmodule