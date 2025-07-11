// `include "design.sv"
module tb;
  
  reg clk;
  reg rst;
  reg wen;
  reg ren;
  reg [31:0]data_in;
  wire [31:0]data_out;
  wire full, empty;
  
  fifo_sync dut(.*);
//   fifo_sync dut(.clk(clk),
//                 .rst(rst),
//                 .en(en),
//                 .data_in(data_in),
//                 .data_out(data_out),
//                 .full(full),
//                 .empty(empty)
//                );
  
  always #5 clk = ~clk;  
  
  task write_data(input [31:0] d_in); begin
    @(posedge clk);
    wen = 1;
    data_in = d_in;
    $display("Time = [%0t] write : data_in = %0d full =%0b",$time, data_in,full);
    @(posedge clk);
    wen = 0; 
    
    if(full)
      $display("FIFO is full");
//     else
//       $display("FIFO should be full");
  end
  endtask
  
  task read_data(); begin
    @(posedge clk);
    ren = 1;
    $display("Time = [%0t] read : data_out = %0d, empty = %0b", $time, data_out,empty);
    @(posedge clk);
    ren = 0;
    
    if(empty)
      $display("FIFO is empty");
//     else
//       $display("FIFO should be empty");
  end
  endtask
  
  initial begin
    #1;
    clk = 1;  wen = 0; ren = 0; data_in = 0;//     rst = 1;
	#3; rst = 0;
    #9; rst = 1;
    #12; rst = 0;
    
//     @(posedge clk)
//     rst = 0; //wen = 1;
    write_data(10);
    write_data(20);
    write_data(30);
    write_data(40);
    write_data(50);
    write_data(60);
    write_data(70);
    write_data(80);
    
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    
    for(integer i = 0; i <=9; i++) begin
      write_data(2**i);
      read_data();
    end
    
    #100; $finish;
  end
 
  
//   initial begin
//     clk = 1; rst = 1;
//     en = 0;
//     data_in = 0;
    
//     #10; rst = 0;
    
//     en = 1;
//     repeat(8) begin
//     data_in = $urandom_range(1,100);
//       #10;
  
//         if(full)
//       $display("FIFO is full");
//     else
//       $display("FIFO should be full");
    
//     en = 0;
//     repeat(8)
//       #10;
    
//     if(empty)
//       $display("FIFO is empty");
//     else
//       $display("FIFO should be empty");
//     end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars();
  end
  
  
endmodule