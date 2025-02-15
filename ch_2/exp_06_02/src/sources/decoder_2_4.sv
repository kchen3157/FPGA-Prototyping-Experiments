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

    assign bcode = (en & en_w);

endmodule