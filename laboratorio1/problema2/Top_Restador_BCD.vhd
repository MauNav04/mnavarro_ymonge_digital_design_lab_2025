-- Top module que conecta el Restador_4bits y el BCD_4b para uso en FPGA

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Restador_BCD is
    port (
        -- Entradas para los operandos del restador (puedes mapear a switches)
        A3, A2, A1, A0 : in std_logic;
        B3, B2, B1, B0 : in std_logic;
        -- Salidas para display de 7 segmentos (ánodo común)
        a, b, c, d, e, f, g : out std_logic
    );
end Top_Restador_BCD;

architecture gates of Top_Restador_BCD is

    -- Señales internas para conectar restador y BCD
    signal R3, R2, R1, R0 : std_logic;

begin

    -- Instancia del restador de 4 bits
    U1: entity work.Restador_4bits
        port map (
            A3 => A3,
            A2 => A2,
            A1 => A1,
            A0 => A0,
            B3 => B3,
            B2 => B2,
            B1 => B1,
            B0 => B0,
            C3 => R3,
            C2 => R2,
            C1 => R1,
            C0 => R0
        );

    -- Instancia del decodificador BCD a 7 segmentos
    U2: entity work.BCD4b_VHDL
        port map (
            A3 => R3,
            A2 => R2,
            A1 => R1,
            A0 => R0,
            a  => a,
            b  => b,
            c  => c,
            d  => d,
            e  => e,
            f  => f,
            g  => g
        );

end gates;