transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/generador_carta_random.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/registro_seleccion.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/puntaje_jugadores.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/puntaje_display.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/juego_memoria.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/estado_cartas.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/control_cursor.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/temporizador_15s.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/fsm_cartas.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/flip_flop.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/divisor_1hz_50m.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/contador_4bit.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/bcd_contador_R.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/bcd_contador_L.sv}

vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio\ 3/VGA-driver {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Laboratorio 3/VGA-driver/tb_juego_memoria.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_juego_memoria

add wave *
view structure
view signals
run -all
