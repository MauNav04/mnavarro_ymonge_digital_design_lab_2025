library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Se crea la entidad pero no tiene ninguna entrada o salidad debido a que se utiliza para simulación
entity tb_Restador_4bits is
end tb_Restador_4bits;

architecture instancia of tb_Restador_4bits is

    -- Señales internas para conectar al DUT (Dispositivo bajo prueba)
    signal A3, A2, A1, A0 : std_logic := '0';
    signal B3, B2, B1, B0 : std_logic := '0';
    signal C3, C2, C1, C0 : std_logic;

begin

    -- Instancia del módulo 
    UUT: entity work.Restador_4bits
        port map (
            A3 => A3, A2 => A2, A1 => A1, A0 => A0,
            B3 => B3, B2 => B2, B1 => B1, B0 => B0,
            C3 => C3, C2 => C2, C1 => C1, C0 => C0
        );

    -- Proceso de estímulos
    stim_proc: process
    begin
        -- Primer caso de prueba: 0000 - 0000
        A3 <= '0'; A2 <= '0'; A1 <= '0'; A0 <= '0';
        B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '0';
        wait for 10 ns;

        -- Segundo caso: 1010 - 0101
        A3 <= '1'; A2 <= '0'; A1 <= '1'; A0 <= '0';
        B3 <= '0'; B2 <= '1'; B1 <= '0'; B0 <= '1';
        wait for 10 ns;

        -- Tercer caso: 1111 - 0001
        A3 <= '1'; A2 <= '1'; A1 <= '1'; A0 <= '1';
        B3 <= '0'; B2 <= '0'; B1 <= '0'; B0 <= '1';
        wait for 10 ns;
		  
		  -- Cuarto caso: 1111-1111
		  A3 <= '1'; A2 <= '1'; A1 <= '1'; A0 <= '1';
        B3 <= '1'; B2 <= '1'; B1 <= '1'; B0 <= '1';
		  wait for 10 ns;

        -- Puedes agregar más casos de prueba aquí

        wait; -- Termina la simulación
    end process;

end instancia;