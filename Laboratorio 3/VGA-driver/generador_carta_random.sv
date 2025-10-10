
// Modulo: generador_carta_random
// Genera indices pseudoaleatorios de cartas disponibles usando
// protocolo de HANDSHAKE (start/listo).
//
// PROTOCOLO HANDSHAKE (comunicacion bidireccional):
// -------------------------------------------------
// * MASTER (FSM) envia START=1 
// * SLAVE (RNG) pone BUSY=1 
//* SLAVE encuentra carta valida pone LISTO=1 + INDICE valido (1 ciclo)
//  *MASTER lee LISTO=1  captura INDICE y baja START=0
// * SLAVE detecta START=0  vuelve a estado IDLE
//
// LFSR (Linear Feedback Shift Register):
//  genera secuencia pseudoaleatoria de 8 bits
// Se actualiza cada ciclo de reloj y siempre está ejecutandose
//  Provee punto de partida aleatorio para busqueda

module generador_carta_random (
    input  logic clk,
    input  logic reset,
    input  logic start,                 // HANDSHAKE: Master solicita carta (FSM)
    input  logic [15:0] cartas_reveladas,
    input  logic [15:0] cartas_bloqueadas,
    output logic listo,                 // HANDSHAKE: Slave confirma dato listo (RNG)
    output logic [3:0] indice           // Indice de carta valida (0-15)
);

    // Senales internas
    logic [7:0] lfsr;        // Linear Feedback Shift Register que es el generador "aleatorio"
    logic busy;              // Bandera interna: 1 = buscando carta valida
    logic [3:0] candidato;   // Indice candidato actual a verificar
    logic [4:0] intentos;    // Contador de intentos (max 16 para recorrer todas)

    // Mascara de cartas disponibles: ni reveladas ni bloqueadas
    logic [15:0] mascara_validos;
    assign mascara_validos = ~(cartas_reveladas | cartas_bloqueadas);
	 
	     // ---------------------------------------------------------------------------
    // Funcion: lfsr_next
    // Calcula siguiente valor del LFSR usando polinomio de realimentacion
    // Taps en posiciones [7,5,4,3] -> periodo maximo de 255 (2^8 - 1)
    function automatic logic [7:0] lfsr_next(input logic [7:0] current);
        logic feedback;
        feedback = current[7] ^ current[5] ^ current[4] ^ current[3];
        lfsr_next = (current == 8'd0) ? 8'h1 : {current[6:0], feedback};
    endfunction

      // ---------------------------------------------------------------------------
    // Funcion: primer_valido
    // Encuentra el primer bit en 1 de la mascara (fallback si busqueda falla)
    function automatic logic [3:0] primer_valido(input logic [15:0] mask);
        for (int i = 0; i < 16; i++) begin
            if (mask[i]) return i[3:0];
        end
        return 4'd0;
    endfunction

    // ---------------------------------------------------------------------------
    // Logica principal: Maquina de estados implicita (IDLE / BUSY)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr      <= 8'h5A;   // Semilla inicial (puede ser cualquier valor != 0)
            busy      <= 1'b0;    // Estado IDLE
            candidato <= 4'd0;
            intentos  <= 5'd0;
            listo     <= 1'b0;    // HANDSHAKE: no hay dato listo
            indice    <= 4'd0;
        end else begin
            // Por defecto, listo dura solo 1 ciclo (pulso)
            listo <= 1'b0;

            // FASE 1: DETECCION DE START "transicion IDLE al BUSY"

            // Cuando FSM activa START=1 y no estamos ocupados entonces pasa esto = 
            // *Activar BUSY (comenzar busqueda)
            // * Tomar bits inferiores del LFSR como punto de partida aleatorio
            //* Resetear contador de intentos
            if (start && !busy) begin
                busy      <= 1'b1;              // Entrar a estado BUSY
                candidato <= lfsr[3:0];         // Indice inicial aleatorio (0-15)
                intentos  <= 5'd0;
            end

    // ---------------------------------------------------------------------------
            // FASE 2: BUSQUEDA DE CARTA VALIDA "estado busy"

            if (busy) begin
                // Caso 1: Hay cartas disponibles
                if (mascara_validos != 16'd0) begin
                    // Verificar si el candidato actual es valido
                    if (mascara_validos[candidato]) begin
                        // ENCONTRADO! Activar handshake
                        indice <= candidato;    // Publicar resultado
                        listo  <= 1'b1;         // HANDSHAKE: dato listo 1 ciclo
                        busy   <= 1'b0;         // Volver a IDLE
                    end else begin
                        // Candidato no valido, probar siguiente haciendo busqueda circular
                        candidato <= candidato + 4'd1;  // 0->1->2->...->15->0
                        intentos  <= intentos + 5'd1;
                        
                        // Si probamos los 16 indices, usar fallback
                        if (intentos == 5'd15) begin
                            indice <= primer_valido(mascara_validos);
                            listo  <= 1'b1;     // HANDSHAKE: dato listo
                            busy   <= 1'b0;     // Volver a IDLE
                        end
                    end
                end 
                // Caso 2: No hay cartas disponibles (todas reveladas/bloqueadas)
                else begin
                    indice <= 4'd0;             // Valor por defecto
                    listo  <= 1'b1;             // HANDSHAKE: indicar fin
                    busy   <= 1'b0;             // Volver a IDLE
                end
            end

      // ---------------------------------------------------------------------------
            // LFSR: Actualizacion continua (siempre corriendo en background)

          // El LFSR avanza cada ciclo para que el proximo START tenga
            // un punto de partida diferente para que de mayor aleatoriedad
            lfsr <= lfsr_next(lfsr);
        end
    end

endmodule

