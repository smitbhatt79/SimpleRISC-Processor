module memory_unit (
    input isLd,                     
    input isSt,                     
    input [31:0] aluResult,         
    input [31:0] op2,               
    output reg [31:0] ldResult      
);

    reg [31:0] mar;                 
    reg [31:0] mdr;                 
    reg [31:0] data_memory [0:1023]; 

    always @(*) begin
        mar = aluResult;

        if (isSt) begin
            mdr = op2;
            data_memory[mar[11:2]] = mdr;
        end

        if (isLd) begin
            mdr = data_memory[mar[11:2]];
            ldResult = mdr;
        end else begin
            ldResult = 0;
        end
    end

endmodule

module aftermux (
    input [31:0] aluResult,
    input [31:0] ldResult,
    input [31:0] pc,
    output [31:0] data,
    input isLd,
    input isCall
);

    wire [31:0] pc_plus_4 = pc + 4;

    MUX_2select m1 (
        .ip0(aluResult),
        .ip1(ldResult),
        .ip2(pc_plus_4),
        .sel1(isLd),
        .sel2(isCall),
        .op(data)
    );

endmodule
