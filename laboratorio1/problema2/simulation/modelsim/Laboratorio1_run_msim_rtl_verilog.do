transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/flip_flop.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/contador_6bit.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/contador_top.sv}
vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/boton_incrementador.sv}

vlog -sv -work work +incdir+C:/Users/Yonathan\ Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/tb_contador_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_contador_top

add wave *
view structure
view signals
run -all
