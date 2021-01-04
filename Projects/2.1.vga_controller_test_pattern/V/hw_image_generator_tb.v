module hw_image_generator_tb();

  // Parameters

  // Ports
  reg  clk = 0;
  reg  disp_ena = 1;
  reg [31:0] row = 0;
  reg [31:0] column = 0;
  wire [7:0] VGA_R;
  wire [7:0] VGA_G;
  wire [7:0] VGA_B;

  //-- Registro para generar la señal de reloj
  //reg clk = 0;

  hw_image_generator 
   hw_image_generator_dut (
      .clk (clk),
      .disp_ena (disp_ena ),
      .row (row ),
      .column (column ),
      .VGA_R (VGA_R ),
      .VGA_G (VGA_G ),
      .VGA_B  (VGA_B)
    );

  initial begin
    begin
      //-- Fichero donde almacenar los resultados
      $dumpfile("hw_image_generator_tb.vcd");
      $dumpvars(0, hw_image_generator_tb);

 /*     # 0.5 if (data != 0)
              $display("ERROR! Contador NO está a 0!");
            else
              $display("Contador inicializado. OK.");
*/
      //# 99 $display("FIN de la simulacion");
      # 2000 $finish;
    end
  end

  //-- Generador de reloj. Periodo 2 unidades
  always #1 clk = ~clk;

  always @(posedge clk) begin
    if (column < 640)
      column <= column + 1'b1;
    else begin
      column <= 0;
      row <= row + 1'b1;
    end
    $display("Column: %d. Row: %d",column, row);
  end

endmodule

