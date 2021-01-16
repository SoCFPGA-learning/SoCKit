`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:26 06/21/2018 
// Design Name: 
// Module Name:    tld_zxuno 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module tld_unamiga (
  input wire clk50mhz,  // cristal de 50 MHz
  output wire [5:0] r,  // Salidas R,G,B
  output wire [5:0] g,  // de 6 bits
  output wire [5:0] b,  // cada una
  output wire hsync,    // Sincronismos horizontal
  output wire vsync     // y vertical
  );

  wire [7:0] r8b,g8b,b8b;
  assign r = r8b[7:2]; // como solo tenemos 6 bits por componente de color, asignamos de los 8 bits 
  assign g = g8b[7:2]; // originales de cada color solo los 6 bits mas significativos 
  assign b = b8b[7:2]; // (esto en ZX-UNO cambiaria a los 3 bits mas significativos)
	 
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
	 	 
endmodule

`default_nettype wire