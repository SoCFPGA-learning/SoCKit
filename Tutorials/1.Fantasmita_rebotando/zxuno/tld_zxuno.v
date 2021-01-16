`timescale 1ns / 100ps
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

module tld_fantasma_zxuno (
  input wire clk50mhz,  // cristal de 50 MHz
  output wire [2:0] r,  // Salidas R,G,B
  output wire [2:0] g,  // de 3 bits
  output wire [2:0] b,  // cada una
  output wire hsync,    // Sincronismos horizontal
	output wire vsync,    // y vertical
  output wire stdn,     // control del
  output wire stdnb     // AD724
  );

  assign stdn = 1'b0;
  assign stdnb = 1'b1;

  wire [7:0] r8b,g8b,b8b;
  assign r = r8b[7:5]; // como solo tenemos 3 bits por componente de color, asignamos de los 8 bits 
  assign g = g8b[7:5]; // originales de cada color sólo los 3 bits más significativos 
  assign b = b8b[7:5]; // (esto en ZX-DOS cambiaría a los 6 bits más significativos)
	 
  wire clkvga;
  // cambiar el contenido de este módulo (relojes.v) si hay que cambiar la frecuencia del reloj
  // si es que hemos cambiado el ModeLine en videosyncs.v para generar otra frecuencia distinta
  reloj relojvga (  
    .CLKIN_IN(clk50mhz), 
    .CLKFX_OUT(clkvga), 
    .CLKIN_IBUFG_OUT(), 
    .CLK0_OUT()
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