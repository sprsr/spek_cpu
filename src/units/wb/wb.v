module wb(input  [31:0]  dataR,
          input  [31:0]  alu_addr,
          input  [31:0]  pc_4,
          input         wb_sel,
          output [31:0] wb_out,
);

