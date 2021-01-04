//////////////////////////////////////////////////////////////////////////////////
//
// VGA 64 colors test   v3
// Antonio Sánchez
// for the Chameleon 96 Group
//
// Pixel freq. 25 MHz 
// Resolution  640x480
// 
// 04/01/21  Adapted for Sockit board
//
//////////////////////////////////////////////////////////////////////////////////

`define VisibleX    640
`define FrontX      16
`define SyncX       96
`define BackX       48
`define TotalX      800

`define VisibleY    480
`define FrontY      10
`define SyncY       2
`define BackY       33
`define TotalY      525

module hw_image_generator(
    input wire disp_ena,       //--display enable ('1' = display time, '0' = blanking time)
    input wire [31:0]row,       //row pixel coordinate
    input wire [31:0]column,    //column pixel coordinate
    output wire [7:0]VGA_R,     //red magnitude output to DAC
    output wire [7:0]VGA_G,     //green magnitude output to DAC
    output wire [7:0]VGA_B      //blue magnitude output to DAC
    );
    
wire clk;
reg [7:0]red;     //red magnitude 
reg [7:0]green;     //green magnitude 
reg [7:0]blue;      //blue magnitude 

reg [9:0] CounterX = 0;
reg [9:0] CounterY = 0;
reg [5:0] Color = 0;

assign clk = row[0];

always@(posedge clk)
begin
	if (!disp_ena)
		begin
			red <= 0;
			green <= 0;
			blue <= 0;
		end
	else
		begin  
            red <= Color[5:4]*7'b1010101;
            green <=  Color[3:2]*7'b1010101;
            blue <=  Color[1:0]*7'b1010101;
				
				//red <= Color[5:4];				//no output
            //red <= {4{Color[5:4]}};		//rare colours
   
		end
end

assign VGA_R = red;
assign VGA_G = green;
assign VGA_B = blue;

always  @(posedge clk) 
begin
    CounterX <= row[9:0];
    CounterY <= column[9:0];

    Color[2:0]<=((CounterX-`BackX)/40);
	Color[5:3]<=((CounterY-`FrontY)/60);

end

endmodule

