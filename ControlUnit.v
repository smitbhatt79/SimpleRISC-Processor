module Control (
    input [4:0] opcode,        // Instruction opcode
    output reg isRet,
    output reg isSt,
    output reg isWb,
    output reg isImmediate,
    output reg isBeq,
    output reg isBgt,
    output reg isUBranch,
    output reg isLd,
    output reg isCall
);

    always @(*) begin
        // Reset all control signals
        {isRet, isSt, isWb, isImmediate, isBeq, isBgt, isUBranch, isLd, isCall} = 9'b0;

        if (opcode == 5'b00000) 
            begin
                isWb = 1;  // R-type
            end
        else if (opcode == 5'b00001) 
            begin
                isImmediate = 1;  // I-type
                isWb = 1;
            end
        else if (opcode == 5'b00010) 
            begin
                isLd = 1;  // Load
                isWb = 1;
            end 
        else if (opcode == 5'b00011) 
            begin
                isSt = 1;  // Store
            end
        else if (opcode == 5'b00100) 
            begin
                isBeq = 1;  // BEQ
                isUBranch = 1;
            end
        else if (opcode == 5'b00101) 
            begin
                isBgt = 1;  // BGT
                isUBranch = 1;
            end
        else if (opcode == 5'b00110) 
            begin
                isCall = 1;  // CALL
            end
        else if (opcode == 5'b00111) 
            begin
                isRet = 1;  // RETURN
            end
        // else: no control signals set
    end

endmodule
