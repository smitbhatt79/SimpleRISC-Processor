module ALU (
    input  [31:0] a, b, d,
    input  [4:0]  type, sel,
    output reg [31:0] result
);
    // intermediate results
    wire [31:0] add_sum, sub_diff;
    wire carry, borrow;
    reg  [1:0]  cmp_flags;  // [1]=GT, [0]=EQ

    add1 add_u (.a (a), .b (b), .c_in (1'b0), .sum (add_sum), .c_out(carry));
    sub1 sub_u (.a (a), .b (b), .b_in (1'b0), .diff (sub_diff), .b_out(borrow));

    // compute result based on control code using if-else
    always @* begin
        if (type == 5'd0)
            result = add_sum;
        else if (type == 5'd1)
            result = sub_diff;
        else if (type == 5'd2)
            result = a * b;
        else if (type == 5'd3)
            result = (b != 0) ? (a / b) : 32'd0;
        else if (type == 5'd4)
            result = (b != 0) ? (a % b) : 32'd0;
        else if (type == 5'd5)
            result = (a == b) ? 32'd0 :
                     (a < b) ? -32'd1 : 32'd1;
        else if (type == 5'd6)
            result = a & b;
        else if (type == 5'd7)
            result = a | b;
        else if (type == 5'd8)
            result = ~a;
        else if (type == 5'd9)
            result = a << b;
        else if (type == 5'd10)
            result = a >> b;
        else if (type == 5'd11)
            result = a >>> b;
        else
            result = 32'd0;
    end

    // update compare flags: bit0 = EQ, bit1 = GT
    always @* begin
        cmp_flags = 2'b00;
        if (a == b)
            cmp_flags[0] = 1'b1;
        else if (a > b)
            cmp_flags[1] = 1'b1;
    end
endmodule
