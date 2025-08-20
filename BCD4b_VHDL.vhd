-- Módulo que representa un decodificador hexadecimal a 7 segmentos (ánodo común)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidad del decodificador
entity BCD4b_VHDL is
    port(
        A3 : in std_logic;
        A2 : in std_logic;
        A1 : in std_logic;
        A0 : in std_logic;
        a  : out std_logic;
        b  : out std_logic;
        c  : out std_logic;
        d  : out std_logic;
        e  : out std_logic;
        f  : out std_logic;
        g  : out std_logic
    );
end BCD4b_VHDL;

-- Arquitectura: ecuaciones para display de 7 segmentos (ánodo común: 0 = encendido)
architecture gates of BCD4b_VHDL is
begin

    -- Segmento a
    a <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and not A2 and     A1 and not A0) or -- 2
        (not A3 and not A2 and     A1 and     A0) or -- 3
        (not A3 and     A2 and not A1 and     A0) or -- 5
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (not A3 and     A2 and     A1 and     A0) or -- 7
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and     A2 and not A1 and not A0) or -- C
        (    A3 and     A2 and     A1 and not A0) or -- E
        (    A3 and     A2 and     A1 and     A0)    -- F
    );

    -- Segmento b
    b <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and not A2 and not A1 and     A0) or -- 1
        (not A3 and not A2 and     A1 and not A0) or -- 2
        (not A3 and not A2 and     A1 and     A0) or -- 3
        (not A3 and     A2 and not A1 and not A0) or -- 4
        (not A3 and     A2 and     A1 and     A0) or -- 7
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and     A2 and not A1 and     A0)    -- D
    );

    -- Segmento c
    c <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and not A2 and not A1 and     A0) or -- 1
        (not A3 and not A2 and     A1 and     A0) or -- 3
        (not A3 and     A2 and not A1 and not A0) or -- 4
        (not A3 and     A2 and not A1 and     A0) or -- 5
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (not A3 and     A2 and     A1 and     A0) or -- 7
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and not A2 and     A1 and     A0) or -- B
        (    A3 and     A2 and not A1 and     A0)    -- D
    );

    -- Segmento d
    d <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and not A2 and     A1 and not A0) or -- 2
        (not A3 and not A2 and     A1 and     A0) or -- 3
        (not A3 and     A2 and not A1 and     A0) or -- 5
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and     A0) or -- B
        (    A3 and     A2 and not A1 and not A0) or -- C
        (    A3 and     A2 and not A1 and     A0) or -- D
        (    A3 and     A2 and     A1 and not A0)    -- E
    );

    -- Segmento e
    e <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and not A2 and     A1 and not A0) or -- 2
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and not A2 and     A1 and     A0) or -- B
        (    A3 and     A2 and not A1 and not A0) or -- C
        (    A3 and     A2 and not A1 and     A0) or -- D
        (    A3 and     A2 and     A1 and not A0) or -- E
        (    A3 and     A2 and     A1 and     A0)    -- F
    );

    -- Segmento f
    f <= not(
        (not A3 and not A2 and not A1 and not A0) or -- 0
        (not A3 and     A2 and not A1 and not A0) or -- 4
        (not A3 and     A2 and not A1 and     A0) or -- 5
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and not A2 and     A1 and     A0) or -- B
        (    A3 and     A2 and not A1 and not A0) or -- C
        (    A3 and     A2 and     A1 and not A0) or -- E
        (    A3 and     A2 and     A1 and     A0)    -- F
    );

    -- Segmento g
    g <= not(
        (not A3 and not A2 and     A1 and not A0) or -- 2
        (not A3 and not A2 and     A1 and     A0) or -- 3
        (not A3 and     A2 and not A1 and not A0) or -- 4
        (not A3 and     A2 and not A1 and     A0) or -- 5
        (not A3 and     A2 and     A1 and not A0) or -- 6
        (    A3 and not A2 and not A1 and not A0) or -- 8
        (    A3 and not A2 and not A1 and     A0) or -- 9
        (    A3 and not A2 and     A1 and not A0) or -- A
        (    A3 and not A2 and     A1 and     A0) or -- B
        (    A3 and     A2 and not A1 and     A0) or -- D
        (    A3 and     A2 and     A1 and not A0) or -- E
        (    A3 and     A2 and     A1 and     A0)    -- F
    );

end gates;