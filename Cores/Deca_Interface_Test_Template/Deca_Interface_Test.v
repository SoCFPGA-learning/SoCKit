`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: Deca_Interface_Test
// Create Date: 05/05/2022
// Description: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Deca_Interface_Test(
    input   CLK_50,
    input   RESET,        // KEY0
    
    // LED output
    output [3:0]    BOARD_LEDS,     // LED0..3

    // PS2
    input 	PS2_KEYBOARD_CLK,
    input 	PS2_KEYBOARD_DAT,
    input 	PS2_MOUSE_CLK,
    input 	PS2_MOUSE_DAT,
  
    // UART
    input   UART_RXD,
    input 	UART_TXD,  //output
    
    // JOYSTICK
    input   JOY1_B2_P9,
    input   JOY1_B1_P6,
    input   JOY1_UP,
    input   JOY1_DOWN,
    input   JOY1_LEFT,
    input   JOY1_RIGHT,
    input   JOYX_SEL_O,  //output
  
    //Pmod MicroSD
    inout [7:0]  PMOD1 

);

assign BOARD_LEDS[0] = PS2_KEYBOARD_CLK;
assign BOARD_LEDS[1] = PS2_KEYBOARD_DAT;
assign BOARD_LEDS[2] = PS2_MOUSE_CLK;
assign BOARD_LEDS[3] = PS2_MOUSE_DAT;

// assign BOARD_LEDS[0] = UART_RXD;
// assign BOARD_LEDS[1] = UART_TXD;
// assign BOARD_LEDS[2] = JOY1_B2_P9;
// assign BOARD_LEDS[3] = JOY1_B1_P6;

// assign BOARD_LEDS[0] = JOY1_UP;
// assign BOARD_LEDS[1] = JOY1_DOWN;
// assign BOARD_LEDS[2] = JOY1_LEFT;
// assign BOARD_LEDS[3] = JOY1_RIGHT;

// assign BOARD_LEDS[0] = JOYX_SEL_O;
// assign BOARD_LEDS[1] = PMOD1[0];
// assign BOARD_LEDS[2] = PMOD1[1];
// assign BOARD_LEDS[3] = PMOD1[2];

// assign BOARD_LEDS[0] = PMOD1[3];
// assign BOARD_LEDS[1] = PMOD1[4];
// assign BOARD_LEDS[2] = PMOD1[5];
// assign BOARD_LEDS[3] = PMOD1[6];

// assign BOARD_LEDS[0] = PMOD1[7];

// assign BOARD_LEDS[0] = PS2_KEYBOARD_CLK || UART_RXD || JOY1_UP    || JOYX_SEL_O || PMOD1[3] || PMOD1[7] || ~RESET;  
// assign BOARD_LEDS[1] = PS2_KEYBOARD_DAT || UART_TXD || JOY1_DOWN  || PMOD1[0]   || PMOD1[4] || ~RESET;
// assign BOARD_LEDS[2] = PS2_MOUSE_CLK  || JOY1_B2_P9 || JOY1_LEFT  || PMOD1[1]   || PMOD1[5] || ~RESET;
// assign BOARD_LEDS[3] = PS2_MOUSE_DAT  || JOY1_B1_P6 || JOY1_RIGHT || PMOD1[2]   || PMOD1[6] || ~RESET;  

endmodule
