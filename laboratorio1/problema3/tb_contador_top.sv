`timescale 1ns/1ps

module tb_contador_top;

  // ===== Señales TB =====
  logic clk;
  logic btn_increment;
  logic switch_reset;
  logic [6:0] HEX0;
  logic [6:0] HEX1;

  // ===== Instancia del DUT =====
  contador_top dut (
    .clk           (clk),
    .btn_increment (btn_increment),
    .switch_reset  (switch_reset),
    .HEX0          (HEX0),
    .HEX1          (HEX1)
  );

  // ===== Taps jerárquicos para debug/verificación =====
 
  wire        btn_clean  = dut.btn_clean;    // pulso limpio del debouncer
  wire [5:0]  count_int  = dut.count;        // valor interno del contador

  // ===== Reloj 100 MHz (Periodo 10ns) =====
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // ===== Utilidades para prueba =====

  // "Pulsación" ideal (sin rebote): mantiene el botón en 1 por N ciclos de clk
  task automatic press_button(input int cycles_high = 10, input int cycles_low = 10);
    begin
      btn_increment = 1'b1;
      repeat (cycles_high) @(posedge clk);
      btn_increment = 1'b0;
      repeat (cycles_low)  @(posedge clk);
    end
  endtask

  // "Pulsación" con rebote simulado: alterna rápido antes de estabilizar
  task automatic press_button_bouncy(
      input int pre_bounce_toggles = 6,
      input int bounce_half_period_cycles = 1,
      input int hold_cycles = 10,
      input int after_low_cycles = 10
  );
    int i;
    begin
      // rebote: alterna rápido
      btn_increment = 1'b0;
      for (i = 0; i < pre_bounce_toggles; i++) begin
        repeat (bounce_half_period_cycles) @(posedge clk);
        btn_increment = ~btn_increment;
      end
      // estabiliza en 1 (botón presionado)
      btn_increment = 1'b1;
      repeat (hold_cycles) @(posedge clk);
      // suelta
      btn_increment = 1'b0;
      repeat (after_low_cycles) @(posedge clk);
    end
  endtask

  // Decodifica 7 segmentos (opcional, común cátodo activo-alto).
  // Si tu bcd_4b usa otra codificación, deja esto solo para imprimir crudo.
  function automatic string seg7_to_str(input logic [6:0] seg);
    // mapea típico: a b c d e f g = [6:0]
    // devuelve un hex (0-F) si coincide con patrón estándar, si no "?"
    case (seg)
      7'b1111110: seg7_to_str = "0";
      7'b0110000: seg7_to_str = "1";
      7'b1101101: seg7_to_str = "2";
      7'b1111001: seg7_to_str = "3";
      7'b0110011: seg7_to_str = "4";
      7'b1011011: seg7_to_str = "5";
      7'b1011111: seg7_to_str = "6";
      7'b1110000: seg7_to_str = "7";
      7'b1111111: seg7_to_str = "8";
      7'b1111011: seg7_to_str = "9";
      7'b1110111: seg7_to_str = "A";
      7'b0011111: seg7_to_str = "b";
      7'b1001110: seg7_to_str = "C";
      7'b0111101: seg7_to_str = "d";
      7'b1001111: seg7_to_str = "E";
      7'b1000111: seg7_to_str = "F";
      default:    seg7_to_str = "?";
    endcase
  endfunction

  // ===== Monitor & Checker =====
  logic [5:0] prev_count;
  logic       prev_clean;

  // Traza textual en cada flanco de clk
  always @(posedge clk) begin
    $display("t=%0t | rst=%0b btn_raw=%0b btn_clean=%0b | count=%0d (0x%0h) | HEX1=%b HEX0=%b | H1:%s H0:%s",
      $time, switch_reset, btn_increment, btn_clean, count_int, count_int,
      HEX1, HEX0, seg7_to_str(HEX1), seg7_to_str(HEX0));
  end

  // Pequeño checker: si hay flanco de subida en btn_clean, count debe incrementar en 1 (mod 64)
  always @(posedge clk) begin
    if (!switch_reset) begin
      if (btn_clean && !prev_clean) begin
        // flanco de subida detectado
        if (count_int !== (prev_count + 6'd1) % 64) begin
          $error("Contador no incrementó correctamente: prev=%0d actual=%0d", prev_count, count_int);
        end
      end
      prev_count <= count_int;
      prev_clean <= btn_clean;
    end else begin
      prev_count <= '0;
      prev_clean <= 1'b0;
    end
  end

  // ===== Estímulos =====
  initial begin
    // VCD (si usas ModelSim/Questa, puedes quedarte con esto o usar wlf)
    $dumpfile("contador_top_tb.vcd");
    $dumpvars(0, tb_contador_top);

    // Inicialización
    btn_increment = 1'b0;
    switch_reset  = 1'b1; // en reset
    prev_count    = '0;
    prev_clean    = 1'b0;

    $display("\n=== INICIO ===");

    // Mantén reset unas cuantas decenas de ns
    repeat (10) @(posedge clk);
    switch_reset = 1'b0; // libera reset
    repeat (10) @(posedge clk);

    // 1) Varias pulsaciones limpias
    $display("\n--- Pulsaciones limpias ---");
    repeat (5) press_button(12, 15);

    // 2) Pulsación con rebote simulado
    $display("\n--- Pulsación con rebote simulado ---");
    press_button_bouncy(8, 1, 12, 15);

    // 3) Ráfaga de pulsos rápidos (para ver si el debouncer filtra)
    $display("\n--- Ráfaga rápida ---");
    repeat (8) press_button(2, 3);

    // 4) Reset en medio y nueva pulsación
    $display("\n--- Reset intermedio ---");
    switch_reset = 1'b1;
    repeat (5) @(posedge clk);
    switch_reset = 1'b0;
    repeat (5) @(posedge clk);
    press_button(12, 10);

    $display("\n=== FIN ===");
    #50;
    $finish;
  end

endmodule