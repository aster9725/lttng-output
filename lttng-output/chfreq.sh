#!/system/bin/sh

LITTLE_FREQ=( "450000" "575000" "700000" "775000" "850000" )
BIG_FREQ=( "450000" "625000" "800000" "950000" "1100000" )
LITTLE=0
BIG=0

printAvailables () {
	echo "available frequency:"
	echo "        LITTLE : ${LITTLE_FREQ[*]}"
	echo "           BIG : ${BIG_FREQ[*]}"

}

printHelp () {
	echo "usage: chfreq.sh -l [little freq] -b [big freq]"
	printAvailables
	echo "example:"
	echo "        chfreq.sh 450000 0"
}

containsElementLittle () {
	local e
	for e in "${LITTLE_FREQ[@]}"; do
		[[ $e == $1 ]] && return 0;
	done
	printAvailables
	exit 1
}

containsElementBig () {
	local e
	for e in "${BIG_FREQ[@]}"; do
		[[ $e == $1 ]] && return 0;
	done
	printAvailables
	exit 1
}

changeLittleFreq () {
	if [ "$1" == "0" ]; then
		return 0
	fi
	containsElementLittle "$1" && echo $LITTLE > "/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"
}

changeBigFreq () {
	if [ "$1" == "0" ]; then
		return 0
	fi
	containsElementBig "$1" && echo $BIG > "/sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed"
}

if [ $# -eq 0 ]
then
	printHelp	
else
	while [[ $# -gt 1 ]]
	do
		key="$1"
		case $key in
			-l)
				LITTLE="$2"
				shift
				;;
			-b)
				BIG="$2"
				shift
				;;
			-h)
				printHelp
				exit 0
				shift
				;;
			*)
				printHelp
				shift
				;;
		esac
		shift
	done

	echo userspace > "/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor"
	echo userspace > "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

	changeLittleFreq "$LITTLE"
	changeBigFreq "$BIG" 
fi
