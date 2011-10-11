#!/bin/bash

killtree() {
    local _pid=$1
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} 
    done
    kill -9 ${_pid} &> /dev/null
}

make_pid=0
while true; do
	inotifywait -r -e modify $2 &> /dev/null
	if [[ $make_pid -gt 0 ]]; then
		echo "killing process $make_pid"
		killtree $make_pid
	fi
	make $1 &
	make_pid=$!
done