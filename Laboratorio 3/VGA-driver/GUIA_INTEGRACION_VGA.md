# 🎮 Juego de Memoria VGA - Guía de Integración

## 📁 Archivos Creados

### Módulos Nuevos:

1. **`generador_cartas.sv`** - Genera los 8 diseños diferentes de cartas
2. **`carta_oculta.sv`** - Diseño del reverso de las cartas (patrón de rombos azul)
3. **`cursor_overlay.sv`** - Borde dorado brillante para indicar el cursor
4. **`juego_vga_renderer.sv`** - Renderizador principal que integra todo
5. **`vga_integrado.sv`** - Top-level completo (VGA + juego_memoria)

## 🎨 Características Implementadas

### ✅ Grid de Cartas 4×4

- **Dimensiones**: 140×100 píxeles por carta
- **Espaciado**: 20px horizontal, 20px vertical
- **Total**: 16 cartas en pantalla 640×480

### ✅ Diseños de Cartas (8 tipos diferentes)

- **Carta 0**: Líneas horizontales (púrpura)
- **Carta 1**: Líneas verticales (púrpura)
- **Carta 2**: Patrón de ajedrez (cian)
- **Carta 3**: Línea diagonal (cian)
- **Carta 4**: Cruz (naranja)
- **Carta 5**: Círculo (naranja)
- **Carta 6**: X doble diagonal (rosa)
- **Carta 7**: Puntos (rosa)

### ✅ Estados Visuales

1. **Carta Oculta**: Reverso azul oscuro con rombos
2. **Carta Revelada**: Fondo blanco + patrón de la carta + esquinas de color
3. **Carta Bloqueada** (par encontrado): Fondo verde claro + esquinas de color
4. **Cursor Activo**: Borde dorado brillante de 5px

### ✅ Integración con FSM

- **`cartas_reveladas[15:0]`** - Controla qué cartas muestran su diseño
- **`cartas_bloqueadas[15:0]`** - Cartas con pares encontrados (fondo verde)
- **`cursor_fila/columna`** - Posición del cursor (borde dorado)
- **`carta_cursor_id`** - ID de la carta bajo el cursor

## 🔧 Cómo Usar

### Opción 1: Usar el top-level integrado (RECOMENDADO)

```systemverilog
// En vga_integrado.sv ya está todo conectado
module vga (
    input  logic        clk,           // 50 MHz
    input  logic        reset,

    // Controles del juego (botones)
    input  logic        mover_adelante,
    input  logic        mover_atras,
    input  logic        modo_vertical,
    input  logic        seleccionar,

    // Salidas VGA
    output logic        vgaclk, hsync, vsync, sync_b, blank_b,
    output logic [7:0]  r, g, b,

    // 7 segmentos (timer + puntajes)
    output logic        aL, bL, cL, dL, eL, fL, gL,
    output logic        aR, bR, cR, dR, eR, fR, gR,
    output logic        aJ1, bJ1, cJ1, dJ1, eJ1, fJ1, gJ1,
    output logic        aJ2, bJ2, cJ2, dJ2, eJ2, fJ2, gJ2
);
```

**Pasos:**

1. En Quartus, establecer `vga_integrado.sv` como **top-level entity**
2. Asignar pines en Pin Planner
3. Compilar y programar la FPGA

### Opción 2: Modificar tu vga.sv existente

Si prefieres modificar tu archivo actual:

1. Reemplaza el módulo `videoGen` con `juego_vga_renderer`
2. Instancia `juego_memoria` dentro del top-level
3. Conecta las señales de estado al renderer

## 📊 Mapeo de Cartas

```
Grid 4×4:
┌──────┬──────┬──────┬──────┐
│  0   │  1   │  2   │  3   │  Fila 0
├──────┼──────┼──────┼──────┤
│  4   │  5   │  6   │  7   │  Fila 1
├──────┼──────┼──────┼──────┤
│  8   │  9   │  10  │  11  │  Fila 2
├──────┼──────┼──────┼──────┤
│  12  │  13  │  14  │  15  │  Fila 3
└──────┴──────┴──────┴──────┘

Mapeo de IDs:
- Índices 0-1   → Carta ID 0 (líneas H)
- Índices 2-3   → Carta ID 1 (líneas V)
- Índices 4-5   → Carta ID 2 (ajedrez)
- Índices 6-7   → Carta ID 3 (diagonal)
- Índices 8-9   → Carta ID 4 (cruz)
- Índices 10-11 → Carta ID 5 (círculo)
- Índices 12-13 → Carta ID 6 (X)
- Índices 14-15 → Carta ID 7 (puntos)
```

## 🎯 Flujo del Juego Visual

1. **Inicio**: Todas las cartas ocultas (reverso azul)
2. **Jugador mueve cursor**: Borde dorado se mueve
3. **Jugador selecciona**: Carta se revela (muestra diseño)
4. **Segunda selección**: Otra carta se revela
5. **Si hay match**: Ambas cartas quedan con fondo verde (bloqueadas)
6. **Si no hay match**: Ambas vuelven a ocultas
7. **Fin del juego**: Todas las cartas con fondo verde

## 🔍 Debug/Pruebas

Para verificar que todo funciona:

1. **Comprobar señales en simulación**:

   ```systemverilog
   // En testbench, verificar:
   - cartas_reveladas cambia cuando se selecciona
   - cartas_bloqueadas se activa en pares encontrados
   - cursor_fila/columna sigue los movimientos
   ```

2. **En hardware**:
   - Mover cursor → El borde dorado se mueve
   - Seleccionar → Carta muestra su diseño
   - Par correcto → Cartas quedan verdes
   - Par incorrecto → Cartas vuelven a azul

## ⚙️ Parámetros Ajustables

En `juego_vga_renderer.sv`:

```systemverilog
localparam int CARD_WIDTH   = 140;  // Ancho de carta
localparam int CARD_HEIGHT  = 100;  // Alto de carta
localparam int SPACING_H    = 20;   // Espaciado horizontal
localparam int SPACING_V    = 20;   // Espaciado vertical
localparam int START_X      = 20;   // Margen izquierdo
localparam int START_Y      = 40;   // Margen superior
```

## 🚀 Próximos Pasos

1. ✅ Agregar todos los archivos `.sv` al proyecto Quartus
2. ✅ Establecer `vga_integrado` como top-level
3. ✅ Asignar pines en Pin Planner
4. ✅ Compilar (Processing → Start Compilation)
5. ✅ Programar FPGA
6. ✅ ¡Jugar!

## 🎨 Personalización

### Cambiar colores del reverso:

Editar `carta_oculta.sv`:

```systemverilog
back_r = 8'h10;  // Rojo
back_g = 8'h30;  // Verde
back_b = 8'h60;  // Azul (cambiar estos valores)
```

### Cambiar color del cursor:

Editar `juego_vga_renderer.sv`, línea ~237:

```systemverilog
r = 8'hFF;  // Dorado
g = 8'hD7;
b = 8'h00;
```

### Agregar más diseños de cartas:

Editar `generador_cartas.sv`, agregar más casos en el `case(carta_id)`.

---

**¡Listo para jugar! 🎮**
