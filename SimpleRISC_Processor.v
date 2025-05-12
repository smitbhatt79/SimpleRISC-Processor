module SimpleRISC_Processor (
    input clk,
    input rst
);

    wire isRet, isSt, isWb, isImmediate, isBeq, isBgt, isUBranch, isLd, isCall;
    wire [31:0] PC_NEXT, reg_data1, reg_data2, write_data, res_alu, instruction, reg_data15, ldResult, out_mux, op1, op2;
    wire [3:0] write_reg_4bit; 
    wire [4:0] write_reg;       
    wire [31:0] next_pc;
    reg [31:0] pc;

    ReadProgramFile imem (.addr(pc),.inst(instruction) );

    Control CU ( .opcode(instruction[31:27]), .isRet(isRet), .isSt(isSt), .isWb(isWb), .isImmediate(isImmediate), .isBeq(isBeq), .isBgt(isBgt), .isUBranch(isUBranch), .isLd(isLd), .isCall(isCall));

    reg_write regfile ( .clk(clk), .reg_write(isWb), .rs(instruction[21:17]), .rt(instruction[16:12]), .rd(write_reg), .write_data(write_data), .reg_data1(reg_data1), .reg_data2(reg_data2) );
    assign reg_data15 = regfile.registers[15];

    reg_fetch fetch_stage ( .inst(instruction), .isRet(isRet), .isSt(isSt), .reg_data1(reg_data1), .reg_data2(reg_data2), .reg_data15(reg_data15), .op1(op1), .op2(op2));

    MUX imm_mux (.ip0(op2),.ip1({{20{instruction[11]}}, instruction[11:0]}),.sel(isImmediate),.op(out_mux));

    ALU alu (.a(op1),.b(out_mux),.d(0),.type(instruction[26:22]),.sel(5'd0), .result(res_alu));

    memory_unit mem (.isLd(isLd),.isSt(isSt),.aluResult(res_alu),.op2(op2),.ldResult(ldResult));

    MUX wb_mux (.ip0(res_alu),.ip1(ldResult),.sel(isLd),.op(write_data));
    
    MUX_Multiary reg_dest_mux (.ip0(instruction[26:23]), .ip1(4'd15),.sel(isCall),.op(write_reg_4bit));
    assign write_reg = {1'b0, write_reg_4bit}; // pad to 5 bits (if needed)

    assign next_pc = pc + 4;    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc <= 0;
        else
            pc <= next_pc;
    end

endmodule