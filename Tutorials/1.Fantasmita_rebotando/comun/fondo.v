`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:41 08/24/2018 
// Design Name: 
// Module Name:    fondo 
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

module fondo (
  input wire [10:0] hc,
  input wire [10:0] vc,
  input wire display_enable,
  output reg [7:0] r,
  output reg [7:0] g,
  output reg [7:0] b
  );

  always @* begin
    if (display_enable == 1'b1) begin
      r = hc[7:0] ^ vc[7:0];
      g = hc[7:0] ^ vc[7:0];
      b = {hc[7], vc[7], 6'b000000};
    end
    else begin
      r = 8'h00;
      g = 8'h00;
      b = 8'h00;
    end
  end
endmodule

`default_nettype wire