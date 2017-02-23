#!/bin/bash
target=""
lttng_path="/usr/local/bin"
tools=('irqfreq' 'irqstats')
real_command=('lttng-irqfreq --stats' 'lttng-irqstats')
index=0

containsElement () {
	local e
	local i=255
	for e in "${@:2}"; do let "i=$i+1"; [[ "$e" == "$1" ]] && return $i; done
		return -1
}

if [ $# -eq 0 ]
	then
		echo "usage: ./generate_output.sh [output directory] [analyze tool list]"
		echo "example:"
		echo "        ./generate_output.sh test irqstats irqfreq"
elif [ $# -eq 1 ]
then
	target=${1%/}
	echo "no lttng-analysis tool selected, only babeltrace output will generte"
	babeltrace ./$target > ./babel_output/$target.babel
	echo "babel trace output generated at ./babel_output/$target.babel"
else
	target=${1%/}
	babeltrace ./$target > ./babel_output/$target.babel
	echo "babel trace output generated at ./babel_output/$target.babel"

	for tool in ${@:2}
	do
		containsElement $tool ${tools[@]}
		index=$?
		if [ $index	-eq 255 ]
		then
			echo "lttng-$tool is not exist"
		else
			${real_command[$index]} $target > ../analized-output/$target'.'$tool
		fi
	done
fi
