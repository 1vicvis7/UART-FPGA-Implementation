module top(
    input clk,
    input rst_n,
    input load,
    input [3:0] data_in,
    output [3:0] data_out
);

    // Internal wire to connect the transmitter's output to the receiver's input
    wire serial_data_link;

    // Correctly define gnd as a local wire
    wire gnd = 1'b0;

    // Instantiate the transmission module
    main_tx #(
        .N(7),
        .K(4)
    ) tx_inst (
        .clk_out(),
        .data_out_LED(),
        .gnd(gnd),
        .data_in(data_in),
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .data_out(serial_data_link),
        .led_data_in(),
        .led_encrypted_data(),
        .led_encoding_data_bit(),
        .temp()
    );

    // Instantiate the reception module
    main_rx #(
        .N(7),
        .K(4),
        .C(3)
    ) rx_inst (
        .rst_n(rst_n),
        .clk(clk),
        .data_in(serial_data_link), // Connect TX output to RX input
        .gnd(gnd),
        .rst_n_led(),
        .clk_led(),
        .data_in_led(),
        .data_out(data_out),
        .outsignal(),
        .c(),
        .q()
    );

endmodule
