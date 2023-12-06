// The PC Module is handling most Fetching Logic with help of control unit (sel_pc)
module PC(
  input         clk,     // Clock input
  input         rst,     // Reset input
  input         stall,
  input         sel_pc,  // PC Select Control Signal
  input  [31:0] in_pc,   // input ALU
  input  [31:0] in_alu,  // input PC
  output [31:0] pc_nxt,  // Next
  output [31:0] pc,       // Program Counter output
  output [31:0] instr_fetch
);

    reg [31:0] w_pc;
    reg [31:0] w_pc_nxt;
    reg [31:0]  r_memory [0:1023];
    reg [31:0] r_instr_fetch; 

    assign pc = w_pc;
    assign pc_nxt = w_pc_nxt;
    assign instr_fetch = r_instr_fetch;

    initial begin
        /*
        r_memory[1] <= 32'b00000010000001000000001010010011;
        r_memory[2] <= 32'b00000010000001000000001010010011;
        r_memory[3] <= 32'b00000000100000010010000000100011;
        */

        r_memory[0] <= 32'b0;
        r_memory[1] <= 32'b00000000001000011110000110010011;
        r_memory[2] <= 32'b00000000010000011110000110010011;
        r_memory[3] <= 32'b00000000001000010100000100110011;
        r_memory[4] <= 32'b00000000100000010000000110010011;
        r_memory[5] <= 32'b00000000100000010000001000010011;
        r_memory[6] <= 32'b00000000010000011000010001100011;
        r_memory[7] <= 32'b00000000000100010110000100010011;
        r_memory[8] <= 32'b00000000000100010110000100010011;
        r_memory[9] <= 32'b00000000000100010110000100010011;
        r_memory[10] <= 32'b00000000000100010110000100010011;
        r_memory[11] <= 32'b00000000000100010110000100010011;
        r_memory[12] <= 32'b00000000000100010110000100010011;
        r_memory[13] <= 32'b00000000000100010110000100010011;
        r_memory[14] <= 32'b00000000010000011110000110010011;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            w_pc <= 0;  // Reset the program counter to 0
            w_pc_nxt <=0;
            r_instr_fetch <= 32'h0;
        end else begin
            if (sel_pc) begin
            w_pc <= in_alu;          // Increment the program counter if enabled
            w_pc_nxt <= in_alu + 'd1;
            r_instr_fetch <= r_memory[in_alu];
            end else begin
                w_pc <= in_pc;          // Increment the program counter if enabled
                w_pc_nxt <= in_pc + 'd1;
                r_instr_fetch <= r_memory[in_pc];
            end
            // If stall is true we force a NOP instruction
            /*
            if (stall)
                r_instr_fetch <= 32'b00000000000000000000000000010011;
            else
                */
                //r_instr_fetch <= r_memory[in_pc];
        end
    end

endmodule

