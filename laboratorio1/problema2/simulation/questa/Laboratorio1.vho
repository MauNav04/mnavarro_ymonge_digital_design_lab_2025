-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 23.1std.0 Build 991 11/28/2023 SC Lite Edition"

-- DATE "08/22/2025 10:14:19"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for QuestaSim (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	Top_Restador_BCD IS
    PORT (
	A3 : IN std_logic;
	A2 : IN std_logic;
	A1 : IN std_logic;
	A0 : IN std_logic;
	B3 : IN std_logic;
	B2 : IN std_logic;
	B1 : IN std_logic;
	B0 : IN std_logic;
	a : BUFFER std_logic;
	b : BUFFER std_logic;
	c : BUFFER std_logic;
	d : BUFFER std_logic;
	e : BUFFER std_logic;
	f : BUFFER std_logic;
	g : BUFFER std_logic
	);
END Top_Restador_BCD;

-- Design Ports Information
-- a	=>  Location: PIN_W17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- b	=>  Location: PIN_V18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- c	=>  Location: PIN_AG17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- d	=>  Location: PIN_AG16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- e	=>  Location: PIN_AH17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- f	=>  Location: PIN_AG18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- g	=>  Location: PIN_AH18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A3	=>  Location: PIN_AC30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B3	=>  Location: PIN_AD30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A0	=>  Location: PIN_AB30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B0	=>  Location: PIN_W25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A2	=>  Location: PIN_AB28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B2	=>  Location: PIN_AC28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A1	=>  Location: PIN_Y27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B1	=>  Location: PIN_V25,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF Top_Restador_BCD IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A3 : std_logic;
SIGNAL ww_A2 : std_logic;
SIGNAL ww_A1 : std_logic;
SIGNAL ww_A0 : std_logic;
SIGNAL ww_B3 : std_logic;
SIGNAL ww_B2 : std_logic;
SIGNAL ww_B1 : std_logic;
SIGNAL ww_B0 : std_logic;
SIGNAL ww_a : std_logic;
SIGNAL ww_b : std_logic;
SIGNAL ww_c : std_logic;
SIGNAL ww_d : std_logic;
SIGNAL ww_e : std_logic;
SIGNAL ww_f : std_logic;
SIGNAL ww_g : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \B2~input_o\ : std_logic;
SIGNAL \A2~input_o\ : std_logic;
SIGNAL \U1|C2~0_combout\ : std_logic;
SIGNAL \B3~input_o\ : std_logic;
SIGNAL \A3~input_o\ : std_logic;
SIGNAL \U1|C3~0_combout\ : std_logic;
SIGNAL \B0~input_o\ : std_logic;
SIGNAL \A0~input_o\ : std_logic;
SIGNAL \U1|C0~combout\ : std_logic;
SIGNAL \B1~input_o\ : std_logic;
SIGNAL \A1~input_o\ : std_logic;
SIGNAL \U1|C1~0_combout\ : std_logic;
SIGNAL \U2|a~0_combout\ : std_logic;
SIGNAL \U2|b~0_combout\ : std_logic;
SIGNAL \U2|c~0_combout\ : std_logic;
SIGNAL \U2|d~0_combout\ : std_logic;
SIGNAL \U2|e~0_combout\ : std_logic;
SIGNAL \U2|f~0_combout\ : std_logic;
SIGNAL \U2|g~0_combout\ : std_logic;
SIGNAL \ALT_INV_B0~input_o\ : std_logic;
SIGNAL \ALT_INV_A3~input_o\ : std_logic;
SIGNAL \U1|ALT_INV_C0~combout\ : std_logic;
SIGNAL \ALT_INV_A0~input_o\ : std_logic;
SIGNAL \U1|ALT_INV_C2~0_combout\ : std_logic;
SIGNAL \U1|ALT_INV_C1~0_combout\ : std_logic;
SIGNAL \ALT_INV_A1~input_o\ : std_logic;
SIGNAL \U2|ALT_INV_g~0_combout\ : std_logic;
SIGNAL \ALT_INV_B1~input_o\ : std_logic;
SIGNAL \U2|ALT_INV_d~0_combout\ : std_logic;
SIGNAL \U2|ALT_INV_e~0_combout\ : std_logic;
SIGNAL \U2|ALT_INV_f~0_combout\ : std_logic;
SIGNAL \ALT_INV_B3~input_o\ : std_logic;
SIGNAL \ALT_INV_A2~input_o\ : std_logic;
SIGNAL \ALT_INV_B2~input_o\ : std_logic;
SIGNAL \U2|ALT_INV_b~0_combout\ : std_logic;
SIGNAL \U2|ALT_INV_a~0_combout\ : std_logic;
SIGNAL \U1|ALT_INV_C3~0_combout\ : std_logic;
SIGNAL \U2|ALT_INV_c~0_combout\ : std_logic;

BEGIN

ww_A3 <= A3;
ww_A2 <= A2;
ww_A1 <= A1;
ww_A0 <= A0;
ww_B3 <= B3;
ww_B2 <= B2;
ww_B1 <= B1;
ww_B0 <= B0;
a <= ww_a;
b <= ww_b;
c <= ww_c;
d <= ww_d;
e <= ww_e;
f <= ww_f;
g <= ww_g;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_B0~input_o\ <= NOT \B0~input_o\;
\ALT_INV_A3~input_o\ <= NOT \A3~input_o\;
\U1|ALT_INV_C0~combout\ <= NOT \U1|C0~combout\;
\ALT_INV_A0~input_o\ <= NOT \A0~input_o\;
\U1|ALT_INV_C2~0_combout\ <= NOT \U1|C2~0_combout\;
\U1|ALT_INV_C1~0_combout\ <= NOT \U1|C1~0_combout\;
\ALT_INV_A1~input_o\ <= NOT \A1~input_o\;
\U2|ALT_INV_g~0_combout\ <= NOT \U2|g~0_combout\;
\ALT_INV_B1~input_o\ <= NOT \B1~input_o\;
\U2|ALT_INV_d~0_combout\ <= NOT \U2|d~0_combout\;
\U2|ALT_INV_e~0_combout\ <= NOT \U2|e~0_combout\;
\U2|ALT_INV_f~0_combout\ <= NOT \U2|f~0_combout\;
\ALT_INV_B3~input_o\ <= NOT \B3~input_o\;
\ALT_INV_A2~input_o\ <= NOT \A2~input_o\;
\ALT_INV_B2~input_o\ <= NOT \B2~input_o\;
\U2|ALT_INV_b~0_combout\ <= NOT \U2|b~0_combout\;
\U2|ALT_INV_a~0_combout\ <= NOT \U2|a~0_combout\;
\U1|ALT_INV_C3~0_combout\ <= NOT \U1|C3~0_combout\;
\U2|ALT_INV_c~0_combout\ <= NOT \U2|c~0_combout\;

-- Location: IOOBUF_X60_Y0_N19
\a~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_a~0_combout\,
	devoe => ww_devoe,
	o => ww_a);

-- Location: IOOBUF_X80_Y0_N2
\b~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_b~0_combout\,
	devoe => ww_devoe,
	o => ww_b);

-- Location: IOOBUF_X50_Y0_N93
\c~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_c~0_combout\,
	devoe => ww_devoe,
	o => ww_c);

-- Location: IOOBUF_X50_Y0_N76
\d~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_d~0_combout\,
	devoe => ww_devoe,
	o => ww_d);

-- Location: IOOBUF_X56_Y0_N36
\e~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_e~0_combout\,
	devoe => ww_devoe,
	o => ww_e);

-- Location: IOOBUF_X58_Y0_N76
\f~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_f~0_combout\,
	devoe => ww_devoe,
	o => ww_f);

-- Location: IOOBUF_X56_Y0_N53
\g~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_g~0_combout\,
	devoe => ww_devoe,
	o => ww_g);

-- Location: IOIBUF_X89_Y20_N78
\B2~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B2,
	o => \B2~input_o\);

-- Location: IOIBUF_X89_Y21_N38
\A2~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A2,
	o => \A2~input_o\);

-- Location: LABCELL_X88_Y20_N6
\U1|C2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|C2~0_combout\ = ( \A2~input_o\ & ( !\B2~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011001100110011001100110011001100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_B2~input_o\,
	dataf => \ALT_INV_A2~input_o\,
	combout => \U1|C2~0_combout\);

-- Location: IOIBUF_X89_Y25_N38
\B3~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B3,
	o => \B3~input_o\);

-- Location: IOIBUF_X89_Y25_N55
\A3~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A3,
	o => \A3~input_o\);

-- Location: LABCELL_X80_Y25_N3
\U1|C3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|C3~0_combout\ = ( \A3~input_o\ & ( !\B3~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000011110000111100001111000011110000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_B3~input_o\,
	dataf => \ALT_INV_A3~input_o\,
	combout => \U1|C3~0_combout\);

-- Location: IOIBUF_X89_Y20_N44
\B0~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B0,
	o => \B0~input_o\);

-- Location: IOIBUF_X89_Y21_N4
\A0~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A0,
	o => \A0~input_o\);

-- Location: LABCELL_X88_Y20_N3
\U1|C0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|C0~combout\ = ( \A0~input_o\ & ( !\B0~input_o\ ) ) # ( !\A0~input_o\ & ( \B0~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010110101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B0~input_o\,
	dataf => \ALT_INV_A0~input_o\,
	combout => \U1|C0~combout\);

-- Location: IOIBUF_X89_Y20_N61
\B1~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B1,
	o => \B1~input_o\);

-- Location: IOIBUF_X89_Y25_N21
\A1~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A1,
	o => \A1~input_o\);

-- Location: LABCELL_X88_Y20_N15
\U1|C1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|C1~0_combout\ = ( \A1~input_o\ & ( !\B1~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000010101010101010101010101010101010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B1~input_o\,
	dataf => \ALT_INV_A1~input_o\,
	combout => \U1|C1~0_combout\);

-- Location: MLABCELL_X65_Y4_N3
\U2|a~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|a~0_combout\ = ( \U1|C1~0_combout\ & ( ((!\U1|C3~0_combout\) # (!\U1|C0~combout\)) # (\U1|C2~0_combout\) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C2~0_combout\ & ((!\U1|C0~combout\) # (\U1|C3~0_combout\))) # (\U1|C2~0_combout\ & (!\U1|C3~0_combout\ $ 
-- (!\U1|C0~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010111101011010111111111111010110101111010110101111111111110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C2~0_combout\,
	datac => \U1|ALT_INV_C3~0_combout\,
	datad => \U1|ALT_INV_C0~combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|a~0_combout\);

-- Location: MLABCELL_X65_Y4_N6
\U2|b~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|b~0_combout\ = ( \U1|C1~0_combout\ & ( (!\U1|C0~combout\ & ((!\U1|C2~0_combout\))) # (\U1|C0~combout\ & (!\U1|C3~0_combout\)) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C2~0_combout\) # (!\U1|C0~combout\ $ (\U1|C3~0_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111100111111001111001001110010011111001111110011110010011100100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C0~combout\,
	datab => \U1|ALT_INV_C3~0_combout\,
	datac => \U1|ALT_INV_C2~0_combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|b~0_combout\);

-- Location: MLABCELL_X65_Y4_N45
\U2|c~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|c~0_combout\ = ( \U1|C1~0_combout\ & ( (!\U1|C2~0_combout\ & ((\U1|C0~combout\) # (\U1|C3~0_combout\))) # (\U1|C2~0_combout\ & (!\U1|C3~0_combout\)) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C2~0_combout\) # ((!\U1|C3~0_combout\) # (\U1|C0~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111101011111111010110101111101011111010111111110101101011111010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C2~0_combout\,
	datac => \U1|ALT_INV_C3~0_combout\,
	datad => \U1|ALT_INV_C0~combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|c~0_combout\);

-- Location: MLABCELL_X65_Y4_N48
\U2|d~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|d~0_combout\ = ( \U1|C1~0_combout\ & ( (!\U1|C0~combout\ & ((!\U1|C3~0_combout\) # (\U1|C2~0_combout\))) # (\U1|C0~combout\ & ((!\U1|C2~0_combout\))) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C0~combout\ $ (\U1|C2~0_combout\)) # (\U1|C3~0_combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1011011110110111110110101101101010110111101101111101101011011010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C0~combout\,
	datab => \U1|ALT_INV_C3~0_combout\,
	datac => \U1|ALT_INV_C2~0_combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|d~0_combout\);

-- Location: MLABCELL_X65_Y4_N24
\U2|e~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|e~0_combout\ = ( \U1|C1~0_combout\ & ( (!\U1|C0~combout\) # (\U1|C3~0_combout\) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C2~0_combout\ & (!\U1|C0~combout\)) # (\U1|C2~0_combout\ & ((\U1|C3~0_combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1010001110100011101110111011101110100011101000111011101110111011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C0~combout\,
	datab => \U1|ALT_INV_C3~0_combout\,
	datac => \U1|ALT_INV_C2~0_combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|e~0_combout\);

-- Location: MLABCELL_X65_Y4_N33
\U2|f~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|f~0_combout\ = ( \U1|C1~0_combout\ & ( ((\U1|C2~0_combout\ & !\U1|C0~combout\)) # (\U1|C3~0_combout\) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C0~combout\) # (!\U1|C2~0_combout\ $ (!\U1|C3~0_combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1111111101011010010111110000111111111111010110100101111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C2~0_combout\,
	datac => \U1|ALT_INV_C3~0_combout\,
	datad => \U1|ALT_INV_C0~combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|f~0_combout\);

-- Location: MLABCELL_X65_Y4_N36
\U2|g~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|g~0_combout\ = ( \U1|C1~0_combout\ & ( (!\U1|C0~combout\) # ((!\U1|C2~0_combout\) # (\U1|C3~0_combout\)) ) ) # ( !\U1|C1~0_combout\ & ( (!\U1|C3~0_combout\ & ((\U1|C2~0_combout\))) # (\U1|C3~0_combout\ & ((!\U1|C2~0_combout\) # (\U1|C0~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110100111101111110111111101100111101001111011111101111111011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|ALT_INV_C0~combout\,
	datab => \U1|ALT_INV_C3~0_combout\,
	datac => \U1|ALT_INV_C2~0_combout\,
	datae => \U1|ALT_INV_C1~0_combout\,
	combout => \U2|g~0_combout\);

-- Location: MLABCELL_X47_Y13_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


