transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/task\ 2/task\ 2b/uart {E:/task 2/task 2b/uart/uart.v}

vlog -vlog01compat -work work +incdir+E:/task\ 2/task\ 2b/uart/simulation/modelsim {E:/task 2/task 2b/uart/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 670000 ns
