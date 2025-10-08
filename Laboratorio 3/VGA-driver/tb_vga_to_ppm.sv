`timescale 1ns/1ps
`default_nettype none

module tb_vga_to_ppm;

  // Clock 50 MHz
  logic clk = 1'b0;
  always #10 clk = ~clk;  // periodo 20 ns

  // Reset
  logic reset;
  initial begin
    reset = 1'b1;
    repeat (5) @(posedge clk);
    reset = 1'b0;
  end

  // Señales VGA
  logic        vgaclk, hsync, vsync, sync_b, blank_b;
  logic [7:0]  r, g, b;

  // DUT: tu módulo 'vga' tal cual lo pegaste
  vga dut (
    .clk     (clk),
    .reset   (reset),
    .vgaclk  (vgaclk),
    .hsync   (hsync),
    .vsync   (vsync),
    .sync_b  (sync_b),
    .blank_b (blank_b),
    .r       (r),
    .g       (g),
    .b       (b)
  );

  // Parámetros de frame
  localparam int WIDTH  = 640;
  localparam int HEIGHT = 480;
  localparam int TOTAL_PIX = WIDTH * HEIGHT;

  // Archivo PPM (P6 binario)
  integer fd;
  integer pix_count;

  initial begin
    // Abrir archivo
    fd = $fopen("frame0.ppm", "wb");
    if (fd == 0) $fatal(1, "No se pudo abrir frame0.ppm para escritura");
    // Header PPM P6: "P6\n<ancho> <alto>\n255\n"
    $fwrite(fd, "P6\n%0d %0d\n255\n", WIDTH, HEIGHT);

    pix_count = 0;

    // Esperar a que inicie la región visible del primer frame
    wait (blank_b === 1'b1);

    // Capturar píxel por píxel en orden raster (x asc, luego y++)
    // Escribimos SOLO cuando blank_b=1 (region visible)
  end

  // Muestreo sincronizado al pixel clock
  always @(posedge vgaclk) begin
    if (blank_b) begin
      // Escribir RGB como bytes (P6 binario)
      // %c escribe el byte tal cual (0..255)
      $fwrite(fd, "%c%c%c", r, g, b);
      pix_count <= pix_count + 1;

      if (pix_count == (TOTAL_PIX-1)) begin
        $display("[%0t] Frame completo: %0d pixeles escritos.", $time, TOTAL_PIX);
        $fclose(fd);
        $finish;
      end
    end
  end

endmodule

`default_nettype wire
