module top
    (
        input logic [2:0] sw,
        output logic [7:0] led
    );

    wire en_w;

    assign en_w = 1'b1;

    decoder_3_8 decoder_3_8_inst
        (.en(en_w), .a(sw), .bcode(led));

endmodule
