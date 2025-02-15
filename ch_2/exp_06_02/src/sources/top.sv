module top
    (
        input logic [1:0] sw,
        output logic [3:0] led
    );

    wire en_w;

    assign en_w = 1'b1;

    decoder_2_4 decoder_2_4_inst
        (.en(en_w), .a(sw), .bcode(led));

endmodule
