`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: gpio_sega
// Create Date: 21/02/2021
// Description: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module gpio_sega(
    input           CLK_50,
    input           RESET,        // KEY0

    // Joystick input
    input           JOY_CS,
    input           JOY_BA,
    input           JOY_U,
    input           JOY_D,
    input           JOY_L,
    input           JOY_R,

    // Joystick output
    output          JOY_SEL,

    // LED output
    output [3:0]    BOARD_LEDS     // LED0..3
);

// clock
wire        clk;            // clock  
wire        locked;         // Goes high when the clock is stable

// Joystick
wire         joy_split;     //1(joy2), 0(joy1) 
wire [5:0]   Joy_raw;       // Joystick 1 input  
wire [11:0]  Joy1;          // Joystick 1 results
wire [11:0]  Joy2;          // Joystick 2 results


pll myclk (
		.refclk     (CLK_50),   //  refclk.clk
		.rst        (1'b0),     //  reset.reset
		.outclk_0   (clk),      //  outclk0.clk
		.locked     (locked)    //  locked.export
	);

assign Joy_raw = {JOY_CS, JOY_BA, JOY_U, JOY_D, JOY_L, JOY_R};


joy_db9md joy_db9md1
(
  .clk       ( CLK_50      ),   //50MHz
  .joy_in    ( Joy_raw ),       //CBUDLR
  .joy_mdsel ( JOY_SEL  ),      //pin 7 DB9   
  .joy_split ( joy_split ),     //1(joy2), 0(joy1)
  .joystick1 ( Joy1 ),          //----BA 9876543210
  .joystick2 ( Joy2 )           //----MS ZYXCBAUDLR
);

assign BOARD_LEDS[0] = Joy1[0] || Joy1[4] || Joy1[8]  || ~RESET;  
assign BOARD_LEDS[1] = Joy1[1] || Joy1[5] || Joy1[9]  || ~RESET;
assign BOARD_LEDS[2] = Joy1[2] || Joy1[6] || Joy1[10] || ~RESET;
assign BOARD_LEDS[3] = Joy1[3] || Joy1[7] || Joy1[11] || ~RESET;  

endmodule
