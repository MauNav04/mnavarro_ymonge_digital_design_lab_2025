--Modulo que representa el restador completo de 4 bits en VHDL

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Entidad del módulo

entity Restador_4bits is
	port (
		A3 : in std_logic;
		A2 : in std_logic;
		A1 : in std_logic;
		A0 : in std_logic;
		B3 : in std_logic;
		B2 : in std_logic;
		B1 : in std_logic;
		B0 : in std_logic;
		C3 : out std_logic;
		C2 : out std_logic; 
		C1 : out std_logic;
		C0 : out std_logic
		);
end Restador_4bits;

--Arquitectura que determina la conexion de las entradas y salidas determinadas por la entidad

architecture gates of Restador_4bits is
begin 
	C3 <= A3 xor B3;
	C2 <= A2 xor B2;
	C1 <= A1 xor B1;
	C0 <= A0 xor B0;
end gates; 