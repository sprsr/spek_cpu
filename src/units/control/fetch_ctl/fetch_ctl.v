module fetch_ctl(
    input        clk,
    input        rst,
    input  [31:0] instruction,
    output  [3:0] immSel,
    output [31:0] instr_de 
);

reg  [3:0]  r_immSel   = 4'b0;
reg [31:0]  r_instr_de;

assign immSel   = r_immSel;
assign instr_de = r_instr_de;
always @(posedge(clk) or posedge(rst)) begin
    if (rst) begin
        r_immSel  <= 4'h4;
    end else begin      
        case (instruction[6:0])
            // LUI Instruction: 
            7'b0110111: begin
                r_immSel  <= 4'h4;
            end
            // AUIPC Instruction: 
            7'b0010111: begin
                r_immSel  <= 4'h4;
            end
            // JAL Instruction:
            7'b1101111: begin
                r_immSel  <= 4'h5;
            end
            // JALR Instruction:
            7'b1101111: begin
                r_immSel  <= 4'h1;
            end
            7'b1100011: begin
                // BEQ Instruction:
                // BNE Instruction
                //BLT Instruction
                //BGE Instruction
                //BLTU Instruction
                //BGEU Instruction
                r_immSel  <= 4'h3;
            end
            7'b0000011: begin
                //LB Instruction
                //LH Instruction
                //LW Instruction
                //LBU Instruction
                //LHU Instruction
                r_immSel  <= 4'h1;
            end
            7'b0100011: begin
                // SB Instruction
                // SH Instruction
                // SW Instruction
                r_immSel  <= 4'h2;
            end
            7'b0010011: begin
                // ADDI Instruction
                // SLTI Instruction
                // SLTIU Instruction
                // XORI Instruction
                // ORI Instruction
                // ANDI Instruction
                // SLLI Instruction
                // SRLI Instruction
                // SRAI Instruction
                r_immSel  <= 4'h1;
            end
            7'b0110011: begin
                // ADD Instruction
                // SUB Instruction
                // SLL Instruction
                // SLT Instruction
                // SLTU Instruction
                // XOR Instruction
                // SRA Instruction
                // OR Instruction
                // AND Instruction
                r_immSel  <= 4'h0;
            end
            //  FENCE Instruction
            7'b0001111: begin
                r_immSel  <= 4'h0;
            end
            7'b1110011: begin
                //  @todo
                //  ECALL Instruction
                //  EBREAK Instruction
                //7'h1: begin
                r_immSel  <= 4'h0;
            end
        endcase
        r_instr_de <= instruction;
    end
end
endmodule
