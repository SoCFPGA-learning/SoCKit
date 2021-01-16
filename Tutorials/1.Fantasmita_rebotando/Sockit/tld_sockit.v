`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: McLeod
// 
// Create Date:    16:55:26 06/21/2018 
// Design Name: 
// Module Name:    tld_sockit 
// Project Name:  El fantasmita rebotando
// Target Devices: 
// Tool versions: 
// Description: http://www.forofpga.es/viewtopic.php?f=32&t=40    Code from McLeod and instructions 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tld_sockit (
  input wire clk50mhz,  // cristal de 50 MHz
  output wire [7:0] r,  // Salidas R,G,B
  output wire [7:0] g,  // de 6 bits
  output wire [7:0] b,  // cada una
  output wire hsync,    // Sincronismos horizontal
  output wire vsync,     // y vertical
  output wire VGA_CLK,
  output wire VGA_SYNC_N,
  output wire VGA_BLANK_N
  );

  wire [7:0] r8b,g8b,b8b;
  assign r = r8b[7:0]; // como solo tenemos 6 bits por componente de color, asignamos de los 8 bits 
  assign g = g8b[7:0]; // originales de cada color solo los 6 bits mas significativos 
  assign b = b8b[7:0]; // (esto en ZX-UNO cambiaria a los 3 bits mas significativos)
	 
  wire clkvga;
  // cambiar el contenido de este modulo (reloj_cyclone) si hay que cambiar la frecuencia del reloj
  // si es que hemos cambiado el ModeLine en videosyncs.v para generar otra frecuencia distinta
  reloj_cyclone reloj (
	  .inclk0(clk50mhz),
	  .c0(clkvga)
	  );
    
  fantasma_rebotando el_ejemplo (
    .clk(clkvga),
    .r(r8b),
    .g(g8b),
    .b(b8b),
    .hsync(hsync),
    .vsync(vsync)
    );    
  assign VGA_BLANK_N = hsync && vsync;  //VGA DAC additional required pin	
  assign VGA_SYNC_N = 0; 					 //VGA DAC additional required pin
  assign VGA_CLK = clkvga; 			    //has to define a clock to VGA DAC clock otherwise the picture is noisy
	
endmodule

`default_nettype wire