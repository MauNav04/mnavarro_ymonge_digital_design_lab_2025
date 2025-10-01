`timescale 1ns/1ps
`default_nettype none

module tb_fsm_cartas;


  // Señales hacia/desde el DUT
  logic clk;
  logic rst;

  logic selec, valido, posicion_igual;
  logic match, pares_agotados, timeout, carta_random;

  logic start_15s, clear_15s, latch1, latch2, reveal1, reveal2;
  logic esconder_par, lock_par, incrementar_punto, cambiar_turno, carta_random_start;
  logic [3:0] state_dbg;

  // Estados (deben coincidir con el DUT: 0..9)
  localparam S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4,
             S5=4'd5, S6=4'd6, S7=4'd7, S8=4'd8, S9=4'd9;

  // DUT
  fsm_cartas dut (
    .clk, .rst,
    .selec, .valido, .posicion_igual, .match, .pares_agotados, .timeout, .carta_random,
    .start_15s, .clear_15s, .latch1, .latch2, .reveal1, .reveal2,
    .esconder_par, .lock_par, .incrementar_punto, .cambiar_turno, .carta_random_start,
    .state_dbg
  );

  // Reloj 100 MHz
  initial clk = 1'b0;
  always #5 clk = ~clk;

  task tick; begin @(posedge clk); #1; end endtask

  // Helper
  task automatic check_state(input [3:0] exp, input string msg);
    if (state_dbg !== exp)
      $fatal(1, "[%0t] ERROR: %s  estado=%0d  esperado=%0d",
             $time, msg, state_dbg, exp);
    else
      $display("[%0t] OK: %s  (estado=%0d)", $time, msg, state_dbg);
  endtask

  // Estímulos
  initial begin
    // Defaults
    selec=0; valido=0; posicion_igual=0;
    match=0; pares_agotados=0; timeout=0; carta_random=0;

    // Reset síncrono → S0 → S1
    rst=1; tick;  check_state(S0, "reset a S0_inicio");
    rst=0; tick;  check_state(S1, "S0 -> S1 (incondicional)");

    // ===== Caso A: Selección normal con MATCH (sin fin de juego) =====
    // S1: selec & valido -> S2
    selec=1; valido=1;        tick; check_state(S2,"S1->S2 por selec&valido");
    selec=0; valido=0;
    // S2 -> S3 (1 ciclo)
    tick;                     check_state(S3,"S2->S3 (revela1)");
    // S3 -> S4 (timeout=0)
    tick;                     check_state(S4,"S3->S4");
    // S4: segunda válida distinta -> S5
    selec=1; valido=1; posicion_igual=0;
    tick;                     check_state(S5,"S4->S5 (2da valida distinta)");
    selec=0; valido=0;
    // S5 -> S6 (1 ciclo), en S6: match=1, pares_agotados=0 -> S1
    match=1; pares_agotados=0;
    tick;                     check_state(S6,"S5->S6 (check)");
    tick;                     check_state(S1,"S6->S1 por match & !fin");

    // ===== Caso B: No MATCH (cambia turno) =====
    selec=1; valido=1;        tick; check_state(S2,"S1->S2");
    selec=0;                  tick; check_state(S3,"S2->S3");
    tick;                     check_state(S4,"S3->S4");
    selec=1; valido=1; posicion_igual=0;
    tick;                     check_state(S5,"S4->S5");
    selec=0; match=0;         tick; check_state(S6,"S5->S6");
    tick;                     check_state(S1,"S6->S1 por no-match");

    // ===== Caso C: Timeout en S1 -> RAND1, luego timeout en S3 -> RAND2 =====
    timeout=1;                tick; check_state(S7,"S1->S7 por timeout");
    timeout=0;
    repeat(2) tick;           check_state(S7,"permanece en S7 (esperando RNG)");
    carta_random=1;           tick; check_state(S2,"S7->S2 por carta_random");
    carta_random=0;
    tick;                     check_state(S3,"S2->S3 (revela1)");
    timeout=1;                tick; check_state(S8,"S3->S8 por timeout");
    timeout=0;
    carta_random=1;           tick; check_state(S5,"S8->S5 por carta_random");
    carta_random=0;
    match=0;                  tick; check_state(S6,"S5->S6");
    tick;                     check_state(S1,"S6->S1 por no-match");

    // ===== Caso D: Fin de juego =====
    selec=1; valido=1;        tick; check_state(S2,"S1->S2");
    selec=0;                  tick; check_state(S3,"S2->S3");
    tick;                     check_state(S4,"S3->S4");
    selec=1; valido=1; posicion_igual=0;
    tick;                     check_state(S5,"S4->S5");
    selec=0; match=1; pares_agotados=1;
    tick;                     check_state(S6,"S5->S6");
    tick;                     check_state(S9,"S6->S9 (fin de juego)");

    // Permanece en S9 hasta reset
    repeat(2) tick;           check_state(S9,"permanece en S9");
    rst=1;                    tick; check_state(S0,"reset a S0");
    rst=0;                    tick; check_state(S1,"S0->S1");

    $display("\n*** TESTBENCH COMPLETADO CON ÉXITO ***\n");
    $finish;
  end

endmodule

`default_nettype wire

