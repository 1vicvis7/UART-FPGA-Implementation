module main_rx#(parameter N =7,parameter K =4,parameter C =3)(input rst_n,clk,data_in,gnd,output rst_n_led,clk_led,data_in_led,output [K-1:0]data_out,output outsignal,output [C-1:0]c,output [N+1:0]q);
//wire [3:0]c; //syndrome table
    wire [K-1:0]temp_data_out;
    assign rst_n_led = rst_n;
    assign clk_led = clk;
    assign data_in_led = data_in;
        rx #(N,K,C)rx1(rst_n,clk,data_in,q,outsignal);
        decoding #(N,K,C)f1(q[N:1],c);
        syn #(N,K,C)syn1(outsignal,c,q[N:C+1],temp_data_out);
        Encryption #(K,1)enc1(temp_data_out,data_out);
endmodule

module rx#(parameter N =7,parameter K =4,parameter C =3)(input rst_n,clk,data_in,output reg [N+1:0]q,output reg outsignal);
reg [3:0]count=0;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n) begin
        q <= 0;
        count <= 0;
        outsignal <= 0;
    end else begin
               q <= {data_in, q[N+1:1]};
        count <= count + 1;

        case(K)
            4: outsignal <= (count == 4'b0111); // After 7 bits (0 to 6)
            5: outsignal <= (count == 4'b1001); // After 9 bits (0 to 8)
            7: outsignal <= (count == 4'b1011); // After 11 bits (0 to 10)
            8: outsignal <= (count == 4'b1100); // After 12 bits (0 to 11)
            default: outsignal <= 0;
        endcase
    end
end
endmodule


module decoding#(parameter N =12,parameter K =8,parameter C =4)(input [N-1:0]d,output reg [C-1:0]c);
    // this module just decodes and detects for any error (finds c)
    always@(*)
        begin
            case(K)
                4: // (7,4)
                begin
                c[0] = d[6]^d[5]^d[3]^d[0];
                c[1] = d[6]^d[4]^d[3]^d[1];
                c[2] = d[6]^d[5]^d[4]^d[2];
                end
                5: //(9,5)
                begin
                c[0] = d[8]^d[7]^d[5]^d[4]^d[0];
                c[1] = d[8]^d[6]^d[5]^d[4]^d[1];
                c[2] = d[8]^d[7]^d[6]^d[4]^d[2];
                c[3] = d[8]^d[7]^d[6]^d[5]^d[3];
                end
                7: //(11,7)
                begin
                c[0] = d[10]^d[9]^d[8]^d[7]^d[4]^d[3];
                c[1] = d[10]^d[9]^d[7]^d[6]^d[5]^d[2];
                c[2] = d[10]^d[8]^d[7]^d[6]^d[1];
                c[3] = d[10]^d[9]^d[8]^d[6]^d[5]^d[4]^d[0];
                end
                8: //(12,8)
                begin
                c[0] = d[0]^d[4]^d[5]^d[7]^d[8]^d[10]^d[11];
                c[1] = d[1]^d[4]^d[5]^d[6]^d[8]^d[9]^d[11];
                c[2] = d[4]^d[2]^d[8]^d[9]^d[10];
                c[3] = d[3]^d[4]^d[5]^d[6]^d[7];
                end
            endcase
        end
endmodule

module syn#(parameter N =12,parameter K =8,parameter C =4)(input outsignal,input [C-1:0]c,input [K-1:0]d,output reg [K-1:0]data_out);
        //syndrome decoder corrects the errors
    always@(outsignal, c)
    begin
        data_out = d[K-1:0];
        case(K)
            4: // (7,4)
                begin
                case(c)
                3'b111: data_out[3] = d[3]^1;
                3'b101: data_out[2] = d[2]^1;
                3'b110: data_out[1] = d[1]^1;
                3'b011: data_out[0] = d[0]^1;
                endcase
                end
            5: //(9,5)
                begin
                case(c)
                4'b1111: data_out[4] = d[4]^1;
                4'b1101: data_out[3] = d[3]^1;
                4'b1110: data_out[2] = d[2]^1;
                4'b1011: data_out[1] = d[1]^1;
                4'b0111: data_out[0] = d[0]^1;
                endcase
                end
            7: //(11,7)
                begin
                case(c)
                4'b1111: data_out[6] = d[6]^1;
                4'b1101: data_out[5] = d[5]^1;
                4'b1011: data_out[4] = d[4]^1;
                4'b1110: data_out[3] = d[3]^1;
                4'b0111: data_out[2] = d[2]^1;
                4'b0101: data_out[1] = d[1]^1;
                4'b1001: data_out[0] = d[0]^1;
                endcase
                end
            8: //(12,8)
                begin
                case(c)
                4'b0011: data_out[7] = d[7]^1;
                4'b0101: data_out[6] = d[6]^1;
                4'b0110: data_out[5] = d[5]^1;
                4'b0111: data_out[4] = d[4]^1;
                4'b1001: data_out[3] = d[3]^1;
                4'b1010: data_out[2] = d[2]^1;
                4'b1011: data_out[1] = d[1]^1;
                4'b1111: data_out[0] = d[0]^1;
                endcase
                end
        endcase
    end
endmodule


module Encryption#(parameter K=4,parameter OpFun=4)(input [K-1:0]data,output reg [K-1:0]encrypted_data);
    always@(*)
        begin
        case(OpFun)
            1: //Simple XOR With 1 (NOT GATE)
            encrypted_data = ~data;
            2: //Right Shift by 1
            encrypted_data = {data[K-2:0],data[K-1]};
            3: //Left Shift by 1
            encrypted_data = {data[0],data[K-1:1]};
            4: //XOR with 1 and Left Shift by 1
            encrypted_data = {~data[0],~data[K-1:1]};
        endcase
    end
endmodule