module main_tx#(parameter N =7,parameter K =4)(output clk_out, output data_out_LED, output gnd,input [K-1:0]data_in,input clk,rst_n,load,output data_out,output [K-1:0]led_data_in,output [K-1:0]led_encrypted_data,output [N-1:0]led_encoding_data_bit,output [N+1:0]temp);
    wire [N-1:0]encoding_data_bit;
    wire [K-1:0]encrypted_data_in;
        assign led_data_in = data_in;
        assign gnd = 0;
        assign clk_out = clk;
        assign data_out_LED = data_out;
            Encryption #(K,1)enc1(data_in,encrypted_data_in);
        assign led_encrypted_data=encrypted_data_in;
            encoding #(N,K)lbc(encrypted_data_in,encoding_data_bit);
        assign led_encoding_data_bit=encoding_data_bit;
            tx #(N,K)f1(clk,rst_n,load,encoding_data_bit,data_out,temp);
endmodule

module Encryption#(parameter K=4,parameter OpFun=1)(input [K-1:0]data,output reg [K-1:0]encrypted_data);
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

module encoding#(parameter N =11,parameter K =7)(input [0:K-1]data_in,output reg [0:N-1]data_out);
    always@(*)
        begin
            case(K)
                4: // (7,4)
                begin
                data_out[4] <= data_in[0]^data_in[1]^data_in[2];
                data_out[5] <= data_in[0]^data_in[2]^data_in[3];
                data_out[6]<=data_in[0]^data_in[1]^data_in[3];
                data_out[0:K-1] <= data_in;
                end
                5: //(9,5)
                begin
                data_out[5] <= data_in[0]^data_in[1]^data_in[2]^data_in[3];
                data_out[6] <= data_in[0]^data_in[1]^data_in[2]^data_in[4];
                data_out[7]<=data_in[0]^data_in[2]^data_in[3]^data_in[4];
                data_out[8]<=data_in[0]^data_in[1]^data_in[3]^data_in[4];
                data_out[0:K-1] <= data_in;
                end
                7: //(11,7)
                begin
                data_out[7] <= data_in[0]^data_in[1]^data_in[2]^data_in[3];
                data_out[8] <= data_in[0]^data_in[1]^data_in[2]^data_in[4];
                data_out[9]<=data_in[0]^data_in[2]^data_in[3]^data_in[4];
                data_out[10]<=data_in[0]^data_in[1]^data_in[3]^data_in[4];
                data_out[0:K-1] <= data_in;
                end
                8: //(12,8)
                begin
                data_out[8] <= data_in[4]^data_in[5]^data_in[6]^data_in[7];
                data_out[9] <= data_in[1]^data_in[2]^data_in[3]^data_in[7];
                data_out[10]<=data_in[0]^data_in[2]^data_in[3]^data_in[5]^data_in[6]^data_in[7];
                data_out[11]<=data_in[0]^data_in[1]^data_in[3]^data_in[4]^data_in[6]^data_in[7];
                data_out[0:K-1] <= data_in;
                end
            endcase
        end
endmodule

module tx#(parameter N=7,parameter K =4)(clk,rst_n,load,data_in,data_out,temp); //PISO_rtl
    input clk,rst_n,load;
    input [N-1:0]data_in;
    output data_out;
    output reg [N+1:0]temp; // To store the input when load = 1
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n) temp<=0;
            else 
                begin
                if(load) temp<={1'b1,data_in,1'b0};
                else temp<={1'b0,temp[N+1:1]};
                end
        end
    assign data_out=temp[0];
endmodule

