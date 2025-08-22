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
--Declaramo las señales intermedias
	signal Y1 : std_logic;
	signal Y2 : std_logic;
	signal Y3 : std_logic;
	signal X1 : std_logic;
	signal X2 : std_logic;
	signal X3 : std_logic;
	

begin 
	Y1 <= A1 xor B1;           -- Primeras operaciónes
	Y2 <= A2 xor B2;
	Y3 <= A3 xor B3;
	
	X1 <= (not A1) and B1;     -- Segundas operaciónes  
	X2 <= (not A2) and B2;
	X3 <= (not A3) and B3;
	
	C0 <= A0 xor B0;				-- Resultado final
	C1 <= X1 xor Y1;           
	C2 <= X2 xor Y2;
	C3 <= X3 xor Y3;
	
end gates; 