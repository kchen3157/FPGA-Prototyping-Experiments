module decoder_2_4
    (
        input logic en,
        input logic [1:0] a,
        output logic [3:0] bcode
    );

    wire [3:0] en_w;

    assign en_w[0] = (~a[1] & ~a[0]);
    assign en_w[1] = (~a[1] &  a[0]);
    assign en_w[2] = ( a[1] & ~a[0]);
    assign en_w[3] = ( a[1] &  a[0]);

    assign bcode[0] = (en & en_w[0]);
    assign bcode[1] = (en & en_w[1]);
    assign bcode[2] = (en & en_w[2]);
    assign bcode[3] = (en & en_w[3]);

endmodule

module decoder_3_8
    (
        input logic en,
        input logic [2:0] a,
        output logic [7:0] bcode
    );

    wire [3:0] decoder_bcode_hi_w, decoder_bcode_lo_w;

    decoder_2_4 decoder_2_4_hi
        (.en(a[2]), .a(a[1:0]), .bcode(decoder_bcode_hi_w));

    decoder_2_4 decoder_2_4_lo
        (.en(!a[2]), .a(a[1:0]), .bcode(decoder_bcode_lo_w));
    
    assign bcode[0] = decoder_bcode_lo_w[0] & en;
    assign bcode[1] = decoder_bcode_lo_w[1] & en;
    assign bcode[2] = decoder_bcode_lo_w[2] & en;
    assign bcode[3] = decoder_bcode_lo_w[3] & en;
    
    assign bcode[4] = decoder_bcode_hi_w[0] & en;
    assign bcode[5] = decoder_bcode_hi_w[1] & en;
    assign bcode[6] = decoder_bcode_hi_w[2] & en;
    assign bcode[7] = decoder_bcode_hi_w[3] & en;

endmodule