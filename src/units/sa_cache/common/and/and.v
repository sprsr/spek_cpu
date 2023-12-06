// 2-input AND Gate Module

module AND(
  input wire i_a,  // Input A
  input wire i_b,  // Input B
  output wire o_y  // Output Y
);

  // AND gate logic
  assign o_y  = i_a & i_b;

endmodule
