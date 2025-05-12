module reg_write (
    input clk,
    input reg_write,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] rd,
    input [31:0] write_data,
    output [31:0] reg_data1,
    output [31:0] reg_data2
);

    reg [31:0] registers[0:31];

    assign reg_data1 = registers[rs];
    assign reg_data2 = registers[rt];

    always @(posedge clk) begin
        if (reg_write)
            registers[rd] <= write_data;
    end

endmodule

module reg_fetch (
    input  wire [31:0] inst,
    input  wire        isRet,
    input  wire        isSt,
    input  wire [31:0] reg_data1,
    input  wire [31:0] reg_data2,
    input  wire [31:0] reg_data15,
    output wire [31:0] op1,
    output wire [31:0] op2
);

    wire [4:0] rs1, rs2, rd;

    assign rd  = inst[26:22];
    assign rs1 = isRet ? 5'd15 : inst[21:17];
    assign rs2 = isSt  ? rd     : inst[16:12];

    assign op1 = isRet ? reg_data15 : reg_data1;
    assign op2 = isSt  ? reg_data1  : reg_data2;

endmodule

module to_reg_file (
    input [3:0] rd,
    input [3:0] ra,
    input [31:0] aluResult,
    input [31:0] ldResult,
    input [31:0] pc,
    input isCall,
    input isLd,
    input isWb,
    output [3:0] reg1,
    output [31:0] writeData,
    output writeEnable
);

    wire [31:0] pc_plus_4 = pc + 4;

    assign writeData = isCall ? pc_plus_4 :
                       isLd   ? ldResult :
                                aluResult;

    MUX_Multiary mux_inst (
        .ip0(rd),
        .ip1(ra),
        .sel(isCall),
        .op(reg1)
    );

    assign writeEnable = isWb;

endmodule

module operand_select (
    input [31:0] inst,
    input isRet,
    input isSt,
    input [31:0] reg_data1,
    input [31:0] reg_data2,
    input [31:0] reg_data15,
    output [31:0] op1,
    output [31:0] op2
);

    wire [4:0] rd, rs1, rs2;

    assign rd  = inst[26:22];
    assign rs1 = isRet ? 5'd15 : inst[21:17];
    assign rs2 = isSt  ? rd     : inst[16:12];

    assign op1 = isRet ? reg_data15 : reg_data1;
    assign op2 = isSt  ? reg_data1  : reg_data2;

endmodule

module operand1_mux (
    input [31:0] output2,
    input [31:0] op1,
    output [31:0] op1_out,
    input wire isRet
);

    MUX immx_op_mux (
        .ip0(op1),
        .ip1(output2),
        .sel(isRet),
        .op(op1_out)
    );

endmodule

module opera_mux (
    input [31:0] immx,
    input [31:0] op2,
    output [31:0] op2_out,
    input wire isImmediate
);

    MUX immx_mux (
        .ip0(op2),
        .ip1(immx),
        .sel(isImmediate),
        .op(op2_out)
    );

endmodule
