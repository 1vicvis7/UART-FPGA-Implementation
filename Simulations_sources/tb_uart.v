`timescale 1ns / 1ps

module tb_uart;

    parameter N = 7;
    parameter K = 4;
    parameter C = 3;

    reg clk;
    reg rst_n;
    reg load;
    reg [K-1:0] data_in;
    wire [K-1:0] data_out;
	
    top dut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
      $dumpfile("uart_fpga.vcd");
      $dumpvars(1,tb_uart);
      
      
        rst_n = 0;
        load = 0;
        data_in = 4'b0000;

        #20;
        rst_n = 1;

        $display("Time: %0t | Test Case 1: Transmitting 4'b0100", $time);
        data_in = 4'b0100;
        #5; 
        
        load = 1; 
        #10;
        load = 0;

      #((N+2) * 10);
        $display("Time: %0t | Data received from receiver: %b", $time, data_out);
        $display("Time: %0t | Test Case 2: Transmitting 4'b1011", $time);
        data_in = 4'b1011;
        #5; 
        
        load = 1; 
        #10;
        load = 0; 
      
      #((N+2) * 10);
        $display("Time: %0t | Data received from receiver: %b", $time, data_out);
        #10 $finish;

        $monitor("Time: %0t ns | rst_n=%b, clk=%b, load=%b | data_in=%b | data_out=%b",
            $time, rst_n, clk, load, data_in, data_out);
    end

endmodule
