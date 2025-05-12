module MUX (
    input  [31:0] ip0,
    input  [31:0] ip1,
    input         sel,
    output [31:0] op
);
    assign op = sel ? ip1 : ip0;
endmodule

module MUX_2select(
    input  [31:0] ip0, ip1, ip2,
    input         sel1, sel2,
    output reg [31:0] op
);
    always @(*) begin
        case ({sel1, sel2})
            2'b10: op = ip2;
            2'b01: op = ip1;
            default: op = ip0;
        endcase
    end
endmodule

module MUX_Multiary(
    input  [3:0] ip0,
    input  [3:0] ip1,
    input        sel,
    output [3:0] op
);
    assign op = sel ? ip1 : ip0;
endmodule


module add1 (
    input  [31:0] a, b,
    input         c_in,
    output [31:0] sum,
    output        c_out
);
    wire [31:0] s, c;

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : adder_loop
            if (i == 0)
                adder a0(a[i], b[i], s[i], c_in, c[i]);
            else
                adder ai(a[i], b[i], s[i], c[i-1], c[i]);
        end
    endgenerate

    adder a31(a[31], b[31], s[31], c[30], c_out);
    assign sum = s;
endmodule


module adder(
    input  a, b,
    output sum,
    input  c_in,
    output c_out
);
    wire x1, x2, a1, a2;

    xor (x1, a, b);
    xor (sum, x1, c_in);
    and (a1, x1, c_in);
    and (a2, a, b);
    or  (c_out, a1, a2);
endmodule

module sub1(
    input  [31:0] a, b,
    input         b_in,
    output [31:0] diff,
    output        b_out
);
    wire [31:0] b_arr;

    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : sub_loop
            if (i == 0)
                subtractor s0(a[i], b[i], diff[i], b_in, b_arr[i]);
            else
                subtractor si(a[i], b[i], diff[i], b_arr[i-1], b_arr[i]);
        end
    endgenerate

    subtractor s31(a[31], b[31], diff[31], b_arr[30], b_arr[31]);
    assign b_out = b_arr[31];
endmodule


module subtractor(
    input  a, b,
    output diff,
    input  b_in,
    output b_out
);
    wire t1, t2, t3, t4;

    xor (t1, a, b);
    xor (diff, t1, b_in);
    and (t2, ~a, b);
    and (t3, ~a, b_in);
    and (t4, b, b_in);
    or  (b_out, t2, t3, t4);
endmodule
