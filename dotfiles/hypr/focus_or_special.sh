#!/usr/bin/env bash

execCommand=$1
className=$2

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\")")

if [[ $running == "" ]]
then
	echo "start"
	hyprctl dispatch exec [ workspace special:${className} ] ${execCommand} 
else 
	echo "toggle special"
	hyprctl dispatch togglespecialworkspace ${className}
fi