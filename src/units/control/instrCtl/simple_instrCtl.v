module instr_ctl(
    input [31:0] instruction,
    input        BrEq,
    input        BrLT,
    output       a_sel,
    output       b_sel,
    output [3:0] alu_sel,
    output       sign,
    output       mem_wr,
    output       RegWEn,
    output [3:0] immSel,
    output       BrUn,
    output       pc_sel,
    output [1:0] wb_sel
);

reg       r_a_sel   = 1'b0;
reg       r_b_sel   = 1'b0;
reg [3:0] r_alu_sel = 4'b0;
reg       r_sign    = 1'b0;
reg       r_mem_wr  = 1'b0;
reg       r_RegWEn  = 1'b0;
reg [3:0] r_immSel  = 4'b0;
reg       r_BrUn    = 1'b0;
reg       r_pc_sel  = 1'b0;
reg [1:0] r_wb_sel  = 2'b0;

assign a_sel   = r_a_sel;
assign b_sel   = r_b_sel;
assign alu_sel = r_alu_sel;
assign mem_wr  = r_mem_wr;
assign RegWEn  = r_RegWEn;
assign immSel  = r_immSel;
assign BrUn    = r_BrUn;
assign pc_sel  = r_pc_sel;
assign wb_sel  = r_wb_sel;

always @(*) begin
    r_sign = 1'b0;
    // Currently every RV32I instruction is implemented in control.  
    // EFENCE, EBREAK, and ECALL require further control implementation.
    case (instruction[6:0])
        // LUI Instruction: 
        7'b0110111: begin
            r_a_sel   <= 1'b0;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0110;
            r_alu_sel <= 4'b0110;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h4;
            r_BrUn    <= 1'bx;
            r_pc_sel  <= 1'b0;
            r_wb_sel  <= 2'b01;
        end
        // AUIPC Instruction: 
        7'b0010111: begin
            r_a_sel   <= 1'b1;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0011;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h4;
            r_BrUn    <= 1'bx;
            r_pc_sel  <= 1'b0;
            r_wb_sel  <= 2'b01;
        end
        // JAL Instruction:
        7'b1101111: begin
            r_a_sel   <= 1'b1;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0011;
            r_sign    <= 1'b1;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h5;
            r_BrUn    <= 1'bx; 
            r_pc_sel  <= 1'b1;
            r_wb_sel  <= 2'b10;
        end
        // JALR Instruction:
        7'b1101111: begin
            r_a_sel   <= 1'b0;
            r_b_sel   <= 1'b1;
            r_alu_sel <= 4'b0010;
            r_sign    <= 1'b1;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b1;
            r_immSel  <= 4'h1;
            r_BrUn    <= 1'bx; 
            r_pc_sel  <= 1'b1;
            r_wb_sel  <= 2'b10;
        end
        7'b1100011: begin
            case (instruction[14:12])
                // BEQ Instruction:
                3'b000: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'bx; 
                    case (BrEq)
                        1'b0: r_pc_sel <= 1'b0;
                        1'b1: r_pc_sel <= 1'b1;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                // BNE Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'bx; 
                    case (BrEq)
                        1'b0: r_pc_sel <= 1'b1;
                        1'b1: r_pc_sel <= 1'b0;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                //BLT Instruction
                3'b010: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'b0; 
                    case (BrLT)
                        1'b0: r_pc_sel <= 1'b0;
                        1'b1: r_pc_sel <= 1'b1;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                //BGE Instruction
                3'b101: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'b0;
                    case (BrLT)
                        1'b0: r_pc_sel <= 1'b1;
                        1'b1: r_pc_sel <= 1'b0;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                //BLTU Instruction
                3'b110: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'b1;
                    case (BrLT)
                        1'b0: r_pc_sel <= 1'b0;
                        1'b1: r_pc_sel <= 1'b1;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
                //BGEU Instruction
                3'b111: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h3;
                    r_BrUn    <= 1'b1;
                    case (BrLT)
                        1'b0: r_pc_sel <= 1'b1;
                        1'b1: r_pc_sel <= 1'b0;
                    endcase
                    r_wb_sel  <= 2'bx;
                end
            endcase
        end
        7'b0000011: begin
            case (instruction[14:12])
                //LB Instruction
                3'b000: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                //LH Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                //LW Instruction
                3'b010: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                //LBU Instruction
                3'b100: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                //LHU Instruction
                3'b101: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
            endcase
        end
        7'b0100011: begin
            case (instruction[14:12])
                // SB Instruction
                3'b000: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b1;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h2;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                // SH Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b1;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h2;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                // SW Instruction
                3'b010: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b1;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h2;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
            endcase
        end
        7'b0010011: begin
            case (instruction[14:12])
                // ADDI Instruction
                3'b000: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0011;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SLTI Instruction
                3'b010: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b1100;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SLTIU Instruction
                3'b011: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b1011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // XORI Instruction
                3'b100: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0010;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // ORI Instruction
                3'b100: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0001;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // ANDI Instruction
                3'b111: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0000;
                    r_sign    <= 1'b1;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SLLI Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b1;
                    r_alu_sel <= 4'b0111;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h1;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                3'b101: begin
                    case (instruction[31:25])
                        // SRLI Instruction
                        7'b0000000: begin
                            r_a_sel   <= 1'b0;
                            r_b_sel   <= 1'b1;
                            r_alu_sel <= 4'b1000;
                            r_mem_wr  <= 1'b0;
                            r_RegWEn  <= 1'b1;
                            r_immSel  <= 4'h1;
                            r_BrUn    <= 1'b0;
                            r_pc_sel <= 1'b0;
                            r_wb_sel  <= 2'b1;
                        end
                        // SRAI Instruction
                        7'b0100000: begin
                            r_a_sel   <= 1'b0;
                            r_b_sel   <= 1'b1;
                            r_alu_sel <= 4'b1010;
                            r_mem_wr  <= 1'b0;
                            r_RegWEn  <= 1'b1;
                            r_immSel  <= 4'h1;
                            r_BrUn    <= 1'b0;
                            r_pc_sel <= 1'b0;
                            r_wb_sel  <= 2'b1;
                        end
                    endcase
                end
            endcase
        end
        7'b0110011: begin
            case (instruction[14:12]) 
                3'b000: begin
                    case (instruction[31:25])
                        // ADD Instruction
                        7'b0000000: begin
                            r_a_sel   <= 1'b0;
                            r_b_sel   <= 1'b0;
                            r_alu_sel <= 4'b0011;
                            r_mem_wr  <= 1'b0;
                            r_RegWEn  <= 1'b1;
                            r_immSel  <= 4'h0;
                            r_BrUn    <= 1'b0;
                            r_pc_sel <= 1'b0;
                            r_wb_sel  <= 2'b1;
                        end
                        // SUB Instruction
                        7'b0100000: begin
                            r_a_sel   <= 1'b0;
                            r_b_sel   <= 1'b0;
                            r_alu_sel <= 4'b0100;
                            r_mem_wr  <= 1'b0;
                            r_RegWEn  <= 1'b1;
                            r_immSel  <= 4'h0;
                            r_BrUn    <= 1'b0;
                            r_pc_sel <= 1'b0;
                            r_wb_sel  <= 2'b1;
                        end
                    endcase
                end
                // SLL Instruction
                3'b001: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0111;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SLT Instruction
                3'b010: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b1100;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SLTU Instruction
                3'b011: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b1011;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // XOR Instruction
                3'b100: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0010;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // SRA Instruction
                3'b100: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b1010;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // OR Instruction
                3'b110: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0001;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
                // AND Instruction
                3'b111: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0000;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b1;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b1;
                end
            endcase
        end
        //  FENCE Instruction
        7'b0001111: begin
                r_a_sel   <= 1'b0;
                r_b_sel   <= 1'b0;
                r_alu_sel <= 4'b0000;
                r_mem_wr  <= 1'b0;
                r_RegWEn  <= 1'b0;
                r_immSel  <= 4'h0;
                r_BrUn    <= 1'b0;
                r_pc_sel  <= 1'b0;
                r_wb_sel  <= 2'b0;
            end
        7'b1110011: begin
            case (instruction[31:20])
                //  @todo
                //  ECALL Instruction
                7'h0: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0000;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
                //  @todo 
                //  EBREAK Instruction
                7'h1: begin
                    r_a_sel   <= 1'b0;
                    r_b_sel   <= 1'b0;
                    r_alu_sel <= 4'b0000;
                    r_mem_wr  <= 1'b0;
                    r_RegWEn  <= 1'b0;
                    r_immSel  <= 4'h0;
                    r_BrUn    <= 1'b0;
                    r_pc_sel  <= 1'b0;
                    r_wb_sel  <= 2'b0;
                end
            endcase
        end
        default: begin
            r_a_sel   <= 1'b0;
            r_b_sel   <= 1'b0;
            r_alu_sel <= 4'b0000;
            r_mem_wr  <= 1'b0;
            r_RegWEn  <= 1'b0;
            r_immSel  <= 4'h0;
            r_BrUn    <= 1'b0;
            r_pc_sel  <= 1'b0;
            r_wb_sel  <= 2'b0;
        end
    endcase
end
endmodule
