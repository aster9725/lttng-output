#!/bin/bash

ARY_FREQ_LITTLE=('450000' '575000' '700000' '775000' '850000')
ARY_FREQ_BIG=('450000' '625000' '800000' '950000' '1100000')
A53="01"
A57="02"

set_eth_irq () {
	echo $1 > /proc/irq/31/smp_affinity
}

run_lttng_in_little () {
	set_eth_irq $A53
	for benchtype in IDLE CPU FILE
	do
		if [ $benchtype = CPU ]
		then
			taskset -c 0 sysbench --time=0 cpu run &
#			echo cpu
		fi
		if [ $benchtype = FILE ]
		then
			taskset -c 0 sysbench fileio prepare &
#			echo fileio
		fi
		for freq in "${ARY_FREQ_LITTLE[@]}"
		do
			echo $freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed && \
				lttng create A53_eth_"$benchtype"_$freq --output=~/lttng-traces/A53_eth_"$benchtype"_$freq && \
				lttng enable-event irq_handler_exit,irq_handler_entry -k && \
				lttng start && \
				sleep 10 && \
				lttng stop && \
				lttng destroy
#			echo $freq && \
#				echo "lttng create A53_eth_"$benchtype"_$freq --output=~/lttng-traces/A53_eth_"$benchtype"_$freq"
		done
		if [ "$(pgrep sysbench)" != "" ]
		then
			kill -9 $(pgrep sysbench)
			rm test*
#			echo "sysbench killed"
		fi
	done
}

run_lttng_in_big () {
	set_eth_irq $A57
	for benchtype in IDLE CPU FILE
	do
		if [ $benchtype = CPU ]
		then
			taskset -c 1 sysbench --time=0 cpu run &
#			echo cpu
		fi
		if [ $benchtype = FILE ]
		then
			taskset -c 1 sysbench fileio prepare &
#			echo fileio
		fi
		for freq in "${ARY_FREQ_LITTLE[@]}"
		do
			echo $freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed && \
				lttng create A57_eth_"$benchtype"_$freq --output=~/lttng-traces/A57_eth_"$benchtype"_$freq && \
				lttng enable-event irq_handler_exit,irq_handler_entry -k && \
				lttng start && \
				sleep 10 && \
				lttng stop && \
				lttng destroy
#			echo $freq && \
#				echo "lttng create A57_eth_"$benchtype"_$freq --output=~/lttng-traces/A57_eth_"$benchtype"_$freq"
		done
		if [ "$(pgrep sysbench)" != "" ]
		then
			kill -9 $(pgrep sysbench)
			rm test*
#			echo "sysbench killed"
		fi
	done

}

run_lttng_in_little
run_lttng_in_big
