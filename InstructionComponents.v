module ReadProgramFile (
    input wire [31:0] addr,
    output wire [31:0] inst
);

    reg [31:0] memory [0:15];

    initial begin
       $readmemh("program.hex", memory);
    end

    assign inst = memory[addr[11:2]];

endmodule

module InstructionFetch (
    input wire clk,                         
    input wire reset,                       
    input wire [31:0] branchPC,             
    input wire [31:0] isBranchTaken,        
    output wire [31:0] inst,                
    output wire [31:0] pc_out               
);

    reg [31:0] pc;                          

    wire [31:0] pc_4;
    wire [31:0] next_pc;

    assign pc_out = pc;
    assign pc_4 = pc + 4;
    assign next_pc = isBranchTaken[0] ? branchPC : pc_4;

    ReadProgramFile imem (.addr(pc),.inst(inst));

    always @(negedge clk or posedge reset) begin
        pc <= reset ? 0 : next_pc;
    end

endmodule

module PC (
    input clk,
    input reset,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        pc <= reset ? 0 : next_pc;
    end
endmodule

module Immediate_Branch_Target (
    input  wire [31:0] pc,
    input  wire [31:0] instruction,
    output reg  [31:0] immx,
    output reg  [31:0] output2
);

    always @(*) begin
        immx = {{14{instruction[17]}}, instruction[17:0]};
        output2 = pc + {{3{instruction[26]}}, instruction[26:0], 2'b00};
    end

endmodule


