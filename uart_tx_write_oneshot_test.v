 // Test that a write only happens once for each time write_i is pulled high.
module UartTxWriteOneshotTest ();

reg reset_i = 1'b0;
reg clock_i = 1'b0;
reg write_i = 1'b0;
reg two_stop_bits_i = 1'b0;
reg parity_bit_i = 1'b0;
reg parity_even_i = 1'b0;
reg [7:0] data_i = 8'h00;
wire serial_o;
wire busy_o;

reg [7:0] data = 8'h00;

UartTx uart_tx (
  .reset_i(reset_i),
  .clock_i(clock_i),
  .write_i(write_i),
  .two_stop_bits_i(two_stop_bits_i),
  .parity_bit_i(parity_bit_i),
  .parity_even_i(parity_even_i),
  .data_i(data_i),
  .serial_o(serial_o),
  .busy_o(busy_o)
);

always #1 clock_i <= ~clock_i;

always @ (posedge serial_o, negedge serial_o) begin
  if (!busy_o)
    $display("FAILED - busy_o should be high when serial_o transitions");
end

initial begin
  #1 reset_i = 1'b1;
  #1 reset_i = 1'b0;
  @ (negedge busy_o); // Wait for reset.


  #2
  data = 8'h55;
  data_i = data;
  write_i = 1'b1;

  #3 if (serial_o)
    $display("FAILED - start bit incorrect", $time);

  #870 if (serial_o != data[0])
    $display("FAILED - data bit 0 incorrect", $time);

  #870 if (serial_o != data[1])
    $display("FAILED - data bit 1 incorrect", $time);

  #870 if (serial_o != data[2])
    $display("FAILED - data bit 2 incorrect", $time);

  #870 if (serial_o != data[3])
    $display("FAILED - data bit 3 incorrect", $time);

  #870 if (serial_o != data[4])
    $display("FAILED - data bit 4 incorrect", $time);

  #870 if (serial_o != data[5])
    $display("FAILED - data bit 5 incorrect", $time);

  #870 if (serial_o != data[6])
    $display("FAILED - data bit 6 incorrect", $time);

  #870 if (serial_o != data[7])
    $display("FAILED - data bit 7 incorrect", $time);

  #870 if (!serial_o)
    $display("FAILED - stop bit incorrect", $time);

  #870 if (busy_o)
    $display("FAILED - busy_o should be low after sending first packet", $time);
  write_i = 1'b0;
  
end

endmodule
