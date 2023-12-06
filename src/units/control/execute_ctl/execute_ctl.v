module execute_ctl(
    input         clk,
    input         rst,
    input         stall,
    input  [31:0] data_a,
    input  [31:0] data_b,
    input  [31:0] pc_de,
    input  [31:0] instruction,
    output [1:0]  a_sel,
    output        b_sel,
    output  [3:0] immSel,
    output        sign,
    output        BrUn,
    output [3:0]  br_expect,
    output [3:0]  alu_sel,
    output [31:0] data_a_exe,
    output [31:0] data_b_exe,
    output [31:0] pc_exe,
    output [31:0] instr_exe
);

reg [3:0]  r_br_expect;
reg [1:0]  r_a_sel;
reg        r_b_sel;
reg [3:0]  r_immSel;
reg [3:0]  r_alu_sel;
reg        r_sign;
reg [31:0] r_data_a_exe;
reg [31:0] r_data_b_exe;
reg [31:0] r_pc_exe;
reg [31:0] r_instr_exe;

assign immSel    = r_immSel;
assign alu_sel   = r_alu_sel;
assign a_sel     = r_a_sel;
assign b_sel     = r_b_sel;
assign sign      = r_sign;
assign data_a_exe = r_data_a_exe;
assign data_b_exe = r_data_b_exe;
assign pc_exe    = r_pc_exe;
assign instr_exe = r_instr_exe;
assign br_expect = r_br_expect;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        r_a_sel     <= 1'b0;
        r_b_sel     <= 1'b1;
        r_immSel    <= 4'h0;
        r_sign      <= 1'b0;
        r_alu_sel   <= 4'b0110;
        r_br_expect <= 3'b000;
        r_pc_exe    <= 32'h0;
        r_instr_exe <= 32'hxxxxxxxx;
    end else if (stall) begin
        r_a_sel     <= 1'b0;
        r_b_sel     <= 1'b1;
        r_immSel    <= 4'h0;
        r_sign      <= 1'b0;
        r_alu_sel   <= 4'b0110;
        r_br_expect <= 3'b000;
        r_pc_exe    <= 32'h0;
        r_instr_exe <= 32'b00000000000000000000000000010011;
    end else begin
        r_sign = 1'b0;

        // Currently every RV32I instruction is implemented in control.  
        // EFENCE, EBREAK, and ECALL require further control implementation.
        case (instruction[6:0])
            // LUI Instruction: 
            7'b0110111: begin
                r_a_sel   <= 2'b0;
                r_b_sel   <= 1'b1;
                r_immSel  <= 4'h4;
                r_sign    <= 1'b0;
                r_alu_sel <= 4'b0110;
                r_br_expect <= 3'b000;
            end
            // AUIPC Instruction: 
            7'b0010111: begin
                r_a_sel   <= 2'b1;
                r_b_sel   <= 1'b1;
                r_immSel  <= 4'h4;
                r_sign    <= 1'b0;
                r_alu_sel <= 4'b0011;
                r_br_expect <= 3'b000;
            end
            // JAL Instruction:
            7'b1101111: begin
                r_a_sel   <= 2'b1;
                r_b_sel   <= 1'b1;
                r_immSel  <= 4'h5;
                r_alu_sel <= 4'b0011;
                r_sign    <= 1'b1;
                r_br_expect <= 3'b000;
            end
            // JALR Instruction:
            7'b1100111: begin
                r_a_sel   <= 2'b0;
                r_b_sel   <= 1'b1;
                r_immSel  <= 4'h1;
                r_alu_sel <= 4'b0010;
                r_sign    <= 1'b1;
                r_br_expect <= 3'b000;
            end
            7'b1100011: begin
                r_immSel  <= 4'h3;
                r_a_sel   <= 2'b1;
                r_b_sel   <= 1'b1;
                r_alu_sel <= 4'b0011;
                case (instruction[14:12])
                    // BEQ Instruction:
                    3'b000: begin
                        r_br_expect <= 3'b001;
                    end
                    // BNE Instruction
                    3'b001: begin
                        r_br_expect <= 3'b010;
                    end
                    //BLT Instruction
                    3'b010: begin
                        r_br_expect <= 3'b011;
                    end
                    //BGE Instruction
                    3'b101: begin
                        r_br_expect <= 3'b100;
                    end
                    //BLTU Instruction
                    3'b110: begin
                        r_br_expect <= 3'b101;
                    end
                    //BGEU Instruction
                    3'b111: begin
                        r_br_expect <= 3'b110;
                    end
                endcase
            end
            7'b0000011: begin
                r_immSel  <= 4'h1;
                r_br_expect <= 3'b000;
                case (instruction[14:12])
                    //LB Instruction
                    3'b000: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                    //LH Instruction
                    3'b001: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                    //LW Instruction
                    3'b010: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                    //LBU Instruction
                    3'b100: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                    end
                    //LHU Instruction
                    3'b101: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                    end
                endcase
            end
            7'b0100011: begin
                r_immSel  <= 4'h2;
                r_br_expect <= 3'b000;
                case (instruction[14:12])
                    // SB Instruction
                    3'b000: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                    // SW Instruction
                    3'b010: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                endcase
            end
            7'b0010011: begin
                r_immSel  <= 4'h1;
                r_br_expect <= 3'b000;
                case (instruction[14:12])
                    // ADDI Instruction
                    3'b000: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0011;
                        r_sign    <= 1'b1;
                    end
                    // SLTI Instruction
                    3'b010: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b1100;
                    end
                    // SLTIU Instruction
                    3'b011: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b1011;
                    end
                    // XORI Instruction
                    3'b100: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0010;
                        r_sign    <= 1'b1;
                    end
                    // ORI Instruction
                    3'b110: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0001;
                        r_sign    <= 1'b1;
                    end
                    // ANDI Instruction
                    3'b111: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0000;
                        r_sign    <= 1'b1;
                    end
                    // SLLI Instruction
                    3'b001: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b1;
                        r_alu_sel <= 4'b0111;
                    end
                    3'b101: begin
                        case (instruction[31:25])
                            // SRLI Instruction
                            7'b0000000: begin
                                r_a_sel   <= 2'b0;
                                r_b_sel   <= 1'b1;
                                r_alu_sel <= 4'b1000;
                            end
                            // SRAI Instruction
                            7'b0100000: begin
                                r_a_sel   <= 2'b0;
                                r_b_sel   <= 1'b1;
                                r_alu_sel <= 4'b1010;
                            end
                        endcase
                    end
                endcase
            end
            7'b0110011: begin
                r_immSel  <= 4'h0;
                r_br_expect <= 3'b000;
                case (instruction[14:12]) 
                    3'b000: begin
                        case (instruction[31:25])
                            // ADD Instruction
                            7'b0000000: begin
                                r_a_sel   <= 2'b0;
                                r_b_sel   <= 1'b0;
                                r_alu_sel <= 4'b0011;
                            end
                            // SUB Instruction
                            7'b0100000: begin
                                r_a_sel   <= 2'b0;
                                r_b_sel   <= 1'b0;
                                r_alu_sel <= 4'b0100;
                            end
                        endcase
                    end
                    // SLL Instruction
                    3'b001: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b0111;
                    end
                    // SLT Instruction
                    3'b010: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b1100;
                    end
                    // SLTU Instruction
                    3'b011: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b1011;
                    end
                    // XOR Instruction
                    3'b100: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b0010;
                    end
                    // SRA Instruction
                    3'b100: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b1010;
                    end
                    // OR Instruction
                    3'b110: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b0001;
                    end
                    // AND Instruction
                    3'b111: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_alu_sel <= 4'b0000;
                    end
                endcase
            end
            //  FENCE Instruction
            7'b0001111: begin
                r_br_expect <= 3'b000;
                r_a_sel   <= 2'b0;
                r_b_sel   <= 1'b0;
                r_immSel  <= 4'h0;
                r_alu_sel <= 4'b0000;
            end
            7'b1110011: begin
                r_br_expect <= 3'b000;
                case (instruction[31:20])
                    //  @todo
                    //  ECALL Instruction
                    7'h0: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_immSel  <= 4'h0;
                        r_alu_sel <= 4'b0000;
                    end
                    //  @todo 
                    //  EBREAK Instruction
                    7'h1: begin
                        r_a_sel   <= 2'b0;
                        r_b_sel   <= 1'b0;
                        r_immSel  <= 4'h0;
                        r_alu_sel <= 4'b0000;
                    end
                endcase
            end
            default: begin
                r_br_expect <= 3'b000;
                r_a_sel   <= 2'b0;
                r_b_sel   <= 1'b0;
                r_immSel  <= 4'h0;
                r_alu_sel <= 4'b0000;
            end
        endcase
        r_data_a_exe <= data_a;
        r_data_b_exe <= data_b;
        r_pc_exe     <= pc_de;
        r_instr_exe  <= instruction;
    end
end
endmodule
