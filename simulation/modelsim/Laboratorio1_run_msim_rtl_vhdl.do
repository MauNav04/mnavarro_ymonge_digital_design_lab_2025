transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/Restador_4bits.vhd}

vcom -93 -work work {C:/Users/Yonathan Monge/Desktop/proyectos_quartus/Laboratorio1-Taller-Dise-o/tb_Restador_4bits.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  tb_Restador_4bits

add wave *
view structure
view signals
run -all
