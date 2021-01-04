//////////////////////////////////////////////////////////////////////////////////
//
// VGA Test patter generator v1
//
// Pixel freq. 25 MHz 
// Resolution  640x480
//
//////////////////////////////////////////////////////////////////////////////////

module hw_image_generator(
    input wire clk,
    input wire disp_ena,       //--display enable ('1' = display time, '0' = blanking time)
    input wire [31:0]row,       //row pixel coordinate
    input wire [31:0]column,    //column pixel coordinate
    output wire [7:0]VGA_R,     //red magnitude output to DAC
    output wire [7:0]VGA_G,     //green magnitude output to DAC
    output wire [7:0]VGA_B      //blue magnitude output to DAC
    );
    
reg [7:0]red;       //red magnitude 
reg [7:0]green;     //green magnitude 
reg [7:0]blue;      //blue magnitude 

reg [9:0] CounterX = 0;
reg [9:0] CounterY = 0;

always@(posedge clk)
begin
    CounterX <= column[9:0];
    CounterY <= row[9:0];

    //https://www.fpga4fun.com/HDMI.html
    red = (disp_ena) ? {CounterX[5:0] & {6{CounterY[4:3]==~CounterX[4:3]}}, 2'b00} : 0;
    green = (disp_ena) ? CounterX[7:0] & {8{CounterY[6]}} : 0;
    blue = (disp_ena) ? CounterY[7:0] : 0;
end

assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

endmodule

